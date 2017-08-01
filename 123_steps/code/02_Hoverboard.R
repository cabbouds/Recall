##########   PARTE II: Grapg Control    #############
#######   Requirements   ######################################################
library(tidyverse)
library(lubridate)
##################   LOAD  ###################################################
data_Hoverboard <-readRDS("./data/Hoverboard/data_Hoverboard_I.rds")
#glimpse(data_Hoverboard)
##################     Global  Metrics para Bandas  ##########################
N_global = length(data_Hoverboard$score) # N = Número de Observaciones
NP_global = sum(data_Hoverboard$score<0) # NP = Número de Observaciones Defectuosas
NQ_global = sum(data_Hoverboard$score>0) # NP = Número de Observaciones Positivas
P = NP_global / N_global
P2 = NP_global / (NP_global - NQ_global)
#glimpse(Hoverboard_by_Day)
##################     Aggregate  by Day  ####################################
Hoverboard_by_Day <- data_Hoverboard %>% group_by(.,date)
Hoverboard_by_Day <- summarise(Hoverboard_by_Day
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
#View(Hoverboard_by_Day)
events <- read.csv("./fechas/fechas_mini.csv",sep = ",")
events <- events %>% transform(.,date=as.Date(ymd(date))) %>%
  filter(Who=="Hoverboard")

Hoverboard_by_Day <- merge(x = Hoverboard_by_Day, y = events[events$Who=="Hoverboard",], by = "date", all.x = TRUE)

##################   Save   ###################################################
saveRDS(Hoverboard_by_Day,"./data/Hoverboard/data_Hoverboard_II.rds")

