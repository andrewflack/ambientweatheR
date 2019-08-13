#' Fetch data from a given device
#'
#' @param mac_address Device MAC address
#' @param date Specific date to retrieve. If blank, device data from the last 24 hours is returned
#'
#' @export
fetch_device_data <- function(mac_address, date = NULL) {

  if(is.null(date)) {
    # return last 24 hours
    url <- paste0("https://api.ambientweather.net/v1/devices/", mac_address,
                  "?apiKey=", get_or_set_api_key(),
                  "&applicationKey=", get_or_set_application_key())
  } else {
    # return preceding 24 hours from input date (midnight), converted from system timezone to UTC
    end_date <- lubridate::with_tz(lubridate::as_datetime(date, Sys.timezone()), "UTC") + lubridate::days(1)

    url <- paste0("https://api.ambientweather.net/v1/devices/", mac_address,
                  "?apiKey=", get_or_set_api_key(),
                  "&applicationKey=", get_or_set_application_key(),
                  "&endDate=", format(end_date, "%Y-%m-%dT%X.000Z"))
  }

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

  out <- parsed %>%
    purrr::map_df(~.x) %>%
    # reorder columns (move date column to first position)
    dplyr::select(date_time = date, dplyr::everything(), -dateutc) %>%
    dplyr::mutate(date_time = lubridate::with_tz(lubridate::as_datetime(date_time, "UTC"), Sys.timezone())) %>%
    purrr::map_df(rev)

  if(!is.null(date)) {
    # trim a few records that extend beyond the date of interest
    out <- out %>%
      dplyr::filter(lubridate::as_date(date_time) == as.character(date))
  }

  # Pause 1 second to comply with 1 request/sec rate cap
  Sys.sleep(1)

  structure(
    list(
      content = out,
      response = response
    ),
    class = "ambientweather_api"
  )
}
