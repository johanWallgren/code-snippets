# 2019-03-19
# From:
# https://www.hackerearth.com/practice/machine-learning/machine-learning-algorithms/tutorial-random-forest-parameter-tuning-r/tutorial/

# Requiers:
# Tidy data in tibble named trainData, response variable is called respons_variable
# No logical columns are allowed, convert to factor
################################################################################################
library(tidyverse)
library(parallelMap)
library(parallel)
library(data.table)
library(mlr)
library(h2o)
################################################################################################

# Splitting trainData into test and train
# Compare the error rate from traintask with error rate from testtask to see if out of sample validation is necessary.

smp_size <- floor(0.75 * nrow(trainData))
train_test_ind <- sample(seq_len(nrow(trainData)), size=smp_size)

train <- trainData[train_test_ind, ] # For training
test <- trainData[-train_test_ind, ] # For testing

# create a task
# This will drop empty factors which makes prediction to error!
# Make sure that there are no empty factors in train or test
traintask <- makeRegrTask(data=train, target="respons_variable")
testTask <- makeRegrTask(data=test, target="respons_variable")

# Feature importance. This takes some time to calculate!
feature_importance = generateFilterValuesData(traintask, method='randomForest.importance')

as_tibble(feature_importance$data) %>% 
  mutate(name = fct_reorder(name, randomForest.importance)) %>% 
  ggplot(aes(name, randomForest.importance, fill=type)) +
  geom_col() +
  coord_flip() +
  labs(title='Predictor importance',
       x='',
       y='Random forest importance',
       fill='Type')

# set 5 fold cross validation
rdesc <- makeResampleDesc("CV",iters=5L)

# #set parallel backend (Windows)
parallelStartSocket(cpus=detectCores()) # Uses all CPU's

#make randomForest learner
rf.lrn <- makeLearner("regr.randomForest")
rf.lrn$par.vals <- list(ntree=100L, 
                        importance=TRUE)

# Train rf-learner
rf_resmp <- resample(learner=rf.lrn,
                     task=traintask,
                     resampling=rdesc,
                     measures=list(expvar, rmse),
                     show.info=TRUE)

# List all avilable tuning parameters
getParamSet(rf.lrn)

# set parameter space
params <- makeParamSet(makeIntegerParam("mtry", lower=10, upper=40), # Values depending on how many predictors there are
                       makeIntegerParam("nodesize", lower=5, upper=20)) 

# set validation strategy, 5 fold cross validation (same as above)
rdesc <- makeResampleDesc("CV",iters=5L)

# set optimization technique
ctrl <- makeTuneControlRandom(maxit=5L)

# start tuning
tune <- tuneParams(learner=rf.lrn,
                   task=traintask,
                   resampling=rdesc,
                   measures=list(rmse),
                   par.set=params,
                   control=ctrl,
                   show.info=TRUE)

# Resample with more trees with tuned parameters for verification
rf.lrn$par.vals <- list(ntree=2000L, 
                        importance=TRUE, 
                        mtry=21,
                        nodesize=18)

r <- resample(learner=rf.lrn,
              task=traintask,
              resampling=rdesc,
              measures=list(expvar, rmse),
              show.info=TRUE)

# Train model (same settings as above)
rf_model <- train(learner=rf.lrn,
                  task=traintask)

# Feature importance for trained model
feature_importance_raw <- getFeatureImportance(rf_model)
feature_importance <- bind_cols(tibble(names(feature_importance_raw$res)), 
                                as_tibble(t(feature_importance_raw$res))) %>%
  rename(predictor=`names(feature_importance_raw$res)`, MeanDecreaseGini=V1) %>%
  arrange(desc(MeanDecreaseGini))

feature_importance %>%
  mutate(predictor=fct_reorder(predictor, MeanDecreaseGini)) %>% 
  ggplot(aes(predictor, MeanDecreaseGini)) +
  geom_col() +
  coord_flip() +
  labs(title='Predictor importance',
       x='',
       y='Mean Decrease Gini')

# Predict on testtask
prediction_raw <- predict(object=rf_model,
                          task=testTask)