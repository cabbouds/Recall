######################    Requirements   ######################################
library(twitteR)
library(tidyverse)
library("textcat") 
library(ggplot2)
library(reshape)
library(stringr)
library(lubridate)
library(scales)

#######   Load Data ##################################################
data_1 = read.table(file = "./data/note7_FB/note7_sem2_2016.csv", sep = "," , fill = TRUE, header = TRUE)
data_1 <- data_1 %>% filter(.,!is.na(shares))

saveRDS(data_1,"./data/en_proceso/data_1_new.rds")
data_1 <- readRDS("./data/en_proceso/data_1_new.rds")


# Diccionarios
pos.words <- scan('./lexicon/positive-words.txt', what='character', comment.char=';')
neg.words <- scan('./lexicon/negative-words.txt', what='character', comment.char=';')

# Score function
source(file = "./function/score.sentiment.R")
data_2 <-data_1; rm(data_1)
data_2["score"] = score.sentiment(data_2$label, pos.words, neg.words)["score"]
data_2 <-data_2 %>% mutate(date=as.Date(as.character(data_2$post_published)))
agrupada_FB = ddply(data_2,~date ,summarise,score = sum(score))
agrupada_FB = agrupada_FB[!is.na(agrupada_FB$date),]
#View(agrupada_FB)

# Plot Score 
ggplot(agrupada_FB, aes(y = score, x = date)) + 
  geom_line(aes(colour = score),size=1.5)  + 
  labs(title = "Facebook: Samsung Galaxy Mobile USA") + 
  scale_x_date(breaks = pretty_breaks(50), date_labels =  "%d-%m-%y" ) +
  ylab("Sentiment Score")+ 
  theme_bw()+
  scale_colour_gradient2()+
  theme(axis.text.y = element_text(size=15),
        axis.text.x = element_text(angle = 90, hjust = 1,size=13))



FB_1 <- ggplot(agrupada_FB, aes(y = score, x = date)) + 
  geom_line(aes(colour = score),size=1.5)  + 
  labs(title = "Facebook: 'Note7'") + 
  scale_x_date(breaks = pretty_breaks(75), date_labels =  "%d-%m-%y") +
  #limits = c(as.Date("2016-04-01", origin="1960-10-01"),as.Date("2017-06-01", origin="1960-10-01"))) +
  ylab("Net Score by Day")+ 
  theme_minimal() +#$theme_bw()+
  scale_colour_gradient2(low ="tomato3",mid = "lightgoldenrod1", high = "forestgreen") + #scale_colour_gradient2()+
  #scale_x_date(breaks = pretty_breaks(100), date_labels =  "") +
  theme(legend.position="none",
        plot.title = element_text(size = 14, face = "bold", vjust = 2, color = 'black', lineheight = 0.8),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        axis.text.y = element_text(size = 8, face = "bold", color = 'black'),
        axis.text.x = element_text(size = 8, face = "bold", color = 'black',angle = 80, hjust = 1)
  )

#######################################################################
