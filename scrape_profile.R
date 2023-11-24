library(tidyverse)
library(rvest)

#' Scrapes all tables from the profile page of a company. 
#' Take care to have selected the maximum number of rows; by default only up to 
#' 10 are displayed on the Pitchbook UI, and you can select up to 250 to be 
#' displayed at a time.
#' @param filename string to an html file representing the profile you want to scrape.
#' @param table_name string to query for a specific table. To see the available
#' table names for a given HTML file, use the `get_profile_table_names` function.
#' If `table_name` is not specified, all tables will be returned in a list.
scrape_profile_table <- function(filename, table_name = NULL){
  html <- read_html(filename)
  get_table <- function(html, table_name){
    html |> 
      html_element(paste0("#", table_name)) |> 
      html_element("table") |>
      html_table()
  }
  
  if(!is.null(table_name)){
    return(get_table(html, table_name))
  } else {
    table_names <- get_profile_table_names(html)
    return(map(table_names, \(table_name){get_table(html, table_name)}) |> 
             set_names(table_names))
  }
}

#' Returns a list of available table names you can query for in `scrape_profile_table`.
#' @param filename string to an html file representing the profile you want to scrape.
get_profile_table_names <- function(filename){
  sections <- html |> html_elements("section")
  has_tables <- sections |> 
    map_lgl(\(section){
      length(html_element(section, "table")) > 0
    })
  has_ids <- sections |> 
    map_lgl(\(section){!is.na(html_attr(section, "id"))})
  sections[has_ids & has_tables] |> 
    html_attr("id")
}
