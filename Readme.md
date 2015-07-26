## Getting and Cleaning Data Project: Readme

- To run the R script "run_analysis.R", you simply need to set a working directory containing this script and just run the script.
- I did not make an assumption that the zipped data set file was present in the current working directory.
- If the zipped file is not present, the script downloads it from this URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
- In either case (whether the zipped files is previously present or it is downloaded) the file is unzipped in the current working directory.
- The script changes the current working directory to "UCI HAR Dataset" to execute the remaining commands.
- First, the contents of "./features.txt" are read.
- The indices of those measurements relating to mean and standard deviation are determined.
- Using these indices, the measurement names are obtained.
- Finally, these measurement names are made descriptive and prettier.
	4. I obtained 66 measurements from the original list of 561 measurements. The grep command used this regular expression: "-(mean|std)\\(\\)"
- The data related to the "train" and "test" measurements are collected into two different data frames.
	1. First, the subject data (still encoded as integer) is read from "./train/subject_train.txt".
	2. This is followed by reading the activity data is read from "./train/y_train.txt".
	3. The actual training measurements are read from "./train/X_train.txt".
	4. These three data frames are combined into a single data frame "train.data".
	5. The same process is repeated for the test data located in "./test".
- The "train.data" and "test.data" data frames are stacked into a single data frame called "stacked.data".
- The names "subject", "activity", plus the measurement names for mean and standard deviation that were extracted in step 5 are encoded as column names.
- The "subject" column is converted to a factor.
- The "activity" column is converted from a integer vector to a factor with the label names obtained from "./activity_labels.txt"
- Now, the merged or stacked data set "stacked.data" is melted by using library package "rshape2" to create from the original wide data format a long data format based on ID variables subject and activity. The name of the new melted data frame is "stacked.data.melted".
- This long data format is finally used to create a tidy set data frame called "tidy.data" based on the principles of tidy sets explained in class lectures. My tidy data consists of 68 columns (66 specifying mean and standard deviation measurements plus the two columns for "subject" and "activity") and 180 rows (30 subjects with each subject having 6 activities).
- The script changes its current working directory from "UCI HAR Dataset" to the parent directory "../".
- This tidy data was then written to output file "tidy.txt" in the current working directory.