library(tidyverse)
library(lubridate)

talks <- read_csv("talk_generator/talks.csv", col_types = cols(.default = "c"))

talks_formatted <- paste0("---
title: ", talks$title, "

event: ", talks$event, "
event_url: ", talks$event_url, "

location: ", talks$location, "
address:
  street: ", talks$street, "
  city: ", talks$city, "
  region: ", talks$region, "
  postcode: ", talks$postcode, "
  country: ", talks$country, "

summary: ", talks$summary, "

# Talk start and end times.
#   End time can optionally be hidden by prefixing the line with `#`.
date: ", mdy(talks$date), "
#date_end: '2030-06-01T15:00:00Z'
all_day: true

# Schedule page publish date (NOT talk date).
publishDate: '2017-01-01T00:00:00Z'

authors:
  - admin

tags: []

# Is this a featured talk? (true/false)
featured: false

#links:
#  - icon: twitter
#    icon_pack: fab
#    name: Follow
#    url: https://twitter.com/georgecushen
url_code: ''
url_pdf: ''
url_slides: ", talks$url_slides, "
url_video: ", talks$url_video, "

---")

talks_formatted <- str_replace_all(talks_formatted, "NA", "")

write_md <- function(text, filename) {
  fileConn<-file(filename)
  writeLines(text, fileConn)
  close(fileConn)
}

foldernames <- paste0("content/event/event", 
                    seq(1:length(talks_formatted)))

filenames <- paste0("content/event/event", 
                    seq(1:length(talks_formatted)),
                    "/index.md")

#comment out to overwrite all events
# foldernames <- foldernames[map_lgl(foldernames, dir.exists) == FALSE]
# filenames <- filenames[map_lgl(filenames, file.exists) == FALSE]

map(foldernames, dir.create)
map2(talks_formatted, filenames, ~write_md(.x, .y))
