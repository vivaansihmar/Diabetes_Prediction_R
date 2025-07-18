library(plumber)
# Load model
model <- readRDS("diabetes2_model.rds")

#* Predict diabetes
#* @param Pregnancies:int
#* @param Glucose:double
#* @param BloodPressure:double
#* @param SkinThickness:double
#* @param Insulin:double
#* @param BMI:double
#* @param DiabetesPedigreeFunction:double
#* @param Age:int
#* @post /predict
function(Pregnancies, Glucose, BloodPressure, SkinThickness, Insulin, BMI, DiabetesPedigreeFunction, Age) {
  
  input_data <- data.frame(
    Pregnancies = as.integer(Pregnancies),
    Glucose = as.numeric(Glucose),
    BloodPressure = as.numeric(BloodPressure),
    SkinThickness = as.numeric(SkinThickness),
    Insulin = as.numeric(Insulin),
    BMI = as.numeric(BMI),
    DiabetesPedigreeFunction = as.numeric(DiabetesPedigreeFunction),
    Age = as.integer(Age)
  )
  
  # Predict
  pred <- predict(model, newdata = input_data)
  
  # Return prediction as a character (for JSON)
  list(prediction = as.character(pred))
}
class(model)
