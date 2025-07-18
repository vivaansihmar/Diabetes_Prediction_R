FROM rstudio/plumber

COPY . /app

WORKDIR /app

RUN R -e "install.packages(c('plumber', 'randomForest', 'caret', 'e1071'), repos='http://cran.us.r-project.org')"

EXPOSE 8000

ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('api.R'); pr$run(host='0.0.0.0', port=8000)"]
