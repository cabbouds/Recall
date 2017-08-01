# load package and data
library(tidyverse)
library(ggplot2)
library(reshape)
library(scales)
library(grid)
library(gridExtra)
library(lubridate)
library(ggrepel)

##################     Global  Metrics para Bandas  ##########################
data_BlueBell <-readRDS("./data/BlueBell/data_BlueBell_I.rds")
BlueBell_by_Day<-readRDS("./data/BlueBell/data_BlueBell_II.rds")

N_global = length(data_BlueBell$score) # N = Número de Observaciones
NP_global = sum(data_BlueBell$score<0) # NP = Número de Observaciones Defectuosas
NQ_global = sum(data_BlueBell$score>0) # NP = Número de Observaciones Positivas
P = NP_global / N_global
P2 = NP_global / (NP_global - NQ_global)
# BlueBell_by_Day <- BlueBell_by_Day %>% filter(.,date<=as.Date("2016-11-01"))

####### Graph 1 #######################################################################
g1 <- ggplot(BlueBell_by_Day, aes(y = Score_Net, x = date)) + 
  geom_line(aes(colour = Score_Net),size=1.5)  + 
  labs(title = "Twitter: 'BlueBell'") + 
  scale_x_date(breaks = pretty_breaks(100), date_labels =  "%d-%m-%y") +
  #limits = c(as.Date("2016-04-01", origin="1960-10-01"),as.Date("2017-06-01", origin="1960-10-01"))) +
  ylab("Net Score by Day")+ 
  theme_minimal() +#$theme_bw()+
  scale_colour_gradient2(low ="tomato3",mid = "lightgoldenrod1", high = "forestgreen") + #scale_colour_gradient2()+
  scale_x_date(breaks = pretty_breaks(100), date_labels =  "")+
  
  theme( 
        axis.title.x = element_blank(),
        axis.text.x = element_blank(), 
        axis.title.y = element_text(size = 14),
        axis.text.y = element_text(size = 8, face = "bold", color = 'black')
         
  ) +
  geom_label_repel(data = BlueBell_by_Day[BlueBell_by_Day$Who=="BlueBell",],
                   aes(y = p, label = substr(Short, 1, 7)),
                   #fontface = 'bold',
                   size = 2,
                   max.iter = 100) +
  theme(legend.position="none") 

####### Graph 2 #######################################################################  
mi_log_trans <- function(){
  trans_new(name = 'mi_log', transform = function(x) (sign(x)*log(abs(x)+1)), 
            inverse = function(y) (sign(y)*( exp(abs(y))-1)))
}

g2 <- ggplot(data_BlueBell, aes(date,score)) 
g2 <- g2 + geom_count(aes(colour = score, alpha =3), show.legend = F) + #,col = "tomato3"
  theme_minimal() +#$theme_bw()+
  scale_colour_gradient2(low ="tomato3",mid = "lightgoldenrod1", high = "forestgreen") +
  scale_x_date(breaks = pretty_breaks(100), date_labels =  "")+
  coord_trans(y="mi_log") +
  #scale_y_continuous(trans = 'mi_sqrt')+ # breaks=c(-100,-50,-10,-1,0,1,10,50,100)
  #scale_y_log10()+ # zero won't plot # breaks=c(0,1,10,50,100)
  theme(axis.title.x = element_blank(), 
        axis.text.x = element_blank(),
        axis.title.y = element_text(size = 14),
        axis.text.y = element_text(size = 8, face = "bold", color = 'black')
        #,axis.text.x = element_text(angle = 45, hjust = 1,size=11)
        ) +
  # scale_x_date(breaks = pretty_breaks(100), date_labels =  element_blank()) +
  scale_size(range = c(1, 12))+
  labs(y="Avg Score by Day") # , x="Date"
  

####### Graph 1 #######################################################################
cols <- c("#ce472e", "#f05336", "#ffd73e", "#eec73a", "#4ab04a") # color palette
n = max(BlueBell_by_Day$Score_Net)

g3 <- ggplot(BlueBell_by_Day, aes(x = date)) +
      theme_minimal() +
      scale_color_gradientn(colors = cols, limits = c(0, 1),
                            breaks = seq(0, 1, by = 1/4),
                            labels = c("0", round(1/4*1, 1), round(1/4*2, 1), round(1/4*3, 1), round(1/4*4, 1)),
                            guide = guide_colourbar(ticks = T, nbin = 50, barheight = .5, label = T, barwidth = 10)) +
      geom_point(aes(y = p, color = p, alpha = 0.8)) +
      geom_step(aes(y = upper, color = upper)) +
      geom_hline(yintercept = P, color = "#f05336", size = 1.5, alpha = 0.6, linetype = "longdash") +
      #geom_smooth(size = 1.2, alpha = 0.2) +
      geom_label_repel(data = BlueBell_by_Day[!is.na(BlueBell_by_Day$Short),],#BlueBell_by_Day[samp_ind, ]
                       aes(y = p, label = round(p, 2)),
                       fontface = 'bold',
                       size = 2.5,
                       max.iter = 100) +
      scale_x_date(breaks = pretty_breaks(100), date_labels =  "%d-%b-%y") +
      ylab("Prob. of Bad Review")+ 
      theme(legend.position="none",#legend.position = 'bottom',#legend.direction = "horizontal",
            #panel.grid.minor = element_blank(),
            plot.title = element_text(size = 14, face = "bold", vjust = 2, color = 'black', lineheight = 0.8),
            axis.title.x = element_text(size = 14),
            axis.title.y = element_text(size = 14),
            axis.text.y = element_text(size = 8, face = "bold", color = 'black'),
            axis.text.x = element_text(size = 8, face = "bold", color = 'black',angle = 80, hjust = 1)
            ) #+
      
      #ggtitle("Probability of getting a Bad Review per Day")


##### SHOW   ##################################################################
grid.newpage()
grid.draw(rbind(ggplotGrob(g1), ggplotGrob(g2), ggplotGrob(g3), size = "last"))

#####  SAVE  #################################################################
plots <- mget(ls()[grep(pattern = "g[0-9]", x = ls())])
ggsave("./data/BlueBell/BlueBell_III.png", arrangeGrob(grobs = plots), width= 50,height = 20,units = "cm")


#View(data_BlueBell %>% filter(date > "2016-12-01" & date <"2016-12-30"))