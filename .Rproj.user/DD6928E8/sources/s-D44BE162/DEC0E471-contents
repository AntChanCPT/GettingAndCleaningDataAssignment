# Getting and Cleaning Data - Project Assignment

This project uses a single script named "run_analysis.R" to process data provided by the Getting and Cleaning Data course from Coursera. Once sourced, the directory for the "UCI HAR Dataset" folder must be provided as an argument to the function "run_analysis".

A tip to any user would be to place the "UCI HAR Dataset" folder in the working directory, then pass the directory path to the function using:  
> dir <- paste(getwd(), "/UCI HAR Dataset", sep = "")  
> x <- run_analysis(dir) 

The function will work either with or without "/" on the end of the "UCI HAR Dataset" folder name. 

The function within the script:  
* loads all necessary files  
* merges the training and test data  
* removes all variables that do not give mean or standard deviation  
* gives variables more descriptive names  
* replaces activity numbers with activity names  
* groups the data by subject number and activity  
* outputs a tidy dataset with the mean of each variable for each activity per subject  

