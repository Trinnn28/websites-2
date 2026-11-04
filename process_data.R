library(tidyverse)

data("billboard", package = "tidyr")

billboard_long <- billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    names_transform = list(week = as.integer),
    values_to = "rank",
    values_drop_na = TRUE
  )

top_songs <- billboard_long |>
  count(track, artist, name = "weeks") |>
  slice_max(weeks, n = 6, with_ties = FALSE)

write_rds(top_songs, file = "clean_data.rds")
