#' Pulls down investment tab HTML files stored at `folder_url` then spits out a 
#' consolidated tibble. The `googledrive` library sets up an interactive OAuth login
#' so you should be prepared to click "Accept" and such.
#' 
#' @param folder_url A URL to the google drive folder containing (only) HTML 
#' files for investments for funds. See `googledrive:drive_ls` for more info.
library(tidyverse)
library(googledrive)

scrape_googledrive_investments <- function(folder_url){
  ids <- drive_ls(folder_url) |> 
    pull(id)
  directory_name <- tempdir()
  
  map_dfr(ids, \(id){
    filename <- file.path(directory_name, id)
    # Try to use an existing session-specific cache
    if(!file.exists(filename)){
      drive_download(id, filename)
    }
    scrape_investments_tab(filename)
  })
}
