## data.table package is used to fast read the data
library(data.table)
data.test.subject <- fread("./UCI HAR Dataset/test/subject_test.txt")
data.test.X <- fread("./UCI HAR Dataset/test/X_test.txt")
data.test.y <- fread("./UCI HAR Dataset/test/y_test.txt")

data.train.subject <- fread("./UCI HAR Dataset/train/subject_train.txt")
data.train.X <- fread("./UCI HAR Dataset/train/X_train.txt")
data.train.y <- fread("./UCI HAR Dataset/train/y_train.txt")

activity.labels <- fread("./UCI HAR Dataset/activity_labels.txt")
feature.names <- fread("./UCI HAR Dataset/features.txt")

## dplyr package is used to combine, rename and summary the data
library(dplyr)
data.test.subject <- as_tibble(data.test.subject)
data.test.X <- as_tibble(data.test.X)
data.test.y <- as_tibble(data.test.y)

data.train.subject <- as_tibble(data.train.subject)
data.train.X <- as_tibble(data.train.X)
data.train.y <- as_tibble(data.train.y)

## Extracts only the measurements on the mean and standard deviation for each measurement
var.select <- grep("mean\\(|std\\(", feature.names[[2]])
data.test.X <- select(data.test.X, var.select)
data.train.X <- select(data.train.X, var.select)

## rename features
data.test.X <- rename_with(data.test.X, ~feature.names[[2]][var.select])
data.train.X <- rename_with(data.train.X, ~feature.names[[2]][var.select])

## Use descriptive activity names to name the activities in the data set
data.test.y <- activity.labels[data.test.y[[1]],2]
data.train.y <- activity.labels[data.train.y[[1]],2]

## merge all data together
data.test <- mutate(data.test.X, subject=data.test.subject[[1]], activity=data.test.y[[1]])
data.train <- mutate(data.train.X, subject=data.train.subject[[1]], activity=data.train.y[[1]])
data.all <- bind_rows(data.test, data.train) 


##summarize the average of each variable for each activity and each subject
data.summary <- data.all %>%
  group_by(subject, activity) %>%
  summarise(across(1:66, mean))
write.table(data.summary, "data_summary.txt", row.name=FALSE)





                      