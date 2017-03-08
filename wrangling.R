#Maiju Tanskanen, maiju.tanskanen@helsinki.fi
#Data wrangling on Public Safety Survey 2009 -data
#IODS Spring 2017
#7.3.2017


library(dplyr)

# 1) CHANGING FILE FORMAT

# Setting working directory, accessing "foreign" package in order to open a .sav file 
# and reading the data into RStudio

setwd("/Users/maijutanskanen/IODS-project 8.58.53")
library(foreign)
safety <- read.spss("turvallisuus2009.sav", to.data.frame=TRUE)

#Saving the original data in .csv format

write.table(safety, file = "safety2009.csv", sep = ";", row.names = FALSE, col.names = TRUE)
safety <- read.csv(file = "safety2009.csv", sep = ";", header = TRUE)

# 2) SELECTING VARIABLES AND COUNTING A NEW VARIABLE

# Selecting columns to keep in the data and renaming them
keep <- c("k1", "k2", "k4", "k13", "k14b_j", "k14b_l")
safety <- select(safety, one_of(keep))
colnames(safety) <- c("gender", "birthyear", "education", "crimeprob", "domestic", "violence")

#Counting variable "age" and deleting variable "birthyear"

safety$age <- 2009 - safety$birthyear
safety <- safety[-2]

# 3) RECODING VARIABLES

# Recoding variables "domestic" and "violence into dichotomous variables

domestic2 <- as.character(safety$domestic)
domestic2[domestic2 %in% c("1-3 years ago","In the past 12 months")] <- "yes"
domestic2[is.na(domestic2)] <- "no"
domestic2 <- as.factor(domestic2)
safety$domestic <- domestic2

violence2 <- as.character(safety$violence)
violence2[is.na(violence2)] <- "no"
violence2[violence2 %in% c("1-3 years ago","In the past 12 months")] <- "yes"
violence2 <- as.factor(violence2)
safety$violence <- violence2

# Recoding variable "education" into three classes
education2 <- as.character(safety$education)
education2[education2 %in% c("Primary or lower secondary education")] <- "Primary"
education2[education2 %in% c("Upper secondary education (general)", "Upper secondary education (vocational)",  "College level vocational education")] <- "Secondary"
education2[education2 %in% c("Polytechnic/university of applied sciences education", "University education")] <- "Tertiary"
education2 <- as.factor(education2)
safety$education <- education2

# Recoding variable "crimeprob" into a dichotomous variable; 
# "Can't say" answers are coded as missing

crimeprob2 <- as.character(safety$crimeprob)
crimeprob2[crimeprob2 %in% c("Can't say")] <- NA
crimeprob2[crimeprob2 %in% c("Quite serious", "Very serious")] <- "Serious"
crimeprob2[crimeprob2 %in% c("Not very serious", "Not at all serious")] <- "Not serious"
crimeprob2 <- as.factor(crimeprob2)
safety$crimeprob <- crimeprob2

# 4) DELETING UNCOMPLETED CASES

# Deleting cases with missing values

complete.cases(safety)
safety <- filter(safety, complete.cases(safety) == TRUE)

# Saving the data

write.table(safety, file = "safety2009analysis.csv", sep = ";", row.names = FALSE, col.names = TRUE)


