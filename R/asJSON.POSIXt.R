setMethod("asJSON", "POSIXt", function(x, POSIXt = c("string", "ISO8601", "epoch",
  "mongo"), UTC = FALSE, digits, time_format = NULL, always_decimal = FALSE, ...) {
  # note: UTC argument doesn't seem to be working consistently maybe use ?format
  # instead of ?as.character

  # Validate
  POSIXt <- match.arg(POSIXt)

  # Encode based on a schema
  if (POSIXt == "mongo") {
    if (is(x, "POSIXlt")) {
      x <- as.POSIXct(x)
    }
    df <- data.frame("$date" = floor(unclass(x) * 1000), check.names = FALSE)
    if(inherits(x, "scalar"))
      class(df) <- c("scalar", class(df))
    return(asJSON(df, digits = 0, always_decimal = FALSE, ...))
  }

  # Epoch millis
  if (POSIXt == "epoch") {
    return(asJSON(floor(unclass(as.POSIXct(x)) * 1000), digits = digits, always_decimal = FALSE, ...))
  }

  # Strings
  if(is.null(time_format)){
    time_format <- if(POSIXt == "string"){
      ""
    } else if(isTRUE(UTC)){
      "%Y-%m-%dT%H:%M:%SZ"
    } else {
      "%Y-%m-%dT%H:%M:%S"
    }
  }

  if (isTRUE(UTC)) {
    asJSON(as.character(x, format = time_format, tz = "UTC"), ...)
  } else {
    asJSON(as.character(x, format = time_format), ...)
  }
})
