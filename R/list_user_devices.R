#' List user's available devices and each device's most recent data
#'
#'
#' @export
list_user_devices <- function(){

  url <- paste0("https://api.ambientweather.net/v1/devices?applicationKey=", get_or_set_application_key(),
                "&apiKey=", get_or_set_api_key())

  response <- httr::GET(url = url)

  if (httr::http_type(response) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  parsed <- jsonlite::fromJSON(httr::content(response, "text"), simplifyVector = FALSE)

  if (httr::http_error(response)) {
    stop(
      sprintf(
        "AmbientWeather API request failed [%s] %s",
        httr::status_code(response),
        parsed$error
      ),
      call. = FALSE
    )
  }

  # Pause 1 second to comply with 1 request/sec rate cap
  Sys.sleep(1)

  structure(
    list(
      content = parsed %>% purrr::flatten(),
      response = response
    ),
    class = "ambientweather_api"
  )

}
