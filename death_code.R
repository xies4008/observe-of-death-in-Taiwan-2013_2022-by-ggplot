setwd("C:/R/death")

#download packages
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("tidyverse")
library("dplyr")
library("ggplot2")
library("tidyverse")


#read the data
death_toll_cause_of_death <- read.csv("death_toll_cause_of_death.csv", sep=",", header=TRUE, na = "NA")
death_toll_group_by_age <- read.csv("death_toll_group_by_age.csv", sep=",", header=TRUE,na = "NA")
--------------------------------------------------------------------------------
#cause_of_death
death_toll_cause_of_death <- read.csv("death_toll_cause_of_death.csv", sep=",", header=TRUE, na = "NA")
##change row names 
#row.names(death_toll_cause_of_death) <- c("y2006","y2007","y2008","y2009","y2010","y2011","y2012","y2013","y2014","y2015","y2016","y2017","y2018","y2019","y2020","y2021","y2022","y2023")
#row.names(death_toll_cause_of_death) <- death_toll_cause_of_death[[1]]
#death_toll_cause_of_death <- select(death_toll_cause_of_death,-1)

#change col names
colnames(death_toll_cause_of_death) <- c("year","male_total","female_total",
                                         "male_cancer","female_cancer",
                                         "male_heart_disease","female_heart_disease",
                                         "male_cerebrovascular_disease","female_cerebrovascular_disease",
                                         "male_diabetes","female_diabetes",
                                         "male_pneumonia","female_pneumonia",
                                         "male_kidney_disease","female_kidney_disease",
                                         "male_suicide","female_suicide",
                                         "male_accident_injury","female_accident_injury",
                                         "male_chronic_liver_disease","female_chronic_liver_disease",
                                         "male_hypertension","female_hypertension",
                                         "male_other","female_other")

#death_toll_cause_of_death <- data.frame(t(death_toll_cause_of_death),check.names=F)
##select data between 2013-2022
#death_toll_cause_of_death <- death_toll_cause_of_death[,8:17]
death_toll_cause_of_death <- death_toll_cause_of_death[8:17,]

--------------------------------------------------------------------------------
#cause_of_death_plot1
  
polt1_male <- death_toll_cause_of_death[,c(1,2)] 
polt1_male$sex <- c("male")
colnames(polt1_male) <- c("year","number_of_people","sex")

polt1_female <- death_toll_cause_of_death[,c(1,3)] 
polt1_female$sex <- c("female")
colnames(polt1_female) <- c("year","number_of_people","sex")

polt1 <- rbind(polt1_male,polt1_female)

ggplot(data = polt1, aes(x=year,y=number_of_people))+
  geom_point(aes(color = sex))+
  scale_x_continuous(limits = c(2011,2024), breaks = seq(2013,2023,1))+
  facet_wrap(~sex)+
  coord_flip()



----------------------------------------------------------------------------
#cause_of_death_plot2,plot3,plot4
#create new data to calculate % of cause of death  
data_for_plot2_3_4 <- death_toll_cause_of_death
death_toll_cause_of_death_sum <- colSums(death_toll_cause_of_death)
data_for_plot2_3_4 <- rbind(death_toll_cause_of_death,death_toll_cause_of_death_sum)

plot2 <-data_for_plot2_3_4 %>% mutate(cancer = male_cancer + female_cancer, 
                          disease = male_heart_disease + female_heart_disease+
                            male_cerebrovascular_disease + female_cerebrovascular_disease + 
                            male_diabetes + female_diabetes + male_pneumonia + female_pneumonia + 
                            male_kidney_disease + female_kidney_disease + 
                          male_chronic_liver_disease + female_chronic_liver_disease,
                          suicide = male_suicide + female_suicide,
                          accident =  male_accident_injury + female_accident_injury,
                          hypertension = male_hypertension + female_hypertension,
                          other = male_other + female_other)
plot2 <- plot2[11,26:31] 
plot2 <- data.frame(t(plot2),check.names=F)

cause <- c("cancer","disease","suicide","accident","hypertension","other")
plot2  <- cbind(cause,plot2)
colnames(plot2) <- c("cause","number_of_people")


