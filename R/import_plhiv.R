#' Import PLHIV and current on ART Datapacks
#'
#' @param filepath datapack file path in xlsx format
#'
#' @export
#' @keywords internal

import_plhiv <- function(filepath){

  .Deprecated("tame_plhiv",
              msg = "The import_plhiv function has been replaced by tame_plhiv.")

  df_plhiv <- tame_plhiv(filepath)

  return(df_plhiv)
}
