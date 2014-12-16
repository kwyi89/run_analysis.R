# Check point to see if we have the necessary packages
if (!require("data.table")) {install.packages("data.table")
    require("data.table")}
if (!require("reshape2")) {install.packages("reshape2")
    require("reshape2")}

# Download the datasets
if (!file.exists("DataSet.zip")) {
    fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, "DataSet.zip")

# Unzip the zip file
    if (!file.exists(DataDir)) {unzip("DataSet.zip")}
}

# Now to load all the files
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/test/Y_test.txt")

trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./UCI HAR Dataset/train/Y_train.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merging the two data sets, subject_train and subject_test
Subject <- rbind(testSubject, trainSubject)
colnames(Subject) <- "subject"

# Merging the label files, testY and test with labels
label <- rbind(testY, trainY)
label <- merge(label, activityLabels, by=1)[,2]

# Assign the correct labels to each column
data <- rbind(testX, trainX)
colnames(data) <- features[, 2]

# Combining all the datasets and create a separate text file that contains all the data
data <- cbind(Subject, label, data)
write.table(data, file="data_set.txt")

# Subsetting the entire data set to contain only the mean and std columns
small_data <- data[, c(1,2,grep("-mean|-std",colnames(data)))]

# Compute the means
means = dcast(melt(small_data, id.var = c("subject", "label")) , subject + label ~ variable, mean)

# Create a new text file with the result
write.table(means, file="tidy_data.txt")
