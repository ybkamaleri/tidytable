#' Uncount a data.table
#'
#' @param .df A data.frame or data.table
#' @param weights A column containing the weights to uncount by
#' @param .remove If TRUE removes the selected `weights` column
#' @param .id A string name for a new column containing a unique identifier for the newly uncounted rows.
#'
#' @export
#'
#' @examples
#' df <- data.table(x = c("a", "b"), n = c(1, 2))
#'
#' uncount(df, n)
#'
#' uncount(df, n, .id = "id")
uncount <- function(.df, weights, .remove = TRUE, .id = NULL) {
  .df <- .df_as_tidytable(.df)

  weights <- enquo(weights)

  .reps <- pull(.df, !!weights)

  out <- vec_rep_each(.df, .reps)

  if (!is.null(.id)) {
    out <- dt_j(out, !!.id := sequence(.reps))
  }

  if (.remove) {
    out <- dt_j(out, !!weights := NULL)
  }

  out
}

#' @export
#' @keywords internal
#' @inherit uncount
uncount. <- function(.df, weights, .remove = TRUE, .id = NULL) {
  deprecate_dot_fun()
  uncount(.df, {{ weights }}, .remove, .id)
}

