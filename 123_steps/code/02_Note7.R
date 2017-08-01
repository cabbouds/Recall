##########   PARTE II: Grapg Control    #############
#######   Requirements   ######################################################
library(tidyverse)
library(lubridate)
##################   LOAD  ###################################################
data_Note7 <-readRDS("./data/Note7/data_Note7_I.rds")
Note7<-"Note7"
#glimpse(cbind(Note7, data_Note7))
#glimpse(data_Note7)
##################     Global  Metrics para Bandas  ##########################
N_global = length(data_Note7$score) # N = Número de Observaciones
NP_global = sum(data_Note7$score<0) # NP = Número de Observaciones Defectuosas
NQ_global = sum(data_Note7$score>0) # NP = Número de Observaciones Positivas
P = NP_global / N_global
P2 = NP_global / (NP_global - NQ_global)
#glimpse(Note7_by_Day)
##################     Aggregate  by Day  ####################################
Note7_by_Day <- data_Note7 %>% group_by(.,date)
Note7_by_Day <- summarise(Note7_by_Day
                          , Score_Net =sum(score)
                          , Score_Avg = mean(score)
                          , Score_Neg = sum(score[which(score<0)])
                          , N = n()
                          , N_Neg = sum(score<0)
                          , N_noPos = sum(score<=0)
                          , N_Pos = sum(score>0)
                          , N_noNeg = sum(score>=0)
                          , p = N_Neg/N
                          , p2 = N_Neg/(N_Neg+N_Pos) #### Esto hace la diferencia 
                          , sigma = sqrt(p*(1-p)/N)
                          , sigma2 = sqrt(p2*(1-p2)/N)
                          , lower = P - 3*sigma
                          , upper = P + 3*sigma
                          , lower2 = P2 - 3*sigma2
                          , upper2 = P2 + 3*sigma2
)
### Add EVENTS  ###/home/camilo/0-MCD/12-STV/R/shiny

###########################################################################################