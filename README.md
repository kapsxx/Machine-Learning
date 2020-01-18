# Machine-Learning

The dataset used in my project is taken from the link : "https://drive.google.com/file/d/1pZhzZnaPi74aKCQImSPrzrTxWzVeE0qv/view?usp=sharing".

I am mainly focusing on building ANN model for predicting the data. ANN stands for Artificial Neural Networks and is a deep learning technique which is a part of machine learning. 

Let's start ------------------------

I am using Rstudio for building my model. In order to import the dataset, go to "import" option on Rstudio and click on "text(readr) and choose the file from browse option and name it as "dataset" and click on "import".

Now the file is imported and it's time to begin data preprocessing in the dataset. For data pre processing, we always make the model with the collumns that are required for predictions. Therefore I have omitted "conformation_name" since it is same as "ID", i.e., it is unique.

Now first of all, we should know that for creating the model we should always use numerical data. So in my case, the dataset contains categorical data, i.e., "molecule_name". Therefore I will convert the categorical data into factor. After converting the categorical data into factor you will get to know that there are 102 levels for the variable "molecule_name". So now it's time to encode the data using "factor()" function.

After encoding the categorical data, I am ready to split my dataset into training_set and test_set. For spliting the dataset into training_set and test_set, I will use a library named "caTools". (For installing the package, go to the "package" option in Rstudio and write the name of the package in the "package" bar and click on "install"). 

Now I will split the dataset using a function named "sample.split()". In this function, there are two main arguments : First one is the variable which needs to be split i.e., "class" and the next is the "SplitRatio". And in this case I will split the dataset into 80:20 ratio. Therefore "SplitRatio = 0.8".

After splitting the dataset, we will analyse the data. Now we see the entire data is not scaled, so we will perform feature scaling. For feature scaling I have used a function named "scale()". (This function automatically scales the data in the range from 0 to 1 without user entering the formula).

Next step is to fit ANN to the training_set. For this, I will use a library named "h2o". Now I will construct a classifier using function named "h2o.deeplearning()". In this function I have used 6 arguments namely  :  (1) y = "independent variable"
                                                                                (2) training_frame = "dataset which needs to be trained"
                                                                                (3) activation = "Rectifier"
                                                                                (4) hidden = "hidden layers along with number of nodes"
                                                                                (5) epochs = "no. of times data should be iterated"
                                                                                (6) train_samples_per_iteration

Now I will predict the test_set results. For this, I have used a function named "h2o.predict()". This function consist of mainly 2 arguments namely  :  (1) classifier = "classifier just created"
                     (2) newdata = "h2o format dataset which needs to be predicted". For converting the dataset into h2o format I have                                      used a function named as "as.h2o()".
                                                                               
The above function will return the value in the form of probability. So now we will classify the results by choosing a threshold probability value. I have chosen the threshold value to be "0.5" which means for all the values equal and above "0.5" will get "class 1" and the values less than "0.5" will get "class 0". I have stored the result in "y_pred".

Since "y_pred" is of "h2o" format, so we need to convert it into a vector. To convert it into vector I have used reating a cothe function "as.vector()".

Now I will check the accuracy of my model by creating a confusion matrix. For making the confusion matrix I have used function named "table()". This function will consist of two arguments, where one will be the real "class" values of test_set and the second argument will be the predicted values of class variable i.e., "y_pred".

Final performance measures of my model including validation accuracy, loss, precision, recall and F1 score is mentioned in the "comments" along with the code.

NOTE  :  Pre processing and post processing operations are mentioned above along with the reasons why I have used them.
         The h5 model that I have trained is attched in my repository along with the original dataset and the test_set.
         I have also attached the dataset named "predicted_test_set" consisting of entire test_set including the predicted values of              "class" variable.
         Final performance measures of my model including validation accuracy, loss, precision, recall and F1 score is present in the            comment section of the code.
         I have attached a file named "machine learning code" which consist of the code.
         Please go through the entire code and read all the comments. Some of the things which are not mentioned in the above material            is present in the comments along with the explaination of each and every step. 
         
