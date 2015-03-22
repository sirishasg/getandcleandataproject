#Getting and cleaning Data course project
#run_analysis.R
#merge training and test sets to create one dataset
##inculde library(plyr)
##read train.txt and test.txt
library(plyr)
x_train<-read.table("UCI HAR dataset/train/X_train.txt")
y_train<-read.table("UCI HAR dataset/train/y_train.txt")
subject_train<-read.table("UCI HAR dataset/train/subject_train.txt")

x_test<-read.table("UCI HAR dataset/test/X_test.txt")
y_test<-read.table("UCI HAR dataset/test/y_test.txt")
subject_test<-read.table("UCI HAR dataset/test/subject_test.txt")

#combine x datasets
features_data<-rbind(x_train,x_test)

#combine y datasets
activity_data<-rbind(y_train,y_test)

#combine subject_train and subject_test
subject_data<-rbind(subject_train,subject_test)


features<-read.table("UCI HAR dataset/features.txt")

#assign colnames
names(activity_data)<-c('activity')
names(subject_data)<-c('subject')
names(features_data)<-features$V2

#merge all data 
subj_act_data<-cbind(subject_data,activity_data)
all_data<-cbind(features_data,subj_act_data)

##extract only mean and std for each measurements
#
extmeanstd<-grep("-(mean|std)\\(\\)", features$V2)
extFeaturesNames<-features$V2[extmeanstd]
selectnames<-c(as.character(extFeaturesNames),"subject","activity")
res_data<-subset(all_data,select=selectnames)
#
activitytbl<-read.table("UCI HAR dataset/activity_labels.txt")
colnames(activitytbl)<-c('activity','activityname')

##appropriately add label names to the resultant data res_data
names(res_data)<-gsub("^t", "time", names(res_data))
names(res_data)<-gsub("^f", "frequency", names(res_data))
names(res_data)<-gsub("Acc", "Accelerometer", names(res_data))
names(res_data)<-gsub("Gyro", "Gyroscope", names(res_data))
names(res_data)<-gsub("Mag", "Magnitude", names(res_data))
names(res_data)<-gsub("BodyBody", "Body", names(res_data))

mergeddata <- merge(res_data, activitytbl, by='activity',all.x=TRUE)

##Create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata2<-aggregate(. ~subject + activity, mergeddata, mean)
tidydata2<-tidydata2[order(tidydata2$subject,tidydata2$activity),]
write.table(tidydata2, file = "tidydata.txt",row.name=FALSE)



