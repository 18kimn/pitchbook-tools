#' Pulls down investment tab HTML files stored at `folder_url` then spits out a 
#' consolidated tibble. 
#' 
#' @param folder_url A URL to the google drive folder containing (only) HTML 
#' files for investments for funds. See `googledrive:drive_ls` for more info.
library(tidyverse)
library(googledrive)

scrape_googledrive_investments <- function(folder_url){
  ids <- drive_ls(folder_url) |> 
    pull(id)
  
  map_dfr(ids, \(id){
    filename <- tempfile()
    drive_download(id, filename)
    scrape_investments_tab(filename)
  })
}