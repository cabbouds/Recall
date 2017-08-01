Acum_I <-as.data.frame(NULL)
#
data_Note7 <-readRDS("./data/Note7/data_Note7_I.rds") %>% cbind("Note7", .)
names(data_Note7)[1] <- "Brand"
Acum_I <- Acum_I %>% rbind(.,data_Note7)
#View(tail(Acum_I,30))
data_Toyota <-readRDS("./data/Toyota/data_Toyota_I.rds") %>% cbind("Toyota", .)
names(data_Toyota)[1] <- "Brand"
Acum_I <- Acum_I %>% rbind(.,data_Toyota)
#View(tail(Acum_I,30))
data_BlueBell <-readRDS("./data/BlueBell/data_BlueBell_I.rds") %>% cbind("BlueBell", .)
names(data_BlueBell)[1] <- "Brand"
Acum_I <- Acum_I %>% rbind(.,data_BlueBell)
#View(tail(Acum_I,30))
data_Mars <-readRDS("./data/Mars/data_Mars_I.rds") %>% cbind("Mars", .)
names(data_Mars)[1] <- "Brand"
Acum_I <- Acum_I %>% rbind(.,data_Mars)
#View(tail(Acum_I,30))
data_Hoverboard <-readRDS("./data/Hoverboard/data_Hoverboard_I.rds") %>% cbind("Hoverboard", .)
data_Hoverboard <- data_Hoverboard[,names(data_Hoverboard)[-grep(pattern = "X", x=names(data_Hoverboard))]]
names(data_Hoverboard)[1] <- "Brand"
Acum_I <- Acum_I %>% rbind(.,data_Hoverboard)
#View(tail(Acum_I,30))
data_Whirpool <-readRDS("./data/Whirpool/data_Whirpool_I.rds") %>% cbind("Whirpool", .)
names(data_Whirpool)[1] <- "Brand"
Acum_I <- Acum_I %>% rbind(.,data_Whirpool)
saveRDS(Acum_I,"./shiny/data/Acum_I.rds")
