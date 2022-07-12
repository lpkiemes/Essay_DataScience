## ----packages verwenden und ordner erstellen----------------------------------------------------------------
here::i_am("Googletrends.Rmd")

# Falls pacman nicht installiert ist wird es installiert und geladen
if (!require("pacman")) install.packages("pacman"); library(pacman)

# Falls pakete nicht installiert sind werden sie installiert und Pakete werden geladen
pacman::p_load(tidyverse, gtrendsR, ggsci, maps, rtweet, patchwork, lubridate) 

dir.create("plots")
dir.create("tables")


## ----Analysedatum-------------------------------------------------------------------------------------------
date_analysis <- ymd("2022-07-01")


## ----Variationen definieren---------------------------------------------------------------------------------
data("countries") # Datensatz zu Laenderbezeichnungen
countries$country_code[which(countries$name == "GERMANY")] # Abkuerzung fuer Deutschland
keywords_5 <- data.frame(
  languages = c("python", "r", "java", "php", "javascript"), # Schluesselworte Programmieren
  
  text = c("sql", "excel", "word", "powerpoint", "tableau")) # Schlusselworte Programme
geos <- c("DE", "") # interessierende Laender
times <- c("all", "2017-07-01 2022-07-01", "today 12-m") # interessierende Zeitfenster
list_data <- list() # leere Liste zum Fuellen mit Datensaetzen
list_plots <- list() # leeere Liste zum Fuellen mit Plots


## ----for loop Daten-----------------------------------------------------------------------------------------
i <- 0 # Index zum Mitlaufen

for (k in keywords_5) {
  for (t in times) {
    for (g in geos) {
      
      i <- i + 1 # Indexzaehler
      print(paste(i, t, g, k)) # Iteration anzeigen
      
      list_data[[i]] <- gtrends(
        keyword = k,
        geo = g,
        time = t,
        gprop = "web",
        category = 0,
        hl = "en-US",
        compared_breakdown = TRUE,
        low_search_volume = FALSE,
        cookie_url = "http://trends.google.com/Cookies/NID",
        tz = 0,
        onlyInterest = FALSE
      )
      
      write_csv(as.data.frame( # Tabellen erstellen
        list_data[[i]][["interest_over_time"]]), 
        file = here::here("tables", paste0("table_", i, ".csv")))
      
    }
  }
}

names(list_data) <- c("prog_all_de", "prog_all_int", 
                      "prog_5y_de", "prog_5y_int", 
                      "prog_12_de", "prog_12m_int", 
                      "txt_all_de", "txt_all_int", 
                      "txt_5y_de", "txt_5y_int", 
                      "txt_12_de", "txt_12m_int")

