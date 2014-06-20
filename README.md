Coursera Getting and Cleaning Data Project
==========================================

The attached script contains the run.analysis() function that:
- Reads & merges the training and test data sets, merged file written to *merged.csv*
- Extracts the measurements on the mean and standard deviation
- Transforms the merged data set to create descriptive activity and variable names
- Calculates the tidy data containing the average for each variable for each activity and subject
- Writes the tidy data to *tidy.csv* and returns the tidy data set

The script downloads the Samsung accelerometer data to the current directory and then processes it.
As there may be needs to download and process separately, the download and process functions may be 
called independently.

To run both the download and process:
````
source('./run_analysis.R')
run.analysis() # invokes both the download and processing functions
````

To run the download and process steps independently:
````
source('./run_analysis.R')
download.data() # OPTIONALLY download accelerometer data, unzip to current directory
process.data()  # OPTIONALLY transform to tidy data
````
