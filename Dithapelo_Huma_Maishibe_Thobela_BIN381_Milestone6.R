## this code requires java sdk version 8-15
## also requires r 64 bit
## also the below packages

#### This is the final model which represents everything outlined in the documents.


library(h2o)
h2o.init()
library(mlbench)

rdata<-read.csv2("rdata.csv")

## Training and Test Data

rdata_sample<-subset(rdata,select = c("rdata.Agegroup","rdata.Occupation","rdata.Education"
                                      ,"rdata.Years_Worked","rdata.DepRarity","rdata.Above50k"))


## Training Data
TrainingData=subset(rdata_sample[sample(nrow(rdata_sample),5000),])

## Test Data
TestingData=subset(rdata_sample[sample(nrow(rdata_sample),5000),])


str(rdata_sample)

rdata_sample$rdata.Agegroup<-as.factor(rdata_sample$rdata.Agegroup)
rdata_sample$rdata.Occupation<-as.factor(rdata_sample$rdata.Occupation)
rdata_sample$rdata.Education<-as.factor(rdata_sample$rdata.Education)
rdata_sample$rdata.Years_Worked<-as.numeric(rdata_sample$rdata.Years_Worked)
rdata_sample$rdata.DepRarity<-as.factor(rdata_sample$rdata.DepRarity)
rdata_sample$rdata.Above50k<-as.factor(rdata_sample$rdata.Above50k)


### conversions
TrainingData_nn=as.h2o(TrainingData)
TestingData_nn=as.h2o(TestingData)



## Network creation
NeuralNetwork<-h2o.deeplearning(x=1:5,
                                y=6,
                                training_frame = TrainingData_nn,
                                nfolds =5,
                                standardize = TRUE,
                                activation ="Rectifier")


## Apply  Predictions
NeuralNetworkPrediction<-h2o.predict(object=NeuralNetwork,
                                     newdata = TestingData_nn)


## Analysis of Predictions
NeuralNetworkPrediction<-as.data.frame(NeuralNetworkPrediction)

### comparisons
comparison<-cbind(NeuralNetworkPrediction,TestingData_nn)
comparison


## check success

### count the matches

checkSuccess<-0
for (i in 1:nrow(checkSuccess)) {
  if (checkSuccess$predict[i]==checkSuccess$Above50k[i]) {
    checkSuccess=checkSuccess+1; 
  }
}
checkSuccess
## 78% success









