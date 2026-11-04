library(tidyverse)

top_songs <- read_rds("clean_data.rds")

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

billboard_plot <- billboard_long |>
  semi_join(top_songs, by = c("track", "artist")) |>
  mutate(song = str_c(track, " - ", artist)) |>
  ggplot(aes(x = week, y = rank, group = song)) +
  geom_line(color = "#D1495B", linewidth = 1.2) +
  facet_wrap(
    vars(song),
    ncol = 2,
    labeller = labeller(song = label_wrap_gen(width = 32))
  ) +
  scale_x_continuous(breaks = scales::breaks_pretty(n = 6)) +
  scale_y_reverse(breaks = seq(1, 100, by = 20)) +
  labs(
    title = "Songs that wouldn't leave the charts",
    subtitle = "Each line follows one song; a smaller rank means a higher chart position.",
    x = "Week on the chart",
    y = "Chart rank (1 = highest)",
    caption = "The six songs with the most weeks on the Billboard chart. Source: tidyr::billboard."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background = element_rect(fill = "#F4F7FB", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.spacing = unit(1.2, "lines"),
    strip.background = element_rect(fill = "#243B53", color = NA),
    strip.text = element_text(color = "white", face = "bold", margin = margin(8, 8, 8, 8)),
    plot.title = element_text(face = "bold", size = 20, color = "#102A43"),
    plot.subtitle = element_text(color = "#486581", margin = margin(b = 14)),
    plot.caption = element_text(color = "#627D98", margin = margin(t = 12)),
    axis.title = element_text(face = "bold", color = "#334E68"),
    axis.text = element_text(color = "#486581")
  )

ggsave("billboard.png", plot = billboard_plot, width = 10, height = 8, dpi = 300)
