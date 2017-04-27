#loading required libraries

library(dplyr)

# Read dataset - Make sure that you set the working directory to where you stored "UCI HAR Dataset" folder

Train_x <- read.table("./train/X_train.txt")
Train_y <- read.table("./train/y_train.txt")
Train_ST <- read.table("./train/subject_train.txt")

Test_x <- read.table("./test/X_test.txt")
Test_y <- read.table("./test/y_test.txt")
Test_ST <- read.table("./test/subject_test.txt")

list_features <- read.table("./features.txt")


Full_y <- rbind(Test_y, Train_y)
Full_x <- rbind(Test_x, Train_x)
Full_ST <- rbind(Test_ST, Train_ST)

# Extracts only the measurements on the mean and standard deviation for each measurement.

# Find the location of measurements for mean() and std()
mean_measurements <- grep("mean()", list_features$V2)
std_measurements <- grep("std()", list_features$V2)

mean_std_full <- c(mean_measurements, std_measurements)

# subset of Full_x that contains only measurements with mean() and std()
x_meanstd <- Full_x[, mean_std_full]


# Uses descriptive activity names to name the activities in the data set
labled_activity <- factor(Full_y$V1, labels = c("WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING"
                                                ,"STANDING", "LAYING"))


#Appropriately labels the data set with descriptive variable names
descr_names <- list_features$V2[mean_std_full]

names(x_meanstd) <- descr_names

# From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.

final_data <- cbind(labled_activity, Full_ST, x_meanstd)

final_data <-tbl_df(final_data)
group_subject <- group_by(final_data, V1)


# I need to review the dplyr package to solve the last piece

df <- final_data %>% group_by(V1, labled_activity) %>% summarise_each(funs(mean))

# df is the final summarized data contains the average of each variable for each activity and each subject






