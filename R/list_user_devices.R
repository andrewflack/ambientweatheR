#' List user's available devices and each device's most recent data
#'
#'
#' @export
list_user_devices <- function(){

  url <- paste0("https://api.ambientweather.net/v1/devices?applicationKey=", get_or_set_application_key(),
                "&apiKey=", get_or_set_api_key())

  response <- httr::GET(url = url)

  httr::stop_for_status(response)

  return(purrr::flatten(httr::content(response)))
}
