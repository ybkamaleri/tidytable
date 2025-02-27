#' Add a count column to the data frame
#'
#' @description
#' Add a count column to the data frame.
#'
#' `df %>% add_count(a, b)` is equivalent to using `df %>% mutate(n = n(), .by = c(a, b))`
#'
#' @param .df A data.frame or data.table
#' @param ... Columns to group by. `tidyselect` compatible.
#' @param wt Frequency weights.
#'   Can be `NULL` or a variable:
#'
#'   * If `NULL` (the default), counts the number of rows in each group.
#'   * If a variable, computes `sum(wt)` for each group.
#' @param sort If `TRUE`, will show the largest groups at the top.
#' @param name The name of the new column in the output.
#'
#'   If omitted, it will default to `n`.
#'
#' @export
#'
#' @examples
#' df <- data.table(
#'   a = c("a", "a", "b"),
#'   b = 1:3
#' )
#'
#' df %>%
#'   add_count(a)
add_count <- function(.df, ..., wt = NULL, sort = FALSE, name = NULL) {
  .df <- .df_as_tidytable(.df)

  if (is_ungrouped(.df)) {
    tt_add_count(.df, ..., wt = {{ wt }}, sort = sort, name = name)
  } else {
    .by <- group_vars(.df)
    tt_add_count(.df, any_of(.by), wt = {{ wt }}, sort = sort, name = name)
  }
}

#' @export
#' @keywords internal
#' @inherit add_count
add_count. <- function(.df, ..., wt = NULL, sort = FALSE, name = NULL) {
  deprecate_dot_fun()
  add_count(.df, ..., wt = {{ wt }}, sort = sort, name = name)
}

tt_add_count <- function(.df, ..., wt = NULL, sort = FALSE, name = NULL) {
  .by <- enquos(...)
  wt <- enquo(wt)

  name <- name %||% "n"

  if (quo_is_null(wt)) {
    .df <- mutate(.df, !!name := n(), .by = c(!!!.by))
  } else {
    .df <- mutate(.df, !!name := sum(!!wt, na.rm = TRUE), .by = c(!!!.by))
  }

  if (sort) {
    .df <- arrange(.df, -!!sym(name))
  }

  .df
}

#' @export
#' @rdname add_count
add_tally <- function(.df, wt = NULL, sort = FALSE, name = NULL) {
  add_count(.df, wt = {{ wt }}, sort = sort, name = name)
}

#' @export
#' @keywords internal
#' @inherit add_count
add_tally. <- function(.df, wt = NULL, sort = FALSE, name = NULL) {
  deprecate_dot_fun()
  add_tally(.df, wt = {{ wt }}, sort = sort, name = name)
}
