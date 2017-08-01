##########   PARTE I: LOAD -> CLEAN -> IDIOMA -> SCORE -> SAVE    #############
#######   Requirements   ######################################################
library(tidyverse)
library("textcat") 
#######   Load Data ###########################################################
data_Note7 <- read.table(file = "../data/Note7/Note7_new.csv", sep = ';' , fill = TRUE, header = TRUE)
#glimpse(data_Note7)
source(file = "../function/as.fecha.R") # as.fecha: as.Date() + TryCatch()
data_Note7["date"] <- as.Date(sapply(data_Note7$date, as.fecha), origin="1970-01-01") # sapply lo vovlió numerico, por eso necesita un as.Date + Origen para ser fecha otra vez

####### Filter: Date!=NA + idioma == english  ################################
data_Note7 <- data_Note7[data_Note7["date"]!="1970-01-01",] # filtro NA
data_Note7["idioma"] = data.frame(unlist(lapply(data_Note7$text,textcat))) # detecta idioma
data_Note7 <- data_Note7 %>% filter(.,data_Note7["idioma"] =="english")

################    Score   #################################################
pos.words <- scan('../lexicon/positive-words.txt', what='character', comment.char=';')
neg.words <- scan('../lexicon/negative-words.txt', what='character', comment.char=';')
source(file = "../function/score.sentiment.R")
data_Note7["score"] = score.sentiment(data_Note7$text, pos.words, neg.words)["score"]
data_Note7 <- data_Note7[2:ncol(data_Note7)]

##################   Save   ##############################################
saveRDS(data_Note7,"../data/Note7/data_Note7.rds")
# Fin load