#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul  6 14:46:07 2022

@author: laurakiemes
"""
bearer="AAAAAAAAAAAAAAAAAAAAAAWHZAEAAAAAhHIicgDn3R9yS7nBtA9d%2FpkhqCs%3DU77ZArq8vNCTAndsFUhjQrhpI38w06Gsv3pOraXgeLD0xsd24v"
from textblob import TextBlob 
import tweepy
client = tweepy.Client(bearer_token=bearer, wait_on_rate_limit=True)

search_query = "python"


# your start and end time for fetching tweets
# UTC! bei search_all_tweets: wenn nicht angegeben, 30 Tage zurück
start_time = "2022-06-01T00:00:00Z" 
end_time = "2022-07-01T00:00:00Z" 

#tweets laden
tweets = client.search_all_tweets(query=search_query,
                                     start_time=start_time,
                                     end_time=end_time,
									 tweet_fields=["text","id","context_annotations","created_at","geo","source"],
                                     user_fields = ["name", "username", "location", "verified"], # ohne "description", weil die gerne mal auch länger sind
                                     max_results = 100,
                                     expansions='author_id'
                                     )

import pandas as pd

# eine leere Liste anlegen für alle tweets, damit wir aus dem Format von tweepy heraus kommen
listTweets = []

# über  jeden tweet iterieren
#HIER fügen wir nun unsere sentiment analysis ein, da wir in dieser for-Schleife sowieso schon jeden Tweet einzeln in die Hand nehmen müssen, um aus dem client.Response Objekt ein Set und aus den sets eine Liste zu machen, die dann in ein dataFrame gelesen werden kann.

for tweet, user in zip(tweets.data, tweets.includes['users']): #zip() ist eine Funktion, um Elemente in Tuplen aufzulisten. Diese können dann einfach in Schleifen verarbeitet werden
    blobTweet = TextBlob (tweet.text) #wir erstellen das blob-Objekt für jeden Tweet neu.
    setTweetData= {#alle Daten, die wir abgerufen haben
        'created_at': tweet.created_at,
        'text': tweet.text, 
        'sentiment': blobTweet.sentiment, #HIER passiert die Analyse. Das blob-Objekt wird nur dazu im Arbeitsspeicher erzeugt und danach wieder verworfen
        'sentiment_polarity': blobTweet.sentiment.polarity,
        'source': tweet.source, #rest belassen wir wie vorige Woche
		'context_annotations': tweet.context_annotations,
		'geo': tweet.geo,
        'name': user.name,
        'username': user.username,
        'location': user.location,
        'verified': user.verified
    }
    listTweets.append(setTweetData) #das Set (einen Datensatz) als eine Zeile an die Liste hinten anhängen

#die gesammelten Daten in den DataFrame speichern
dfTweets = pd.DataFrame(listTweets)

#nun exportieren wir den pandas.DataFrame in eine Datei zur Weiterbearbeitung
dfTweets.to_csv('./tweet_sentiment_python.csv',index=False, sep=';') 

