
#read the files
features<-read.table('./UCI HAR Dataset/features.txt')
X_train<-read.table('./UCI HAR Dataset/train/X_train.txt')
y_train<-read.table('./UCI HAR Dataset/train/y_train.txt')
X_test<-read.table('./UCI HAR Dataset/test/X_test.txt')
y_test<-read.table('./UCI HAR Dataset/test/y_test.txt')
subject_train<-read.table('./UCI HAR Dataset/train/subject_train.txt')
subject_test<-read.table('./UCI HAR Dataset/test/subject_test.txt')

#bind the files
traintest<-rbind(X_train,X_test)

#change the feature table, to use as headrow in traintest
feat2<-as.matrix(features)     #should be a matrix to use transpose
feat2<-t(feat2)                 #transpose the matrix
feat2<-feat2[2,]                # we only need the second column


#give the colnames of traintest the right names
colnames(traintest)<-feat2
                              
#only takes the rows with "mean" and "std"    
traintest_part1<-traintest[,grepl(("mean()"),names(traintest),fixed=TRUE)]
traintest_part2<-traintest[,grepl(("std()"),names(traintest),fixed=TRUE)]
traintest_part<-cbind(traintest_part1,traintest_part2)

#add the subject and activity to the traintest_part, first bind the activity and subject for test and training
activity<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)

traintest_act<-cbind(activity,traintest_part)   #bind the act to the dataset
traintest_subj<-cbind(subject,traintest_act)   #bind the subj to the previous to the dataset
colnames(traintest_subj)[1]<-"subject"
colnames(traintest_subj)[2]<-"activity"

# give the activity a name instead of a number:
as.character(traintest_subj[,2])    #only factors and characters kan work with "switch"
traintest_subj[,2]<-sapply(traintest_subj[,2],switch, "1"="WALKING"
                                                    ,"2"="WALKING_UPSTAIRS"
                                                    ,"3"="WALKING_DOWNSTAIRS"
                                                    ,"4"="SITTING"
                                                    ,"5"="STANDING"
                                                    ,"6"="LAYING")
#question 5:
traintest_mean<-aggregate(.~activity+subject,traintest_subj,mean)

#write a textfile of the table of question 5:
write.table(traintest_mean,file="traintest_mean.txt",row.name=FALSE)

