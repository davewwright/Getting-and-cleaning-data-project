library(base)
library(utils)
library(data.table)

# Download and unzip the Samsung accelerometer data from the specified site
# 60 MB so be patient and don't re-run all the time!
download.data <- function () {
        url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
        file <- 'dataset.zip'
        download.file(url, destfile = file, method = 'curl')
        unzip(file)
}

process.data <- function () {
        # After unzip this is where the data directories lie
        setwd('UCI HAR Dataset/')
        
        ###########################
        # TRAINING SET EXTRACTION #
        ###########################
        
        # Extract the long set of features and grab 
        # only those containing mean and std deviation in name
        f <- read.table('features.txt', col.names = c('index','name'))
        features <- subset(f, grepl('-(mean|std)[(]', f$name))
        
        # Extract the activity labels
        labels <- read.table('activity_labels.txt', col.names = c('level','label'))
        
        # Extract the training set using subset of features and labels
        data.path <- 'train/X_train.txt'
        label.path <- 'train/y_train.txt'
        subject.path <- 'train/subject_train.txt'
        
        data <- read.table(data.path)[, features$index]
        names(data) <- features$name     # name the columns with feature names
        
        label.values <- read.table(label.path)[, 1]
        data$label <- factor(label.values, levels=labels$level, labels=labels$label)
        
        subject.values <- read.table(subject.path)[, 1]
        data$subject <- factor(subject.values)
        
        # convert dataframe to data table
        train <- data.table(data)
        
        #######################
        # TEST SET EXTRACTION #
        #######################
        
        # Exactly the same as the training set except for file names
        # Could create a separate function but just as easy to inline it
        
        # Extract the training set using subset of features and labels
        data.path <- 'test/X_test.txt'
        label.path <- 'test/y_test.txt'
        subject.path <- 'test/subject_test.txt'
        
        data <- read.table(data.path)[, features$index]
        names(data) <- features$name     # name the columns with feature names
        
        label.values <- read.table(label.path)[, 1]
        data$label <- factor(label.values, levels=labels$level, labels=labels$label)
        
        subject.values <- read.table(subject.path)[, 1]
        data$subject <- factor(subject.values)
        
        # convert dataframe to data table
        test <- data.table(data)
        
        # merge the training and test data sets 
        merged <- rbind(train, test)
        
        # write the combined data out to a CSV file
        setwd('..')
        write.csv(merged, file = 'merged.csv', row.names = FALSE)
        
        # create the tidy data set and clean up the names
        tidy <- merged[, lapply(.SD, mean), by=list(label, subject)]

        # -mean --> Mean
        # -std --> Std
        # BodyBody --> Body
        names <- names(tidy)
        names <- gsub('-mean', 'Mean', names) 
        names <- gsub('-std', 'Std', names) 
        names <- gsub('BodyBody', 'Body', names) 
        names <- gsub('[()-]', '', names) 

        setnames(tidy, names)
        
        # Write the tidy data out to CSV     
        write.csv(tidy, file = 'tidy.csv',
                  row.names = FALSE, quote = FALSE)
        
        # Return the tidy data
        tidy
}