#' Get or set Ambient Weather application key
#'
#' @param force Force setting new API key in current environment
#'
#' @source Environment variable approach (and code) based on the \href{https://github.com/hrbrmstr/darksky}{darksky} package by Bob Rudis.
#'
#' @export
get_or_set_application_key <- function(force = FALSE) {

  env <- Sys.getenv('AW_APPLICATION_KEY')

  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var AW_APPLICATION_KEY to your Ambient Weather Application key",
         call. = FALSE)
  }

  message("Couldn't find env var AW_APPLICATION_KEY. See ?get_or_set_application_key for more details.")
  message("Please enter your Application key and press enter:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("Application key entry failed", call. = FALSE)
  }

  message("Updating AW_APPLICATION_KEY env var")
  Sys.setenv(AW_APPLICATION_KEY = pat)

  pat

}
