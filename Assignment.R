setwd("/Users/weronika/Documents/RStudio/test")

#loading necessary libraries

library(data.table)
library(dplyr)

#loading the test data into the dataframe
test <- read.table("X_test.txt")
#loading the labels for the test data 
feature_labels <- read.table( "features.txt")
#extracting labels to use as column names in the test dataframe
feature_labels <- feature_labels$V2
#changing test column names to labels 
colnames(test) <- c(feature_labels)
#loading the subject's information into the dataframe (number of the subject)
subjecttest <- read.table( "subject_test.txt")
#renaming first column of subject data frame
subjecttest <- subjecttest %>% rename_at('V1', ~'subject')
#loading exercise type data into the data frame (there are 6 categories as numeric values)
ytest <- read.table( "y_test.txt")
#renaming the first column of the ytest data
ytest <- ytest %>% rename_at('V1', ~'activity')
#binding via columns three data frames
test <- bind_cols(subjecttest, ytest, test)
#extracting only the columns with the mean or sd measurements (and the subject number with activity description)
test <- test[, grep("subject|activity|mean|std",names(test))]

#repeating above steps for the train data set: 

#loading the train data into the dataframe
train <- read.table("X_train.txt")
#changing train column names to labels
colnames(train) <- c(feature_labels)
#loading the subject's information into the dataframe (number of the subject)
subjecttrain <- read.table( "subject_train.txt")
#renaming first column of subject data frame
subjecttrain <- subjecttrain %>% rename_at('V1', ~'subject')
#loading exercise type data into the data frame (there are 6 categories as numeric values)
ytrain <- read.table( "y_train.txt")
#renaming the first column of the ytrain data
ytrain <- ytrain %>% rename_at('V1', ~'activity')
#binding via columns three data frames
train <- bind_cols(subjecttrain, ytrain, train)
#extracting only the columns with the mean or sd measurements (and the subject number with activity description)
train <- train[, grep("subject|activity|mean|std",names(train))]

#checking if all the column in train data frame are in the test data frame
names(train) %in% names(test)
#binding two data frames together (test and train) by rows
data <- bind_rows(train,test)
# loading into the data frame activity labels (WALKING, SITTING etc.)
activity_labels <- read.table( "activity_labels.txt")
#getting activity labels from the data frame
labels <- activity_labels$V2
#changing the type of the variables from column 'activity' (from numeric to char)
data$activity <- as.character(data$activity)
#substituting number with descriptive label of activity
data$activity <-  sub("1", labels[1], data$activity)
data$activity <- sub("2", labels[2], data$activity)
data$activity <- sub("3", labels[3], data$activity)
data$activity <- sub("4", labels[4], data$activity)
data$activity <- sub("5", labels[5], data$activity)
data$activity <- sub("6", labels[6], data$activity)

#now the data frame data is ready to be explored

#creating a second data set with the average of each variable for each activity and each subject

data_sum <- data %>% group_by(data$subject, data$activity) %>% 
  summarise(across(names(data)[3:length(names(data))], mean),
            .groups = 'drop')  %>%
  as.data.frame()


