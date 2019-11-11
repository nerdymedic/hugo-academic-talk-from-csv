library(tidyverse)
library(lubridate)

#function to create markdown files
write_md <- function(text, filename) {
  fileConn<-file(filename)
  writeLines(text, fileConn)
  close(fileConn)
}

#read in the talks
talks <- read_csv("talks.csv", col_types = cols(.default = "c"))

#generate the markdown
talks_formatted <- paste0("---
abstract: ", talks$abstract, "
address:
  city: ", talks$city, "
  country:
  postcode: 
  region: ", talks$region, "
  street: 
all_day: true
authors: []
date: ", mdy(talks$date), "
event: ", talks$event, "
event_url: 
featured: false
location: ", talks$location, "
math: true
publishDate: ", today(),"
summary: ", talks$summary, "
tags: []
title: ", talks$title, "
url_code: ", talks$url_code,"
url_pdf: ", talks$url_pdf,"
url_slides: ", talks$url_slides,"
url_video: ", talks$url_video,"
---"
)

#remove NAs
talks_formatted <- str_replace_all(talks_formatted, "NA", "")

#create list of folder  names
foldernames <- paste0("content/talk/event", 
                    seq(1:length(talks_formatted)))

#create  list of filesname
filenames <- paste0("content/talk/event", 
                    seq(1:length(talks_formatted)),
                    "/index.md")

#remove files and folders that already exist
#comment out to overwrite exisitng talks
foldernames <- foldernames[map_lgl(foldernames, dir.exists) == FALSE]
filenames <- filenames[map_lgl(filenames, file.exists) == FALSE]

#create the folders
map(foldernames, dir.create)

#create the markdown files
map2(talks_formatted, filenames, ~write_md(.x, .y))
