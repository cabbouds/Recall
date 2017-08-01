##########   PARTE I: LOAD -> CLEAN -> IDIOMA -> SCORE -> SAVE    #############
#######   Requirements   ######################################################
library(tidyverse)
library("textcat") 
#######   Load Data ###########################################################
data_Hoverboard <- read.table(file = "../data/Hoverboard/Hoverboard_new.csv", sep = ';' , fill = TRUE, header = TRUE)
#glimpse(data_Hoverboard)
source(file = "../function/as.fecha.R") # as.fecha: as.Date() + TryCatch()
data_Hoverboard["date"] <- as.Date(sapply(data_Hoverboard$date, as.fecha), origin="1970-01-01") # sapply lo vovlió numerico, por eso necesita un as.Date + Origen para ser fecha otra vez

####### Filter: Date!=NA + idioma == english  ################################
data_Hoverboard <- data_Hoverboard[data_Hoverboard["date"]!="1970-01-01",] # filtro NA
data_Hoverboard["idioma"] = data.frame(unlist(lapply(data_Hoverboard$text,textcat))) # detecta idioma
data_Hoverboard <- data_Hoverboard %>% filter(.,data_Hoverboard["idioma"] =="english")

################    Score   #################################################
pos.words <- scan('../lexicon/positive-words.txt', what='character', comment.char=';')
neg.words <- scan('../lexicon/negative-words.txt', what='character', comment.char=';')
source(file = "../function/score.sentiment.R")
data_Hoverboard["score"] = score.sentiment(data_Hoverboard$text, pos.words, neg.words)["score"]
data_Hoverboard <- data_Hoverboard[2:ncol(data_Hoverboard)]

##################   Save   ##############################################
saveRDS(data_Hoverboard,"../data/Hoverboard/data_Hoverboard_I.rds")
# Fin load