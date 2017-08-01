##########   PARTE II: Grapg Control    #############
#######   Requirements   ######################################################
library(tidyverse)
library(lubridate)
##################   LOAD  ###################################################
data_Toyota <-readRDS("./data/Toyota/data_Toyota_I.rds")
#glimpse(data_Toyota)
##################     Global  Metrics para Bandas  ##########################
N_global = length(data_Toyota$score) # N = Número de Observaciones
NP_global = sum(data_Toyota$score<0) # NP = Número de Observaciones Defectuosas
NQ_global = sum(data_Toyota$score>0) # NP = Número de Observaciones Positivas
P = NP_global / N_global
P2 = NP_global / (NP_global - NQ_global)
#glimpse(Toyota_by_Day)
##################     Aggregate  by Day  ####################################
Toyota_by_Day <- data_Toyota %>% group_by(.,date)
Toyota_by_Day <- summarise(Toyota_by_Day
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
#View(Toyota_by_Day)
events <- read.csv("./fechas/fechas_mini.csv",sep = ",")
events <- events %>% transform(.,date=as.Date(ymd(date))) %>%
  filter(Who=="Toyota")

Toyota_by_Day <- merge(x = Toyota_by_Day, y = events[events$Who=="Toyota",], by = "date", all.x = TRUE)

##################   Save   ###################################################
saveRDS(Toyota_by_Day,"./data/Toyota/data_Toyota_II.rds")

