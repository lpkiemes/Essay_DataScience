
## ----for loop Plots-----------------------------------------------------------------------------------------
for (i in 1:12) {
  
  list_plots[[i]] <- ggplot(
    data = list_data[[i]][["interest_over_time"]],
    aes(x = as.Date(date),
        y = hits,
        group = factor(keyword),
        color = keyword)) +
    geom_line(size = 1) +
    labs(
      x = "Zeit",
      y = "normalisierte, skalierte Aufrufe in Prozent",
      color = "Suchbegriff", 
      caption = paste0("Datenquelle: Google Trends 
          (https://www.google.com/trends, abgefragt am ", date_analysis, ").")
    ) +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 35, hjust = 1),
      plot.caption = element_text(size = 6, color = "gray60"),
      legend.title = element_text(size = 10),
      legend.text = element_text(size = 8),
      legend.position = "bottom") +
    scale_x_date(date_labels = "%Y",
                 date_breaks = "2 years",
                 date_minor_breaks = "1 year") +
    #scale_y_continuous(labels = scales::label_percent(scale = 1)) +
    ggsci::scale_colour_locuszoom()
  
  print(last_plot()) # anzeigen lassen
  
}

names(list_plots) <- c("prog_all_de", "prog_all_int", 
                       "prog_5y_de", "prog_5y_int", 
                       "prog_12_de", "prog_12m_int")


## ----for loop plot names------------------------------------------------------------------------------------
indice_5 <- c(3, 4, 9, 10)
indice_12 <- c(5, 6, 11, 12)

titles <- c(
  "Suchanfragen zu Programmiersprachen in Deutschland",
  "Suchanfragen zu Programmiersprachen weltweit",
  "Suchanfragen zu Programmiersprachen in Deutschland",
  "Suchanfragen zu Programmiersprachen weltweit",
  "Suchanfragen zu Programmiersprachen in Deutschland",
  "Suchanfragen zu Programmiersprachen weltweit",
  "Suchanfragen zu Programmen in Deutschland",
  "Suchanfragen zu Programmen weltweit",
  "Suchanfragen zu Programmen in Deutschland",
  "Suchanfragen zu Programmen weltweit",
  "Suchanfragen zu Programmen in Deutschland",
  "Suchanfragen zu Programmen weltweit"
)

subtitles <- c(
  "seit 2004",
  "seit 2004",
  "innerhalb der letzten fünf Jahre",
  "innerhalb der letzten fünf Jahre",
  "innerhalb der letzten 12 Monate",
  "innerhalb der letzten 12 Monate",
  "seit 2004",
  "seit 2004",
  "innerhalb der letzten fünf Jahre",
  "innerhalb der letzten fünf Jahre",
  "innerhalb der letzten 12 Monate",
  "innerhalb der letzten 12 Monate"
)

for (n in 1:12) {
  list_plots[[n]] <- list_plots[[n]] + labs(title = titles[[n]], subtitle = subtitles[[n]])
  
  if (n %in% indice_5) { # falls innerhalb der letzten 5 Jahre
    list_plots[[n]] <- list_plots[[n]] + scale_x_date(date_labels = "%Y",
                                                      date_breaks = "1 years",
                                                      date_minor_breaks = "1 months")
  } else if (n %in% indice_12) { # falls innerhalb der letzten 12 monate
    list_plots[[n]] <- list_plots[[n]] + scale_x_date(date_labels = "%B %Y",
                                                      date_breaks = "1 months")
  }
  
  ggsave(filename = paste0("plot_", n, ".pdf"), 
         plot = list_plots[[n]], 
         width = 9, height = 5, 
         path = here::here("plots"))
  
  ggsave(filename = paste0("small_plot_", n, ".pdf"), 
         plot = list_plots[[n]], 
         width = 6, 
         height = 6, 
         path = here::here("plots"))
  
  write_csv(as.data.frame(
    list_data[[1]][["interest_over_time"]]), 
    path = here::here("tables", paste0("table_time_", n, ".csv")))
}


## ----for loop plots 2 col-----------------------------------------------------------------------------------
list_plots_2col <- list() # leeere Liste zum Fuellen mit Doppel-Plots

for (i in 1:5) {
  
  list_plots_2col[[i]] <- list_plots[[i]] + list_plots[[i + 1]]
  print(list_plots_2col[[i]])
  
  ggsave(filename = paste0("2col_plot_", i, ".pdf"), 
         plot = list_plots_2col[[i]], 
         width = 12, 
         height = 6, 
         path = here::here("plots"))
  
}


## ----for loop plots 1 col-----------------------------------------------------------------------------------
list_plots_1col <- list() # leeere Liste zum Fuellen mit Doppel-Plots

for (i in 1:5) {
  
  list_plots_1col[[i]] <- list_plots[[i]] / list_plots[[i + 1]]
  print(list_plots_1col[[i]])
  
  ggsave(filename = paste0("1col_plot_", i, ".pdf"), 
         plot = list_plots_1col[[i]], 
         width = 8, 
         height = 8, 
         path = here::here("plots"))
  
}