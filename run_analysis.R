# This script is intended to be used with test and training data from Samsung Galaxy S smartphone accelerometers.

library(dplyr) # Loads the dplyr package for tibbles
library(tidyr) # Loads the tidyr package for reshaping data
library(stringr) # Loads the stringr package for replacing strings

# Top level function, variable is the "UCI HAR Dataset directory"
run_analysis <- function(dataset_dir) {
    # Check if dataset_dir ends with a "/", and adds the "/" if it does not.
    if (grepl("/$", dataset_dir) == FALSE) {
        dataset_dir <- paste(dataset_dir, "/", sep = "")
    }
    
    featlabs_dir <- paste(dataset_dir, "features.txt", sep = "") # Creates filepath to feature labels
    actlabs_dir <- paste(dataset_dir, "activity_labels.txt", sep = "") # Creates filepath to activity labels
    
    trainset_dir <- paste(dataset_dir, "train/X_train.txt", sep = "") # Create filepath to training data
    trainlab_dir <- paste(dataset_dir, "train/y_train.txt", sep = "") # Create filepath to training labels
    trainsub_dir <- paste(dataset_dir, "train/subject_train.txt", sep = "") # Create filepath to training subject numbers
    testset_dir <- paste(dataset_dir, "test/x_test.txt", sep = "") # Create filepath to test data
    testlab_dir <- paste(dataset_dir, "test/y_test.txt", sep = "") # Create filepath to test labels
    testsub_dir <- paste(dataset_dir, "test/subject_test.txt", sep = "") # Crete filepath to test subject numbers
    
    featlabs <- pull(select(read.table(featlabs_dir), 2)) # Create vector of column names from second column of feature labels file
    actlabs <- read.table(actlabs_dir) # Read in activity labels file
    
    trainset <- tbl_df(read.table(trainset_dir)) # Create tibble of training set
    trainlab <- tbl_df(read.table(trainlab_dir)) # Create tibble of training labels
    trainsub <- tbl_df(read.table(trainsub_dir)) # Create tibble of training subject numbers
    testset <- tbl_df(read.table(testset_dir)) # Create tibble of test set
    testlab <- tbl_df(read.table(testlab_dir)) # Create tibble of test labels
    testsub <- tbl_df(read.table(testsub_dir)) # Create tibble of test subject numbers
    
    trainlab <- trainlab %>% transmute(V1 = as.character(actlabs[V1,2])) # Replace training activity numbers with description
    testlab <- testlab %>% transmute(V1 = as.character(actlabs[V1,2])) # Replace test activity numbers with description
    
    combtrain <- bind_cols(trainsub, trainlab, trainset) # Bind subject, activity and data in that order for training
    combtest <- bind_cols(testsub, testlab, testset) # Bind subject, activity and data in that order for test
    comb <- bind_rows(combtrain,combtest) # Bind training and test data together
    
    featind <- grep("mean()|std()", featlabs) # Creates index of feature names that contain "mean()" or "std()"
    featind2 <- featind + 2 # Adds 2 to index of feature names for use with select, accounting for subject and activity columns
    featnames <- featlabs[featind] # Pulls out factor with feature names based on featind index
    featnames <- append(as.character(featnames), c("Subject", "Activity"), after = 0) # Adds "Subject" and "Activity" to feature names at start
    
    comb <- comb %>% select(1:2, all_of(featind2)) # Selects only columns that will contain mean() and std()
    featnames <- featnames %>% str_replace_all(c("^t" = "Time", "^f" = "Frequency", "Acc" = "Accelerometer", "Gyro" = "Gyroscope", 
                                                 "Mag" = "Magnitude", "mean" = "Mean", "std" = "StandardDeviation", "[()]" = "")) 
                                                # Replaces certain strings to provide more descriptive variable names
    colnames(comb) <- featnames # Applies descriptive variable names to combined data
    
    combmean <- comb %>% group_by(Subject, Activity) %>% summarise_all(mean) # Groups by Subject and Activity, then returns mean of all variables

}
