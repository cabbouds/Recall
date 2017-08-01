as.fecha <- function (columna_fecha) {
  return(tryCatch(as.Date(columna_fecha), error=function(e) 0))
}