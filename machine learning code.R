# Importing the dataset
# From the import button in Rstudio :
# Choose "From text(readr)
# Choose the file from browse option and name it as "dataset"

# Data preprocessing
# For data pre processing, we always make the model with the collumns that are required for predictions.
# Therefore I have omitted "conformation_name" since it is same as "ID", i.e., it is unique.
# Dataset with required collumns
dataset = dataset[ , -3]

# Now for training the model we should first convert all the categorical data into factor.
# This is because model cannot be trained by categorical data.
# Encoding categorical data
levels(as.factor(molecule_name))
# [1] "MUSK-211"      "MUSK-212"      "MUSK-213"      "MUSK-214"      "MUSK-215"     
# [6] "MUSK-217"      "MUSK-219"      "MUSK-224"      "MUSK-228"      "MUSK-238"     
# [11] "MUSK-240"      "MUSK-256"      "MUSK-273"      "MUSK-284"      "MUSK-287"     
# [16] "MUSK-294"      "MUSK-300"      "MUSK-306"      "MUSK-314"      "MUSK-321"     
# [21] "MUSK-322"      "MUSK-323"      "MUSK-330"      "MUSK-331"      "MUSK-333"     
# [26] "MUSK-344"      "MUSK-f152"     "MUSK-f158"     "MUSK-j33"      "MUSK-j51"     
# [31] "MUSK-jf15"     "MUSK-jf17"     "MUSK-jf46"     "MUSK-jf47"     "MUSK-jf58"    
# [36] "MUSK-jf59"     "MUSK-jf66"     "MUSK-jf67"     "MUSK-jf78"     "NON-MUSK-192" 
# [41] "NON-MUSK-197"  "NON-MUSK-199"  "NON-MUSK-200"  "NON-MUSK-207"  "NON-MUSK-208" 
# [46] "NON-MUSK-210"  "NON-MUSK-216"  "NON-MUSK-220"  "NON-MUSK-226"  "NON-MUSK-232" 
# [51] "NON-MUSK-233"  "NON-MUSK-244"  "NON-MUSK-249"  "NON-MUSK-251"  "NON-MUSK-252" 
# [56] "NON-MUSK-253"  "NON-MUSK-270"  "NON-MUSK-271"  "NON-MUSK-286"  "NON-MUSK-288" 
# [61] "NON-MUSK-289"  "NON-MUSK-290"  "NON-MUSK-295"  "NON-MUSK-296"  "NON-MUSK-297" 
# [66] "NON-MUSK-305"  "NON-MUSK-308"  "NON-MUSK-309"  "NON-MUSK-318"  "NON-MUSK-319" 
# [71] "NON-MUSK-320"  "NON-MUSK-326"  "NON-MUSK-327"  "NON-MUSK-328"  "NON-MUSK-332" 
# [76] "NON-MUSK-334"  "NON-MUSK-338"  "NON-MUSK-358"  "NON-MUSK-360"  "NON-MUSK-361" 
# [81] "NON-MUSK-362"  "NON-MUSK-f146" "NON-MUSK-f150" "NON-MUSK-f161" "NON-MUSK-f164"
# [86] "NON-MUSK-f209" "NON-MUSK-j100" "NON-MUSK-j129" "NON-MUSK-j130" "NON-MUSK-j146"
# [91] "NON-MUSK-j147" "NON-MUSK-j148" "NON-MUSK-j81"  "NON-MUSK-j83"  "NON-MUSK-j84" 
# [96] "NON-MUSK-j90"  "NON-MUSK-j96"  "NON-MUSK-j97"  "NON-MUSK-jf18" "NON-MUSK-jf79"
# [101] "NON-MUSK-jp10" "NON-MUSK-jp13"
dataset$molecule_name = factor(dataset$molecule_name,
                      levels = levels(as.factor(dataset$molecule_name)),
                      labels = c(1:102))

# After converting the categorical data into factor, we are ready to split our dataset into training_set and test_set.
# Since I have already selected the library mannualy from the packages menu from Rstudio.
# I have put the command in comments, but if not done mannualy, it is required to first perform this command.
#library('caTools')
set.seed(123)
split = sample.split(class, 
                     SplitRatio = 0.8)
