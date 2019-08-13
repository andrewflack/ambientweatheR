#' Print method for Ambient Weather API objects
#'
#' @param x An AmbientWeather API object
#' @param ... Additional arguments
#'
#' @export
print.ambientweather_api <- function(x, ...) {
  cat("<AmbientWeather", ">\n", sep = "")
  str(x$content)
  invisible(x)
}
