FROM rstudio/plumber

RUN R -e "install.packages(c('plumber', 'randomForest'))"

COPY ./api.R /app/api.R
COPY ./diabetes_rf_model.rds /app/diabetes_rf_model.rds

CMD ["R", "-e", "pr <- plumber::plumb('/app/api.R'); pr$run(host='0.0.0.0', port=8000)"]
