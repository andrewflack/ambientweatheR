#' Get or set Ambient Weather API key
#'
#' @param force Force setting new API key in current environment
#'
#' @source Environment variable approach (and code) based on the \href{https://github.com/hrbrmstr/darksky}{darksky} package by Bob Rudis
#'
#' @export
get_or_set_api_key <- function(force = FALSE) {

  env <- Sys.getenv('AW_API_KEY')

  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var AW_API_KEY to your Ambient Weather API key",
         call. = FALSE)
  }

  message("Couldn't find env var AW_API_KEY. See ?get_or_set_api_key for more details.")
  message("Please enter your API key and press enter:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("API key entry failed", call. = FALSE)
  }

  message("Updating AW_API_KEY env var")
  Sys.setenv(AW_API_KEY = pat)

  pat

}
