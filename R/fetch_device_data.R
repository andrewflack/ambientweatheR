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

  httr::stop_for_status(response)

  out <- purrr::map_df(httr::content(response), ~.x) %>%
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

  return(out)
}
