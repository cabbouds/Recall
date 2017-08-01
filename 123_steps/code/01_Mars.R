##########   PARTE I: LOAD -> CLEAN -> IDIOMA -> SCORE -> SAVE    #############
#######   Requirements   ######################################################
library(tidyverse)
library("textcat") 
#######   Load Data ###########################################################
data_Mars <- read.table(file = "../data/Mars/Mars_new.csv", sep = ';' , fill = TRUE, header = TRUE)
#glimpse(data_Mars)
source(file = "../function/as.fecha.R") # as.fecha: as.Date() + TryCatch()
data_Mars["date"] <- as.Date(sapply(data_Mars$date, as.fecha), origin="1970-01-01") # sapply lo vovlió numerico, por eso necesita un as.Date + Origen para ser fecha otra vez

####### Filter: Date!=NA + idioma == english  #################################
data_Mars <- data_Mars[data_Mars["date"]!="1970-01-01",] # filtro NA
data_Mars["idioma"] = data.frame(unlist(lapply(data_Mars$text,textcat))) # detecta idioma
data_Mars <- data_Mars %>% filter(.,data_Mars["idioma"] =="english")

################    Score   ###################################################
pos.words <- scan('../lexicon/positive-words.txt', what='character', comment.char=';')
neg.words <- scan('../lexicon/negative-words.txt', what='character', comment.char=';')
source(file = "../function/score.sentiment.R")
data_Mars["score"] = score.sentiment(data_Mars$text, pos.words, neg.words)["score"]
data_Mars <- data_Mars[2:ncol(data_Mars)]

##################   Save   ###################################################
saveRDS(data_Mars,"../data/Mars/data_Mars_I.rds")
# Fin load