#create pie chart
ggplot(plot2, aes(x="", y=number_of_people, fill = cause)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  geom_text(aes(label = paste0(round(number_of_people/242389*100,2), "%")), position = position_stack(vjust=0.5)) +
  labs(x = NULL, y = NULL, fill = NULL) +
  theme_classic() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  scale_fill_brewer(palette="Purples")

-------------------------------
##plot3_cause_of_death_in male
plot3 <-data_for_plot2_3_4 %>% mutate(cancer = male_cancer, 
                                      disease = male_heart_disease +
                                        male_cerebrovascular_disease + 
                                        male_diabetes + male_pneumonia + 
                                        male_kidney_disease + 
                                        male_chronic_liver_disease,
                                      suicide = male_suicide,
                                      accident =  male_accident_injury,
                                      hypertension = male_hypertension,
                                      other = male_other)
plot3 <- plot3[11,26:31] 
plot3 <- data.frame(t(plot3),check.names=F)

cause <- c("cancer","disease","suicide","accident","hypertension","other")
plot3  <- cbind(cause,plot3)
colnames(plot3) <- c("cause","number_of_people")


#create pie chart
ggplot(plot3, aes(x="", y=number_of_people, fill = cause)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  geom_text(aes(label = paste0(round(number_of_people/144836*100,2), "%")), position = position_stack(vjust=0.5)) +
  labs(x = NULL, y = NULL, fill = NULL) +
  theme_classic() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  scale_fill_brewer(palette="Blues")


-------------------------------
##plot4_cause_of_death_in female
plot4 <-data_for_plot2_3_4 %>% mutate(cancer = female_cancer, 
                                      disease = female_heart_disease +
                                      female_cerebrovascular_disease + 
                                      female_diabetes + female_pneumonia + 
                                      female_kidney_disease + 
                                      female_chronic_liver_disease,
                                      suicide = female_suicide,
                                      accident =  female_accident_injury,
                                      hypertension = female_hypertension,
                                      other = female_other)
plot4 <- plot4[11,26:31] 
plot4 <- data.frame(t(plot4),check.names=F)

cause <- c("cancer","disease","suicide","accident","hypertension","other")
plot4  <- cbind(cause,plot4)
colnames(plot4) <- c("cause","number_of_people")


#create pie chart
ggplot(plot4, aes(x="", y=number_of_people, fill = cause)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  geom_text(aes(label = paste0(round(number_of_people/97553*100,2), "%")), position = position_stack(vjust=0.5)) +
  labs(x = NULL, y = NULL, fill = NULL) +
  theme_classic() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  scale_fill_brewer(palette="Reds")

--------------------------------------------------------------------------------
#group by age

death_toll_group_by_age <- read.csv("death_toll_group_by_age.csv", sep=",", header=TRUE,na = "NA")

#row.names(death_toll_group_by_age) <- death_toll_group_by_age[[1]]
##delete replicate row 
death_toll_group_by_age <- select(death_toll_group_by_age,-4,-5)

##change col names
colnames(death_toll_group_by_age) <- c("year","male_0","female_0","male_1_4","female_1_4",
                                       "male_5_14","female_5_14","male_15_24","female_15_24",
                                       "male_25_44","female_25_44","male_45_64","female_45_64",
                                       "male_65_older","female_65_older",
                                       "male_average_age","female_average_age",
                                       "male_median_age","female_median_age")

#death_toll_group_by_age <- data.frame(t(death_toll_group_by_age),check.names=F)
##select data between 2013-2022
death_toll_group_by_age <- death_toll_group_by_age[8:17,]



----------------------------------------------------------------------------
#group by age_plot5 scatter plot 
death_toll_group_by_age$male_average_age <- as.integer(death_toll_group_by_age$male_average_age)
death_toll_group_by_age$female_average_age <- as.integer(death_toll_group_by_age$female_average_age)
str(death_toll_group_by_age)


plot5_male <- death_toll_group_by_age[,c(1,16)] 
plot5_male$sex <- c("male")
colnames(plot5_male) <- c("year","average_age","sex")

plot5_female <- death_toll_group_by_age[,c(1,17)] 
plot5_female$sex <- c("female")
colnames(plot5_female) <- c("year","average_age","sex")

plot5 <- rbind(plot5_male,plot5_female)

ggplot(data = plot5, aes(x=year,y=average_age))+
  geom_point(aes(color = sex))+
  scale_x_continuous(limits = c(2011,2024), breaks = seq(2013,2023,1))+
  facet_wrap(~sex)+
  coord_flip()

----------------------------------------------------------------------------  
  
#group by age_plot6,plot7,plot8
 
data_for_plot6_7_8 <- death_toll_group_by_age[,2:15]
data_for_plot6_7_8_sum <- colSums(data_for_plot6_7_8)
data_for_plot6_7_8 <- rbind(data_for_plot6_7_8,data_for_plot6_7_8_sum)


plot6 <-data_for_plot6_7_8 %>% mutate(young_age_population = 
                                        male_0 + female_0 + 
                                        male_1_4 + female_1_4 + 
                                        male_5_14 + female_5_14,
                                      working_age_population = 
                                        male_15_24 + female_15_24 + 
                                        male_25_44 + female_25_44 + 
                                        male_45_64 + female_45_64,
                                      old_age_population = 
                                        male_65_older + female_65_older)
plot6 <- plot6[11,15:17] 
plot6 <- data.frame(t(plot6),check.names=F)

age_sturcture <- c("young_age_population","working_age_population","old_age_population")
plot6  <- cbind(age_sturcture,plot6)
colnames(plot6) <- c("age_sturcture","number_of_people")                                        
                                      

ggplot(plot6, aes(x="", y=number_of_people, fill = age_sturcture)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  geom_text(aes(label = paste0(round(number_of_people/242455*100,2), "%")), position = position_stack(vjust=0.5)) +
  labs(x = NULL, y = NULL, fill = NULL) +
  theme_classic() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  scale_fill_brewer(palette="Purples")


-------------------------------
##plot7 group by age in male

plot7 <-data_for_plot6_7_8 %>% mutate(young_age_population = 
                                          male_0 + 
                                          male_1_4 + 
                                          male_5_14,
                                        working_age_population = 
                                          male_15_24 +
                                          male_25_44 + 
                                          male_45_64,
                                        old_age_population = 
                                          male_65_older)
plot7 <- plot7[11,15:17] 
plot7 <- data.frame(t(plot7),check.names=F)

age_sturcture <- c("young_age_population","working_age_population","old_age_population")
plot7  <- cbind(age_sturcture,plot7)
colnames(plot7) <- c("age_sturcture","number_of_people")                                        


ggplot(plot7, aes(x="", y=number_of_people, fill = age_sturcture)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  geom_text(aes(label = paste0(round(number_of_people/144900*100,2), "%")), position = position_stack(vjust=0.5)) +
  labs(x = NULL, y = NULL, fill = NULL) +
  theme_classic() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  scale_fill_brewer(palette="Blues")
  
-------------------------------
##plot8 group by age in female
  
plot8 <-data_for_plot6_7_8 %>% mutate(young_age_population = 
                                          female_0 + 
                                          female_1_4 + 
                                          female_5_14,
                                        working_age_population = 
                                          female_15_24 +
                                          female_25_44 + 
                                          female_45_64,
                                        old_age_population = 
                                          female_65_older)
plot8 <- plot8[11,15:17] 
plot8 <- data.frame(t(plot8),check.names=F)

age_sturcture <- c("young_age_population","working_age_population","old_age_population")
plot8  <- cbind(age_sturcture,plot8)
colnames(plot8) <- c("age_sturcture","number_of_people")                                        


ggplot(plot8, aes(x="", y=number_of_people, fill = age_sturcture)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) +
  geom_text(aes(label = paste0(round(number_of_people/97555*100,2), "%")), position = position_stack(vjust=0.5)) +
  labs(x = NULL, y = NULL, fill = NULL) +
  theme_classic() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  scale_fill_brewer(palette="Reds")  
  


