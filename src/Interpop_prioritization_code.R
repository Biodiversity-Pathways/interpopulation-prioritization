##############
library(ggplot2)
library(tidyr)
library(sf)# sort of shape file equivalent
library(raster)
library(here)
library(readxl)

setwd("C:/Users/User/OneDrive/CMU/Interpopulation_Prioritization")

##########spatial information herds############

Provincial_Parks<-st_read("D:/Documents/GIS_LAYERS/Conservation_Boundaries/ProvincialParks/TA_PARK_ECORES_PA_SVW/TA_PEP_SVW_polygon.shp") #study area boundary #AOI
Caribou_UWR<-st_read("D:/Documents/GIS_LAYERS/CARIBOU/UWR/CaribouUWR.shp")

Dir<-"D:\\Documents\\GIS_LAYERS\\CARIBOU"
HERDS<-st_read(here::here(Dir, "SouthernMountain_210430.shp")) #study area boundary #AOI

#####input data and weights######

Weights <- read_excel("C:/Users/User/OneDrive/CMU/Interpopulation_Prioritization/priority_ranking_matrix_inputs.xlsx",
                      sheet = "Weights") #professional weighting

Raw_Criteria<- read_excel("C:/Users/User/OneDrive/CMU/Interpopulation_Prioritization/priority_ranking_matrix_inputs.xlsx",
                          sheet = "Criteria_RawVals") #raw data


####Normalization and effect direction functions####

normalize.fun<-function(x){ return ((x - min(x)) / (max(x) - min(x))) } #FUNCTION TO NORMALIZE THE CRITERIA VALUES
effect.fun<-function(x){return(1-x)}  #FUNCTION TO change the direction of the effect from positive to negative and vice versa where appropriate


########Option A: normalize on the the non percent criteria#####
Normal_Some<- Raw_Criteria

Normal_Some[,c(2,4:5)]<-apply(Raw_Criteria[,c(2,4:5)],2, normalize.fun) #apply normalization function to the criteria that are not area proportions
Normal_Some[,c(5,9:36)]<-apply(Normal_Some[,c(5,9:36)],2,effect.fun)

Normal_Some

###ranking Algorithm####

cNS<-as.matrix(Normal_Some[,-1])
rownames(cNS)<- Normal_Some$Herd

w<-as.matrix(t(Weights)) #transpose weights for matrix multiplication

dim(cNS)
dim(w)
multi.NS<-(cNS %*% w) #Multiply by weights


Sum.Val.NS<-rowSums(multi.NS) #add weighted values together
Rank.NS<-rank(-Sum.Val.NS) #produces rank values for each herd.

Rank_NS<-as.data.frame(Rank.NS)

Rank_NS$HerdName<-Normal_Some$Herd
Rank_NS$Sum.Val<-Sum.Val.NS
Rank_NS


HERDS$Rank_NS<-Rank_NS$Rank.NS[match(HERDS$HerdName,Rank_NS$HerdName)]

#@##Rank Plot Option A####

B <- ggplot(HERDS) +
  geom_sf(aes(fill=as.numeric(Rank_NS))) +
  geom_sf_label(aes(label=Rank_NS)) +
  scale_fill_distiller(palette = "Spectral",  guide = guide_colourbar(direction = "vertical",nbin=17),
                       name =expression("Priority Recovery Rank \nNormalize non-percent criteria"))+
  theme(panel.grid.major = element_blank(),
        panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA),
        axis.text = element_blank(),
        axis.title = element_blank(),
        plot.margin=unit(c(0,0,0,0),"mm"),
        legend.position = "right",
        legend.background = element_blank()) +

  geom_sf(data = subset(HERDS, HerdName ==  "GeorgeMountain"  ), fill="grey40" )+
  labs(fill= "Non Candidate")

B

####OR####

library(mapview)
mapview(HERDS, zcol = "Rank_NS", map.types = c("OpenStreetMap.DE","Esri.WorldShadedRelief" )) +
  mapview(Provincial_Parks,alpha.regions = 0.2, aplha = 1, col.regions = "#A2CD5A") +
  mapview(Caribou_UWR,alpha.regions = 0.2, aplha = 1, col.regions = "#006400")



######Option B: normalize all the criteria#####

###ranking Algorithm####

