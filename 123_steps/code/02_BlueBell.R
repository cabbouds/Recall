##########   PARTE II: Grapg Control    #############
#######   Requirements   ######################################################
library(tidyverse)
library(lubridate)
##################   LOAD  ###################################################
data_BlueBell <-readRDS("./data/BlueBell/data_BlueBell_I.rds")
#glimpse(data_BlueBell)
##################     Global  Metrics para Bandas  ##########################
N_global = length(data_BlueBell$score) # N = Número de Observaciones
NP_global = sum(data_BlueBell$score<0) # NP = Número de Observaciones Defectuosas
NQ_global = sum(data_BlueBell$score>0) # NP = Número de Observaciones Positivas
P = NP_global / N_global
P2 = NP_global / (NP_global - NQ_global)
#glimpse(BlueBell_by_Day)
##################     Aggregate  by Day  ####################################
BlueBell_by_Day <- data_BlueBell %>% group_by(.,date)
BlueBell_by_Day <- summarise(BlueBell_by_Day
                          , Score_Net =sum(score)
                          , Score_Avg = mean(score)
                          , Score_Neg = sum(score[which(score<0)])
                          , N = n()
                          , N_Neg = sum(score<0)
                          , N_noPos = sum(score<=0)
                          , N_Pos = sum(score>0)
                          , N_noNeg = sum(score>=0)
                          , p = N_Neg/N
                          , p2 = N_Neg/(N_Neg+N_Pos)
                          , sigma = sqrt(p*(1-p)/N)
                          , sigma2 = sqrt(p2*(1-p2)/N)
                          , lower = P - 3*sigma
                          , upper = P + 3*sigma
                          , lower2 = P2 - 3*sigma2
                          , upper2 = P2 + 3*sigma2
)
### Add EVENTS  ################################
#View(BlueBell_by_Day)
events <- read.csv("./fechas/fechas_mini.csv",sep = ";")
events <- events %>% transform(.,date=as.Date(ymd(date))) %>%
  filter(Who=="BlueBell")

BlueBell_by_Day <- merge(x = BlueBell_by_Day, y = events[events$Who=="BlueBell",], by = "date", all.x = TRUE)

##################   Save   ###################################################
saveRDS(BlueBell_by_Day,"./data/BlueBell/data_BlueBell_II.rds")

