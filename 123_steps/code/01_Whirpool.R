##########   PARTE I: LOAD -> CLEAN -> IDIOMA -> SCORE -> SAVE    #############
#######   Requirements   ######################################################
library(tidyverse)
library("textcat") 
#######   Load Data ###########################################################
data_Whirpool <- read.table(file = "./data/Whirpool/Whirpool_new.csv", sep = ';' , fill = TRUE, header = TRUE)
#glimpse(data_Whirpool)
source(file = "../function/as.fecha.R") # as.fecha: as.Date() + TryCatch()
data_Whirpool["date"] <- as.Date(sapply(data_Whirpool$date, as.fecha), origin="1970-01-01") # sapply lo vovlió numerico, por eso necesita un as.Date + Origen para ser fecha otra vez
#View(data_Whirpool)
####### Filter: Date!=NA + idioma == english  ################################
data_Whirpool <- data_Whirpool[data_Whirpool["date"]!="1970-01-01",] # filtro NA
data_Whirpool["idioma"] = data.frame(unlist(lapply(data_Whirpool$text,textcat))) # detecta idioma
data_Whirpool <- data_Whirpool %>% filter(.,data_Whirpool["idioma"] =="english")

################    Score   #################################################
pos.words <- scan('../lexicon/positive-words.txt', what='character', comment.char=';')
neg.words <- scan('../lexicon/negative-words.txt', what='character', comment.char=';')
source(file = "../function/score.sentiment.R")
data_Whirpool["score"] = score.sentiment(data_Whirpool$text, pos.words, neg.words)["score"]
data_Whirpool <- data_Whirpool[2:ncol(data_Whirpool)]

##################   Save   ##############################################
saveRDS(data_Whirpool,"./data/Whirpool/data_Whirpool_I.rds")
# Fin load