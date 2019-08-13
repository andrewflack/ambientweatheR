#' Get or set Ambient Weather application key
#'
#' @param force Force setting new API key in current environment
#'
#' @seealso \code{get_or_set_api_key}
#'
#' @export
get_or_set_application_key <- function(force = FALSE) {

  # grab environment variable "AW_APPKICATION_KEY"
  env <- Sys.getenv('AW_APPLICATION_KEY')

  # if it's not empty, we're done
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var AW_APPLICATION_KEY to your Ambient Weather Application key",
         call. = FALSE)
  }

  # ask user to supply the key
  message("Couldn't find env var AW_APPLICATION_KEY. See ?get_or_set_application_key for more details.")
  message("Please enter your Application key and press enter:")
  pat <- readline(": ")

  # if user supplies an empty key, throw an error
  if (identical(pat, "")) {
    stop("Application key entry failed", call. = FALSE)
  }

  message("Updating AW_APPLICATION_KEY env var")
  Sys.setenv(AW_APPLICATION_KEY = pat)

  pat

}
