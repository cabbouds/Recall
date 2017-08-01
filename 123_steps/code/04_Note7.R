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
data_Note7 <-readRDS("./data/Note7/data_Note7_I.rds")
Note7_by_Day<-readRDS("./data/Note7/data_Note7_II.rds")

N_global = length(data_Note7$score) # N = Número de Observaciones
NP_global = sum(data_Note7$score<0) # NP = Número de Observaciones Defectuosas
NQ_global = sum(data_Note7$score>0) # NP = Número de Observaciones Positivas
P = NP_global / N_global
P2 = NP_global / (N_global - NQ_global)

####### Graph 1 #######################################################################
cols <- c("#ce472e", "#f05336", "#ffd73e", "#eec73a", "#4ab04a")

f1 <- ggplot(Note7_by_Day, aes(x = date)) +
      theme_minimal() +
      scale_color_gradientn(colors = cols, limits = c(0, 1),
                            breaks = seq(0, 1, by = 1/4),
                            labels = c("0", round(1/4*1, 1), round(1/4*2, 1), round(1/4*3, 1), round(1/4*4, 1)),
                            guide = guide_colourbar(ticks = T, nbin = 50, barheight = .5, label = T, barwidth = 10)) +
      geom_point(aes(y = p, color = p, alpha = 0.8)) +
      geom_step(aes(y = upper, color = upper)) +
      geom_hline(yintercept = P, color = "#f05336", size = 1.5, alpha = 0.6, linetype = "longdash") +
      #geom_smooth(size = 1.2, alpha = 0.2) +
      geom_label_repel(data = Note7_by_Day[!is.na(Note7_by_Day$Short),],
                       aes(y = p, label = round(p, 2)),
                       fontface = 'bold',
                       size = 2.5,
                       max.iter = 100) +
      scale_x_date(breaks = pretty_breaks(100), date_labels =  "%d-%b-%y") +
      ylab("Bad Review con NP/N")+ 
      theme(legend.position = "none",#legend.position = 'bottom',#legend.direction = "horizontal",
            #panel.grid.minor = element_blank(),
            plot.title = element_text(size = 14, face = "bold", vjust = 2, color = 'black', lineheight = 0.8),
            axis.title.x = element_text(size = 14),
            axis.title.y = element_text(size = 14),
            axis.text.y = element_text(size = 8, face = "bold", color = 'black'),
            axis.text.x = element_text(size = 8, face = "bold", color = 'black',angle = 80, hjust = 1)
            )
      
####### Graph 2 #######################################################################

f2 <- ggplot(Note7_by_Day, aes(x = date)) +
  theme_minimal() +
  scale_color_gradientn(colors = cols, limits = c(0, 1),
                        breaks = seq(0, 1, by = 1/4),
                        labels = c("0", round(1/4*1, 1), round(1/4*2, 1), round(1/4*3, 1), round(1/4*4, 1)),
                        guide = guide_colourbar(ticks = T, nbin = 50, barheight = .5, label = T, barwidth = 10)) +
  geom_point(aes(y = p2, color = p2, alpha = 0.8)) +
  geom_step(aes(y = upper2, color = upper2)) +
  geom_hline(yintercept = P2, color = "#f05336", size = 1.5, alpha = 0.6, linetype = "longdash") +
  #geom_smooth(size = 1.2, alpha = 0.2) +
  geom_label_repel(data = Note7_by_Day[!is.na(Note7_by_Day$Short),],
                   aes(y = p2, label = round(p2, 2)),
                   fontface = 'bold',
                   size = 2.5,
                   max.iter = 100) +
  scale_x_date(breaks = pretty_breaks(100), date_labels =  "%d-%b-%y") +
  ylab("Bad Review con NP/(N-NQ)")+ 
  theme(legend.position="none",#legend.position = 'bottom',#legend.direction = "horizontal",
        #panel.grid.minor = element_blank(),
        plot.title = element_text(size = 14, face = "bold", vjust = 2, color = 'black', lineheight = 0.8),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        axis.text.y = element_text(size = 8, face = "bold", color = 'black'),
        axis.text.x = element_text(size = 8, face = "bold", color = 'black',angle = 80, hjust = 1)
  )
##### SHOW   ##################################################################
grid.newpage()
grid.draw(rbind(ggplotGrob(f1), ggplotGrob(f2), size = "last"))

#####  SAVE  #################################################################
plots <- mget(ls()[grep(pattern = "f[0-9]", x = ls())])
ggsave("./data/Note7/Note7_IV.png", arrangeGrob(grobs = plots),width = 50,height = 20,units = "cm")
