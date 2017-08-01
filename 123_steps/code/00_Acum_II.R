Acum_II <-as.data.frame(NULL)
#
data_Note7 <-readRDS("./data/Note7/data_Note7_II.rds") %>% cbind("Note7", .)
names(data_Note7)[1] <- "Brand"
Acum_II <- Acum_II %>% rbind(.,data_Note7)
#View(Acum_II)
data_Toyota <-readRDS("./data/Toyota/data_Toyota_II.rds") %>% cbind("Toyota", .)
names(data_Toyota)[1] <- "Brand"
Acum_II <- Acum_II %>% rbind(.,data_Toyota)
#View(tail(Acum_II,30))
data_BlueBell <-readRDS("./data/BlueBell/data_BlueBell_II.rds") %>% cbind("BlueBell", .)
names(data_BlueBell)[1] <- "Brand"
Acum_II <- Acum_II %>% rbind(.,data_BlueBell)
#View(tail(Acum_II,30))
data_Mars <-readRDS("./data/Mars/data_Mars_II.rds") %>% cbind("Mars", .)
names(data_Mars)[1] <- "Brand"
Acum_II <- Acum_II %>% rbind(.,data_Mars)
#View(tail(Acum_II,30))
data_Hoverboard <-readRDS("./data/Hoverboard/data_Hoverboard_II.rds") %>% cbind("Hoverboard", .)
names(data_Hoverboard)[1] <- "Brand"
Acum_II <- Acum_II %>% rbind(.,data_Hoverboard)
#View(tail(Acum_II,30))
data_Whirpool <-readRDS("./data/Whirpool/data_Whirpool_II.rds") %>% cbind("Whirpool", .)
names(data_Whirpool)[1] <- "Brand"
Acum_II <- Acum_II %>% rbind(.,data_Whirpool)
saveRDS(Acum_II,"./shiny/0-data/Acum_II.rds")
#View(Acum_II %>% filter(Brand=='Toyota'))
