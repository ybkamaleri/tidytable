#' Extract a character column into multiple columns using regex
#'
#' @description
#' _Superseded_
#'
#' `extract()` has been superseded by `separate_wider_regex()`.
#'
#' Given a regular expression with capturing groups, `extract()` turns each group
#' into a new column. If the groups don't match, or the input is `NA`, the output
#' will be `NA`. When you pass same name in the `into` argument it will merge
#' the groups together. Whilst passing `NA` in the `into` arg will drop the group
#' from the resulting `tidytable`
#'
#' @param .df A data.table or data.frame
#' @param col Column to extract from
#' @param into New column names to split into. A character vector.
#' @param regex A regular expression to extract the desired values. There
#' should be one group (defined by `()`) for each element of `into`
#' @param remove If TRUE, remove the input column from the output data.table
#' @param convert If TRUE, runs `type.convert()` on the resulting column.
#' Useful if the resulting column should be type integer/double.
#' @param ... Additional arguments passed on to methods.
#'
#' @export
#'
#' @examples
#' df <- data.table(x = c(NA, "a-b-1", "a-d-3", "b-c-2", "d-e-7"))
#' df %>% extract(x, "A")
#' df %>% extract(x, c("A", "B"), "([[:alnum:]]+)-([[:alnum:]]+)")
#'
#' # If no match, NA:
#' df %>% extract(x, c("A", "B"), "([a-d]+)-([a-d]+)")
#' # drop columns by passing NA
#' df %>% extract(x, c("A", NA, "B"), "([a-d]+)-([a-d]+)-(\\d+)")
#' # merge groups by passing same name
#' df %>% extract(x, c("A", "B", "A"), "([a-d]+)-([a-d]+)-(\\d+)")
extract <- function(.df, col, into, regex = "([[:alnum:]]+)",
                    remove = TRUE, convert = FALSE, ...) {
  check_required(col)
  check_required(into)

  .df <- .df_as_tidytable(.df)

  col <- tidyselect_names(.df, {{ col }})

  groups <- str_extract_groups(.df[[col]], regex, convert = convert)

  if (length(groups) != length(into)) {
    abort(
      glue("`regex` pattern should define {length(into)} groups; {length(groups)} found.")
    )
  }

  keep <- vec_detect_complete(into)
  into <- into[keep]
  groups <- groups[keep]

  if (vec_duplicate_any(into)) {
    groups <- lapply(split(groups, into), pmap_chr, paste0)
    into <- names(groups)
  }

  if (convert) {
    groups <- lapply(groups, type.convert, as.is = TRUE)
  }

  out <- dt_j(.df, (into) := ..groups)

  if (remove && col %notin% into) {
    out <- dt_j(out, (col) := NULL)
  }

  out
}

#' @export
#' @keywords internal
#' @inherit extract
extract. <- function(.df, col, into, regex = "([[:alnum:]]+)",
                     remove = TRUE, convert = FALSE, ...) {
  deprecate_dot_fun()
  extract(.df, {{ col }}, into, regex, remove, convert, ...)
}

globalVariables("..groups")

str_extract_groups <- function(string, pattern, convert = FALSE){
  groups <- regexpr(pattern, string, perl = TRUE)
  start <- attr(groups, "capture.start")
  end <- start + attr(groups, "capture.length") - 1L
  if(is.null(start)) {
    return(list())
  }
  # in order to force substr to return NA when No match is found
  # set the start and end to NA
  none_found <- start == -1
  start[none_found] <- NA
  end[none_found] <- NA

  lapply(
    seq_len(ncol(start)),
    function(.x) substr(string, start[, .x], end[, .x])
  )
}
