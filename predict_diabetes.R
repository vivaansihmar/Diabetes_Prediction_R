library(randomForest)
library(caret)


data <- read.csv("data/diabetes.csv")


data$Outcome <- factor(data$Outcome, levels = c(0, 1))

cols_with_zeros <- c("Glucose", "BloodPressure", "SkinThickness", "Insulin", "BMI")
data[cols_with_zeros] <- lapply(data[cols_with_zeros], function(x) ifelse(x == 0, NA, x))
data[cols_with_zeros] <- lapply(data[cols_with_zeros], function(x) {
  ifelse(is.na(x), median(x, na.rm = TRUE), x)
})


set.seed(123)
splitIndex <- createDataPartition(data$Outcome, p = 0.8, list = FALSE)
traindata <- data[splitIndex, ]
testdata  <- data[-splitIndex, ]


model_path <- "model/diabetes_rf_model.rds"
if (!file.exists(model_path)) {
  stop("Model file not found. Please train the model using main.R first.")
}
model <- readRDS(model_path)


predictions <- predict(model, testdata)
prediction  <- factor(predictions, levels = c(0, 1))
reference   <- factor(testdata$Outcome, levels = c(0, 1))


conf_matrix <- confusionMatrix(prediction, reference)


cat("Confusion Matrix:\n")
print(conf_matrix)
cat("\n Accuracy:", round(conf_matrix$overall["Accuracy"], 3), "\n")
cat("Sensitivity:", round(conf_matrix$byClass["Sensitivity"], 3), "\n")
cat("Specificity:", round(conf_matrix$byClass["Specificity"], 3), "\n")

dir.create("output", showWarnings = FALSE)
results <- data.frame(Actual = testdata$Outcome, Predicted = predictions)
write.csv(results, "output/predictions.csv", row.names = FALSE)
cat("\n Predictions saved to: output/predictions.csv\n")


cat("\n Unique predicted values:\n")
print(unique(predictions))

cat("\n Distribution of predicted classes:\n")
print(table(prediction))

cat("\n Distribution of actual classes in test data:\n")
print(table(testdata$Outcome))

cat("\n Model type:\n")
print(model$type)
source("predict_diabetes.R")

saveRDS(model, file = "daibetes_model.rds")
 
install.packages("plumber")
library(plumber)
install.packages("promises")
library(promises)
install.packages("swagger")
library(swagger)
install.packages(c("future", "httpuv", "jsonlite", "htmltools"))
