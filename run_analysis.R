## read features (variables) and activity labels
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activity"))

## Training data set
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$V2)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activityID")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

train <- cbind(subject_train, y_train, x_train)

## Test data set
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$V2)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activityID")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

test <- cbind(subject_test, y_test, x_test)

## combine Train and Test data sets
trainAndTestData <- rbind(train, test)

## Use descriptive activity names to name the activities in the data set
## merges by activityID
mergedData <- merge(trainAndTestData, activity_labels)

## Extracts only the measurements on the mean and standard deviation for each measurement
library(dplyr)
mergedData <- select(mergedData, subject, activity, grep("mean|std", colnames(mergedData)))

## remove period(.) from column names
colnames(mergedData) <- gsub("\\.", "", colnames(mergedData))

## Create tidy data set with the average of each variable for each activity and each subject
tidyData <- mergedData %>% group_by(subject, activity) %>% summarise_each(funs(mean))

## save tidyData to file
write.table(tidyData, "./UCI HAR Dataset/tidyData.txt", row.name=FALSE)