training_set = dataset[split==TRUE, ]
test_set = dataset[split==FALSE, ]

n_training_set = training_set
n_test_set = test_set

# After splitting the dataset, we will analyse the data.
# Now we see the entire data is not scaled, so we will perform feature scaling.
training_set[ ,3:168] = scale(training_set[ ,3:168])
test_set[ ,3:168] = scale(test_set[ ,3:168])
# I have not included collumn 1 and 2 because collumn 1 is "ID" and collumn 2 is not required for prediction.

# Fitting ANN to the training_set
# I have mannually selected the "h2o" library from the Rstudio.
# Therefore I have put this command in comments else it is required to perform this command first.
#library('h2o')
h2o.init(nthreads = -1,)
classifier = h2o.deeplearning(y = 'class',
                              training_frame = as.h2o(training_set),
                              activation = 'Rectifier',
                              hidden = c(6,6),
                              epochs = 100,
                              train_samples_per_iteration = -2)

# Predicting the test_set results
prob_pred = h2o.predict(classifier, newdata = as.h2o(test_set[c(-1,-169)]))
# Since the newdata in the above function should be of the "h2o" frame format, therefore I have converted the test_set into "h2o" format using function "as.h2o()"
# Since collumn 1 doesnot take part in prediction, therefore I have omitted collumn 1.
# Since collumn 169 is dependent variable therefore it will not take part in prediction.
y_pred = (prob_pred > 0.5)
# Since we need to classify the class of the molecule, so we are using 50% probability threshold.
y_pred = as.vector(y_pred)
# Since "y_pred" is of "h2o" format, so we need to convert it into a vector.
# To convert it into vector I have used the function "as.vector()".

# Now it's time to check the accuracy of our model.
# Making the confusion matrix
cm = table(test_set$class, y_pred)
#cm
# y_pred
#      0    1
# 0 1064   52
# 1  158   45

# Accuracy of a model is equal to sum of true positives and true negatives divided by the total number of observations.
# True positives = 1064
# True negatives = 45
# Total no. of observation = 1319
accuracy = (1064+45)/1319
#accuracy
#[1] 0.8407885
# Accuracy is coming out to be 84.07%, which is a good part.
# It means that the model is able to predict 84.07% values of the dataset corrrectly.

# Loss of a model is equal to sum of false positives and false negatives divided by the total number of observations.
# False positives = 158
# False negatives = 52
# Total no. of observation = 1319
loss = (158+52)/1319
#loss
#[1] 0.1592115
# Loss is coming out to be 15.9%, which is also a good part.
# It means that the model only predict 15.9% values of the dataset incorrrectly.

# Precision : Precision is the number of True Positives divided by the number of True Positives and False Positives.
# True positives = 1064
# False positives = 52
precision = 1064/(1064+52)
#precision
#[1] 0.953405
# Precision is computed to be 0.95

# Recall : Recall is the number of True Positives divided by the number of True Positives and the number of False Negatives.
# True positives = 1064
# False negatives = 158
recall = 1064/(1064+158)
#recall
#[1] 0.8707038
# Recall is computed to be 0.87

# F1 score : The F1 Score is the 2*((precision*recall)/(precision+recall)).
F1_score = 2*((precision*recall)/(precision+recall))
#F1_score
#[1] 0.9101796
# F1_score is computed to be 0.91, which is a good score, and tells us that the model created is a good deal for precting the dataset.

# Making a dataset which includes test_set variables and preicted values of "class" variable.
# Since I have already made a copy of test_set as "n_test_set".
# So I will add a new collumn to it which consist of predicted values, i.e, "y_pred".
n_test_set$p_class = y_pred

# Now we need to export the dataset in the working directory.
# Before exporting the dataset, don't forget to choose the working directory.
# You can write a code for that, but I have done that mannualy from "Session" menu in Rstudio.
write.csv(n_test_set, file = "predicted_test_set.csv", row.names = FALSE)

# We could also export the training_set in the directory.
write.csv(training_set, file = "h5_model.csv", row.names = FALSE)

# Exporting the test_set in the directory
write.csv(test_set, file = "test_set.csv", row.names = FALSE)






