##### bind_rows()

test_that("bind_rows() works with data.tables", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(x = c(1,2,3), y = c(3,4,5))

  bind_df <- df1 %>%
    bind_rows(df2)

  expect_true(is_tidytable(bind_df))
  expect_named(bind_df, c("x","y"))
  expect_equal(bind_df$x, c(1,2,3,1,2,3))
  expect_equal(bind_df$y, c(3,4,5,3,4,5))
})

test_that("bind_rows() works with data.frames", {
  df1 <- data.frame(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.frame(x = c(1,2,3), y = c(3,4,5))

  bind_df <- df1 %>%
    bind_rows(df2)

  expect_named(bind_df, c("x","y"))
  expect_equal(bind_df$x, c(1,2,3,1,2,3))
  expect_equal(bind_df$y, c(3,4,5,3,4,5))
})

test_that("bind_rows() works with a list", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(x = c(1,2,3), y = c(3,4,5))

  df_list <- list(df1, df2)

  bind_df <- bind_rows(df_list)

  expect_named(bind_df, c("x","y"))
  expect_equal(bind_df$x, c(1,2,3,1,2,3))
  expect_equal(bind_df$y, c(3,4,5,3,4,5))
})

test_that("bind_rows() works with list splicing", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(x = c(1,2,3), y = c(3,4,5))

  df_list <- list(df1, df2)

  bind_df <- bind_rows(!!!df_list)

  expect_named(bind_df, c("x","y"))
  expect_equal(bind_df$x, c(1,2,3,1,2,3))
  expect_equal(bind_df$y, c(3,4,5,3,4,5))
})

test_that("bind_rows() preserves attributes", {
  df1 <- tidytable(x = c(1,2,3), y = c(3,4,5))
  df2 <- tidytable(x = c(1,2,3), y = c(3,4,5))

  attr(df1, "test") <- "foo"

  bind_df <- bind_rows(df1, df2)

  expect_equal(attr(bind_df, "test"), "foo")
  expect_true(is_tidytable(bind_df))
})

test_that("bind_rows.() works", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(x = c(1,2,3), y = c(3,4,5))

  bind_df <- df1 %>%
    bind_rows.(df2) %>%
    suppressWarnings()

  expect_true(is_tidytable(bind_df))
  expect_named(bind_df, c("x","y"))
  expect_equal(bind_df$x, c(1,2,3,1,2,3))
  expect_equal(bind_df$y, c(3,4,5,3,4,5))
})

##### bind_cols()
test_that("bind_cols() works with data.tables", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(a = c(1,2,3), b = c(3,4,5))

  bind_df <- df1 %>%
    bind_cols(df2)

  expect_named(bind_df, c("x","y","a","b"))
  expect_equal(bind_df$x, c(1,2,3))
  expect_equal(bind_df$y, c(3,4,5))
  expect_equal(bind_df$a, c(1,2,3))
  expect_equal(bind_df$b, c(3,4,5))
})

test_that("bind_cols() preserves attributes", {
  df1 <- tidytable(x = c(1,2,3), y = c(3,4,5))
  df2 <- tidytable(a = c(1,2,3), b = c(3,4,5))

  attr(df1, "test") <- "foo"

  bind_df <- bind_cols(df1, df2)

  expect_equal(attr(bind_df, "test"), "foo")
  expect_true(is_tidytable(bind_df))
})

test_that("bind_cols() works with data.frames", {
  df1 <- data.frame(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.frame(a = c(1,2,3), b = c(3,4,5))

  bind_df <- df1 %>%
    bind_cols(df2)

  expect_true(is_tidytable(bind_df))
  expect_named(bind_df, c("x","y","a","b"))
  expect_equal(bind_df$x, c(1,2,3))
  expect_equal(bind_df$y, c(3,4,5))
  expect_equal(bind_df$a, c(1,2,3))
  expect_equal(bind_df$b, c(3,4,5))
})

test_that("bind_cols() works with a list", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(a = c(1,2,3), b = c(3,4,5))

  df_list <- list(df1, df2)

  bind_df <- bind_cols(df_list)

  expect_named(bind_df, c("x","y","a","b"))
  expect_equal(bind_df$x, c(1,2,3))
  expect_equal(bind_df$y, c(3,4,5))
  expect_equal(bind_df$a, c(1,2,3))
  expect_equal(bind_df$b, c(3,4,5))
})

test_that("bind_cols - works with list splicing", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(a = c(1,2,3), b = c(3,4,5))

  df_list <- list(df1, df2)

  bind_df <- bind_cols(!!!df_list)

  expect_named(bind_df, c("x","y","a","b"))
  expect_equal(bind_df$x, c(1,2,3))
  expect_equal(bind_df$y, c(3,4,5))
  expect_equal(bind_df$a, c(1,2,3))
  expect_equal(bind_df$b, c(3,4,5))
})

test_that("bind_cols - duplicate names are fixed", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(x = c(1,2,3), y = c(3,4,5))

  df_list <- list(df1, df2)

  bind_df <- suppressMessages(bind_cols(df_list))

  expect_named(bind_df, c("x...1","y...2","x...3","y...4"))
  expect_equal(bind_df$x...1, c(1,2,3))
  expect_equal(bind_df$y...2, c(3,4,5))
  expect_equal(bind_df$x...3, c(1,2,3))
  expect_equal(bind_df$y...4, c(3,4,5))
})

test_that("bind_cols - correctly handles list inputs, (#446)", {
  df <- tidytable(a = 1:3, b = 1:3)
  out <- map_dfc(df, identity)
  expect_true(is_tidytable(out))
  expect_equal(out, df)
})

test_that("bind_cols.() works", {
  df1 <- data.table(x = c(1,2,3), y = c(3,4,5))
  df2 <- data.table(a = c(1,2,3), b = c(3,4,5))

  bind_df <- df1 %>%
    bind_cols.(df2) %>%
    suppressWarnings()

  expect_named(bind_df, c("x","y","a","b"))
  expect_equal(bind_df$x, c(1,2,3))
  expect_equal(bind_df$y, c(3,4,5))
  expect_equal(bind_df$a, c(1,2,3))
  expect_equal(bind_df$b, c(3,4,5))
})
