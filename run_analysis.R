library(dplyr)
filename <- "Coursera_Week4_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("Getting Cleaning Dataset")) { 
  unzip(filename) 
}

features <- read.table("Getting Cleaning Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("Getting Cleaning Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("Getting Cleaning Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("Getting Cleaning Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("Getting Cleaning Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("Getting Cleaning Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("Getting Cleaning Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("Getting Cleaning Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

TidyData$code <- activities[TidyData$code, 2]

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

str(FinalData)

FinalData

