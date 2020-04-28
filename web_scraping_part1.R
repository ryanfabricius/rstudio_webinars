# Retrieiving data from API exerice
# Rstudio Webinar 2016
# Watched 4/27/2020

# Link to the webinar
# https://resources.rstudio.com/webinars/extracting-data-web-part1

# Load libraries
library(httr)
library(jsonlite)

# Set path to Hadley Wickham's GitHub
hw.path <- "/users/hadley"

# Create function to retrieve and parse data from GitHub API
github_api <- function(path) {
  
  # Create Hadley Wickham's personal URL
  url <- modify_url("https://api.github.com", path = path)
  
  # Retrieve Data
  resp <- GET(url)
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  
  # Parse Data
  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)
  
  # Structure Data
  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "github_api"
  )
}

# Format output of github_api structure
print.github_api <- function(x, ...) {
  cat("<GitHub ", x$path, ">\n", sep = "")
  str(x$content)
  invisible(x)
}

# Run github_api on Hadley Wickham's path
hw.github <- github_api(hw.path)
hw.github
