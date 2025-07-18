library(dplyr)
library(ggplot2)
library(caret)
library(randomForest)


data <- read.csv("data/diabetes.csv")

data$Outcome <- factor(data$Outcome, levels = c(0, 1)) 


columns_to_clean <- c("Glucose", "BloodPressure", "SkinThickness", "Insulin", "BMI")
data[columns_to_clean] <- lapply(data[columns_to_clean], function(x) ifelse(x == 0, NA, x))

data[columns_to_clean] <- lapply(data[columns_to_clean], function(x) {
  ifelse(is.na(x), median(x, na.rm = TRUE), x)
})


dir.create("output", showWarnings = FALSE)  

ggplot(data, aes(x = Outcome)) +
  geom_bar(fill = "darkgreen") +
  theme_minimal() +
  labs(title = "Diabetes Outcome Count",
       x = "Outcome (0 = No, 1 = Yes)",
       y = "Number of People")
ggsave("output/outcome_distribution.png")


ggplot(data, aes(x = Age, color = Outcome)) +
  geom_density(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Age Density by Diabetes Outcome",
       x = "Age",
       y = "Density",
       color = "Outcome")
ggsave("output/age_density.png")

ggplot(data, aes(x = Outcome, y = Glucose, fill = Outcome)) +
  geom_boxplot() +
  coord_flip() +
  theme_minimal() +
  labs(title = "Glucose Levels by Outcome",
       x = "Outcome",
       y = "Glucose Level")
ggsave("output/glucose_boxplot.png")


set.seed(123)  
splitIndex <- createDataPartition(data$Outcome, p = 0.8, list = FALSE)
traindata <- data[splitIndex, ]
testdata  <- data[-splitIndex, ]


model <- randomForest(Outcome ~ ., data = traindata, ntree = 500)


print(model)
print(importance(model))


dir.create("model", showWarnings = FALSE)
saveRDS(model, "model/diabetes_rf_model.rds")


predictions <- predict(model, testdata)


prediction <- factor(predictions, levels = c(0, 1))
reference  <- factor(testdata$Outcome, levels = c(0, 1))
conf_matrix <- confusionMatrix(prediction, reference)


print(conf_matrix)
cat("\n Accuracy:", round(conf_matrix$overall["Accuracy"], 3), "\n")
cat("Sensitivity:", round(conf_matrix$byClass["Sensitivity"], 3), "\n")
cat("Specificity:", round(conf_matrix$byClass["Specificity"], 3), "\n")

results <- data.frame(Actual = testdata$Outcome, Predicted = predictions)
write.csv(results, "output/predictions.csv", row.names = FALSE)
cat("\n Predictions saved to: output/predictions.csv\n")
source("main.R")
