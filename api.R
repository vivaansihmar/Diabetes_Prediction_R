library(plumber)

r <- plumb("plumber.R")

r <- pr_static(r, "/", "www")

r$run(host = "0.0.0.0", port = 8000)
