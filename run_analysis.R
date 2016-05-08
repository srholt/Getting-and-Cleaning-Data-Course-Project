#run_analysis.R
#download data and move to working directory
setwd("/Users/shaunholt1/datasciencecoursera/week5")
library(downloader)
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="dataset.zip", mode="wb") 
unzip ("dataset.zip")
dir()
setwd("/Users/shaunholt1/datasciencecoursera/week5/UCI HAR Dataset")

#check files and directories to establish which files to use
dir()
list.files("./train")
list.files("./test")

#load packages into R
library(plyr)
library(dplyr)
library(reshape2)

#read activity list into data
activityf <- read.table("activity_labels.txt")
dim(activityf)

#load x files to use
xtraining <- read.table("train/X_train.txt")
xtest <- read.table("test/X_test.txt")
dim(xtraining)
dim(xtest)

#Combine x files
xcomb <- rbind(xtraining, xtest)
dim(xcomb)
head(xcomb)

#load y files to use
ytraining <- read.table("train/y_train.txt")
ytest <- read.table("test/y_test.txt")
dim(ytraining)
dim(ytest)

#Combine files
ycomb <- rbind(ytraining, ytest)
dim(ycomb)
head(ycomb)

#load subject files
subtrain <- read.table("train/subject_train.txt")
subtest <- read.table("test/subject_test.txt")
dim(subtrain)
dim(subtest)

#Combine files
subcomb <- rbind(subtrain, subtest)
dim(subcomb)
head(subcomb)

#load feature file
feature <- read.table("features.txt")
dim(feature)
head(feature)

#bringing names into data
names(subcomb)<-c("subject")
names(ycomb)<- c("activity")
names(xcomb)<- feature[ ,2]
head(subcomb)
head(ycomb)
head(xcomb)

#finding means and standard deviations
meanstddev <- grep("-mean\\(\\)|-std\\(\\)", feature[, 2])
datameanstddev <- xcomb[, meanstddev]
head(datameanstddev)

#remove () and change names to lower case
names(datameanstddev) <- feature[meanstddev, 2]
names(datameanstddev) <- gsub("\\(|\\)", "", names(datameanstddev))
names(datameanstddev) <- tolower(names(datameanstddev))
head(datameanstddev)
dim(datameanstddev)

# create descriptive names
activityf
activityf[, 2] = gsub("_", "", tolower(as.character(activityf[, 2])))
ycomb[,1] = activityf[ycomb[,1], 2]
names(ycomb) <- "typeofactivity"
head(ycomb)
names(subcomb) <- "volunteer"
head(subcomb)

#create new merged data frame
tidytable <- cbind(subcomb,ycomb,datameanstddev)
write.table(tidytable, "tidydata.txt")
head(tidytable)
dim(tidytable)

#create tidy data summary required
tidydata<-aggregate(. ~volunteer + typeofactivity, tidytable, mean)
tidydata<-tidydata[order(tidydata$volunteer,tidydata$typeofactivity),]
write.table(tidydata, file = "tidydatafinal.txt",row.name=FALSE)
head(tidydata)
dim(tidydata)