cNA<-as.matrix(Normal_All[,-1])
rownames(cNA)<- Normal_All$Herd

w<-as.matrix(t(Weights)) #transpose weights for matrix multiplication

dim(cNA)
dim(w)
multi.NA<-(cNA %*% w) #Multiply by weights


Sum.Val.NA<-rowSums(multi.NA) #add weighted values together
Rank.NA<-rank(-Sum.Val.NA) #produces rank values for each herd.

Rank_NA<-as.data.frame(Rank.NA)

Rank_NA$HerdName<-Normal_All$Herd
Rank_NA$Sum.Val<-Sum.Val.NA
Rank_NA


########Rank plot option B########

HERDS$Rank_NA<-Rank_NA$Rank.NA[match(HERDS$HerdName,Rank_NA$HerdName)]


C <- ggplot(HERDS) +
  geom_sf(aes(fill=as.numeric(Rank_NA))) +
  geom_sf_label(aes(label=Rank_NA)) +
  scale_fill_distiller(palette = "Spectral",  guide = guide_colourbar(direction = "vertical",nbin=17),
                       name =expression("Priority Recovery Rank \nNormalize all criteria"))+
  theme(panel.grid.major = element_blank(),
        panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA),
        axis.text = element_blank(),
        axis.title = element_blank(),
        plot.margin=unit(c(0,0,0,0),"mm"),
        legend.position = "right",
        legend.background = element_blank()) +

  geom_sf(data = subset(HERDS, Prof_Rank ==  0  ), fill="grey40" )+
  labs(fill= "Non Candidate")

C

mapview(HERDS, zcol = "Rank_NA", map.types = c("OpenStreetMap.DE","Esri.WorldShadedRelief" )) +
  mapview(Provincial_Parks,alpha.regions = 0.2, aplha = 1, col.regions = "#A2CD5A") +
  mapview(Caribou_UWR,alpha.regions = 0.2, aplha = 1, col.regions = "#006400")


######FIGURE 3#############

Rank_NS
Order_N<-Rank_NS[order(Rank_NS$Rank.NS),]
step<-diff(Order_N$Sum.Val)
Order_N$step<-c(0,abs(step))

ggplot(Order_N, aes(x=reorder(HerdName,Rank.NS) ,y= step))+
 geom_col(fill="#009900")+
  xlab(expression("High Priority Rank" %->% "LowPriority Rank" ))+
  ylab("Difference in Algorithm Value from Next Highest Rank")+
   theme(axis.text.x = element_text(angle = 45, hjust=1) )

######FIGURE 3B#############

Rank_NA
Order_NA<-Rank_NA[order(Rank_NA$Rank.NA),]
stepA<-diff(Order_NA$Sum.Val)
Order_NA$step<-c(0,abs(stepA))

ggplot(Order_NA, aes(x=reorder(HerdName,Rank.NA) ,y= step))+
  geom_col(fill="#009900")+
  xlab(expression("High Priority Rank" %->% "LowPriority Rank" ))+
  ylab("Difference in Algorithm Value from Next Highest Rank")+
  theme(axis.text.x = element_text(angle = 50, hjust=1) )


###figure 5####
head(Normal_Some)
criteria.var<-apply(Normal_Some[,-1], 2, var)
c.var.dr<-as.data.frame(criteria.var)
c.var.dr$criteria<-row.names(c.var.dr)
c.var.dr$criteria<-factor(c.var.dr$criteria,levels=c.var.dr$criteria)

ggplot(c.var.dr, aes(x=criteria,y=criteria.var))+
  geom_col(fill="#004400")+
  xlab("Criteria")+
  ylab("Variance")+
  theme(axis.text.x = element_text(angle = 60, hjust=1) )

####figure 5b######
head(Normal_All)
criteria.varNA<-apply(Normal_All[,-1], 2, var)
c.var.dr.NA<-as.data.frame(criteria.varNA)
c.var.dr.NA$criteria<-row.names(c.var.dr.NA)
c.var.dr.NA$criteria<-factor(c.var.dr.NA$criteria,levels=c.var.dr.NA$criteria)


ggplot(c.var.dr.NA, aes(x= criteria,y=criteria.varNA))+
  geom_col(fill="#004400")+
  xlab("Criteria")+
  ylab("Variance")+
  theme(axis.text.x = element_text(angle = 60, hjust=1) )
