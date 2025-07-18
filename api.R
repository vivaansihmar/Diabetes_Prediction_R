# api.r

library(plumber)

# Load the model
model <- readRDS("diabetes2_model.rds")

#* @post /predict
#* @param Pregnancies:int
#* @param Glucose:double
#* @param BloodPressure:double
#* @param SkinThickness:double
#* @param Insulin:double
#* @param BMI:double
#* @param DiabetesPedigreeFunction:double
#* @param Age:int
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
  
  pred <- predict(model, newdata = input_data)
  list(prediction = as.character(pred))
}

# Serve static HTML
# This goes at the bottom of api.r
# Will serve www/index.html on localhost:8000
pr() %>%
  pr_static("/", "www") %>%
  pr_mount("/", plumb("api.r")) %>%
  pr_run(host = "0.0.0.0", port = 8000)
