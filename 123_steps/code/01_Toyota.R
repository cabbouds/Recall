##########   PARTE I: LOAD -> CLEAN -> IDIOMA -> SCORE -> SAVE    #############
#######   Requirements   ######################################################
library(tidyverse)
library("textcat") 
#######   Load Data ###########################################################
data_Toyota <- read.table(file = "../data/Toyota/Toyota_new.csv", sep = ';' , fill = TRUE, header = TRUE)
#glimpse(data_Toyota)
source(file = "../function/as.fecha.R") # as.fecha: as.Date() + TryCatch()
data_Toyota["date"] <- as.Date(sapply(data_Toyota$date, as.fecha), origin="1970-01-01") # sapply lo vovlió numerico, por eso necesita un as.Date + Origen para ser fecha otra vez

####### Filter: Date!=NA + idioma == english  ################################
data_Toyota <- data_Toyota[data_Toyota["date"]!="1970-01-01",] # filtro NA
data_Toyota["idioma"] = data.frame(unlist(lapply(data_Toyota$text,textcat))) # detecta idioma
data_Toyota <- data_Toyota %>% filter(.,data_Toyota["idioma"] =="english")

################    Score   #################################################
pos.words <- scan('../lexicon/positive-words.txt', what='character', comment.char=';')
neg.words <- scan('../lexicon/negative-words.txt', what='character', comment.char=';')
source(file = "../function/score.sentiment.R")
data_Toyota["score"] = score.sentiment(data_Toyota$text, pos.words, neg.words)["score"]
data_Toyota <- data_Toyota[2:ncol(data_Toyota)]

##################   Save   ##############################################
saveRDS(data_Toyota,"../data/Toyota/data_Toyota_I.rds")
# Fin load