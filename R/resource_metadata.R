#' Get a table of available fields and their types for a specified resource.
#'
#' @param resource A character string containing the resource id of the data set
#'  to be returned.
#'
#' @return A data.frame detailing the names and types of all fields available
#'  for the chosen resource.
#'
#' @examples
#' \dontrun{
#' resource_metadata(resource="edee9731-daf7-4e0d-b525-e4c1469b8f69")
#' }
#'
#' @export
resource_metadata <- function(resource) {

  query <- utils::URLencode(
    glue::glue(
      "https://www.opendata.nhs.scot/api/3/action/",
      "datastore_search?id={resource}&limit=0"
    ))
  
  cap_url(query)
  
  res = httr::GET(query)
  
  httr::stop_for_status(res)
  
  cont = httr::content(res)
  
  cont = lapply(cont$result$fields, as.data.frame, stringsAsFactors = FALSE)
  
  cont = data.table::setDF(
    data.table::rbindlist(cont, use.names = TRUE, fill = TRUE)
    )[c("id", "type")]
  
  return(cont)
}
