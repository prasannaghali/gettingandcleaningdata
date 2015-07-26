# We'll follow the principles set out in class notes - if the unzipped data set doesn't exist,
# we'll download and then unzip the downloaded file ...
working_dir <- "UCI HAR Dataset"
if (!file.exists(working_dir)) {
  # check if the file was previously downloaded
  filename <- "getdata-projectfiles-UCI HAR Dataset.zip"
  # if not, download using URL specified in Course Project page ...
  if (!file.exists(filename)) {
    fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    setInternet2(use=TRUE) # for Windows 8 - otherwise cannot download from https URL's
    download.file(fileurl, filename) 
  }
  unzip(filename)
}

setwd(working_dir)

# read names of measurements ...
meas.names <- read.table("./features.txt")
mean_std.indices <- grep("-(mean|std)\\(\\)", meas.names[,2])
mean_std.names <- meas.names[mean_std.indices, 2]
# make the measurement names descriptive and pretty by replacing 'm' and 's' with 
# 'M' and S',
# respectively, and removing the token "()"
mean_std.names <- gsub("-mean\\(\\)", "Mean", mean_std.names)
mean_std.names <- gsub("-std\\(\\)", "Std", mean_std.names)

# read "Human Activity Recognition" data for training
train.subject.id <- read.table("./train/subject_train.txt")
train.activity.index <- read.table("./train/y_train.txt")
#train_activity.index <- scan("./train/y_train.txt")
#train.activity.label <- activity.label[train.activity.index, 2]
train.meas <- read.table("./train/X_train.txt")
train.meas <- train.meas[, mean_std.indices]
train.data <- cbind(train.subject.id, train.activity.index, train.meas)

test.subject.id <- read.table("./test/subject_test.txt")
test.activity.index <- read.table("./test/y_test.txt")
#test.activity.index <- scan("./test/y_test.txt")
#test.activity.label <- activity.label[test.activity.index, 2]
test.meas <- read.table("./test/X_test.txt")
test.meas <- test.meas[, mean_std.indices]
test.data <- cbind(test.subject.id, test.activity.index, test.meas)

stacked.data <- rbind(train.data, test.data)
names(stacked.data) <- c("subject", "activity", mean_std.names)

# convert activity id's in stacked.data$activity into factors with labels from "./activity_labels.txt"
# read activity labels ...
activity.label <- read.table("./activity_labels.txt")
stacked.data$activity <- factor(stacked.data$activity, levels=activity.label[,1], labels=activity.label[,2])

# similarly, subject id's are not quantitative data but are instead categorial ...
stacked.data$subject <- as.factor(stacked.data$subject)

library(reshape2)
# id.vars specifies the variables to keep but not split apart on
stacked.data.melted <- melt(stacked.data, id.vars=c("subject", "activity")) #, variable.name="condition", value.name="value")

# here, we need to tell dcast that subject and activity are the ID variables (we want a column for each)
# and that "variable" describes the remaining measured variables.
tidy.data <- dcast(stacked.data.melted, subject+activity~variable, mean)

setwd("../")
write.table(tidy.data, "tidy.txt", row.names=FALSE, quote=FALSE)

