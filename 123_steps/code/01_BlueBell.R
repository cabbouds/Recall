##########   PARTE I: LOAD -> CLEAN -> IDIOMA -> SCORE -> SAVE    #############
#######   Requirements   ######################################################
library(tidyverse)
library("textcat") 
#######   Load Data ###########################################################
data_BlueBell <- read.table(file = "../data/BlueBell/BlueBell_new.csv", sep = ';' , fill = TRUE, header = TRUE)
#glimpse(data_BlueBell)
source(file = "../function/as.fecha.R") # as.fecha: as.Date() + TryCatch()
data_BlueBell["date"] <- as.Date(sapply(data_BlueBell$date, as.fecha), origin="1970-01-01") # sapply lo vovlió numerico, por eso necesita un as.Date + Origen para ser fecha otra vez

####### Filter: Date!=NA + idioma == english  #################################
data_BlueBell <- data_BlueBell[data_BlueBell["date"]!="1970-01-01",] # filtro NA
data_BlueBell["idioma"] = data.frame(unlist(lapply(data_BlueBell$text,textcat))) # detecta idioma
data_BlueBell <- data_BlueBell %>% filter(.,data_BlueBell["idioma"] =="english")

################    Score   ###################################################
pos.words <- scan('../lexicon/positive-words.txt', what='character', comment.char=';')
neg.words <- scan('../lexicon/negative-words.txt', what='character', comment.char=';')
source(file = "../function/score.sentiment.R")
data_BlueBell["score"] = score.sentiment(data_BlueBell$text, pos.words, neg.words)["score"]
data_BlueBell <- data_BlueBell[2:ncol(data_BlueBell)]

##################   Save   ###################################################
saveRDS(data_BlueBell,"../data/BlueBell/data_BlueBell_I.rds")
# Fin load