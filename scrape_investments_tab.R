library(tidyverse)
library(rvest)

#' Scraper for the investments tab of a given company. This is a bit trickier
#' than getting tables from a profile since Pitchbook does not actually use 
#' HTML table elements.
#' @param filenames vector of filenames (can be just a single filename) specifying
#' the HTML files containing investments data.
scrape_investments_tab <- function(filenames){
  map_dfr(filenames, \(filename){
    html <- read_html(filename)
    fund_name <- html |> 
      html_element(".headline__title") |> 
      html_text() |> 
      str_trim()
    company_ids <- html |> 
      html_elements("#search-results-data-table-left") |> 
      html_elements("#search-results-data-table-fixed-table") |> 
      html_elements("span.number") |> 
      html_text()
    
    company_names <- html |> 
      html_elements("#search-results-data-table-left") |> 
      html_elements("#search-results-data-table-fixed-table") |> 
      html_elements(".entity-format__entity-profile") |> 
      html_text()
    
    column_names <- html |> 
      html_elements("#search-results-data-table-header-table") |> 
      html_elements(".data-table__cell") |> 
      html_text() |> 
      str_trim()
    
    results <- html |> 
      html_elements("#search-results-data-table-table .data-table__tbody .data-table__row") |> 
      map_dfr(\(row){
        row |> 
          html_elements(".data-table__cell") |> 
          html_text() |> 
          set_names(column_names) |> 
          as.list() |> 
          as_tibble()
      }) |> 
      mutate(fund_name = fund_name,
             `Company Name` = company_names,
             company_id = company_ids) |> 
      select(fund_name, `Company Name`, everything())
    
    return(results)
  })
}
