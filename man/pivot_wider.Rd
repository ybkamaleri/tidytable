% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pivot_wider.R
\name{pivot_wider}
\alias{pivot_wider}
\title{Pivot data from long to wide}
\usage{
pivot_wider(
  .df,
  names_from = name,
  values_from = value,
  id_cols = NULL,
  names_sep = "_",
  names_prefix = "",
  names_glue = NULL,
  names_sort = FALSE,
  names_repair = "unique",
  values_fill = NULL,
  values_fn = NULL
)
}
\arguments{
\item{.df}{A data.frame or data.table}

\item{names_from}{A pair of arguments describing which column (or columns) to get the name of the output column \code{name_from},
and which column (or columns) to get the cell values from \code{values_from}).
\code{tidyselect} compatible.}

\item{values_from}{A pair of arguments describing which column (or columns) to get the name of the output column \code{name_from},
and which column (or columns) to get the cell values from \code{values_from}.
\code{tidyselect} compatible.}

\item{id_cols}{A set of columns that uniquely identifies each observation.
Defaults to all columns in the data table except for the columns specified in \code{names_from} and \code{values_from}.
Typically used when you have additional variables that is directly related.
\code{tidyselect} compatible.}

\item{names_sep}{the separator between the names of the columns}

\item{names_prefix}{prefix to add to the names of the new columns}

\item{names_glue}{Instead of using \code{names_sep} and \code{names_prefix}, you can supply a
glue specification that uses the \code{names_from} columns (and special \code{.value}) to create custom column names}

\item{names_sort}{Should the resulting new columns be sorted.}

\item{names_repair}{Treatment of duplicate names. See \code{?vctrs::vec_as_names} for options/details.}

\item{values_fill}{If values are missing, what value should be filled in}

\item{values_fn}{Should the data be aggregated before casting? If the formula doesn't identify a single observation for each cell, then aggregation defaults to length with a message.}
}
\description{
"Widens" data, increasing the number of columns and
decreasing the number of rows.
}
\examples{
df <- tidytable(
  id = 1,
  names = c("a", "b", "c"),
  vals = 1:3
)

df \%>\%
  pivot_wider(names_from = names, values_from = vals)

df \%>\%
  pivot_wider(
    names_from = names, values_from = vals, names_prefix = "new_"
  )
}
