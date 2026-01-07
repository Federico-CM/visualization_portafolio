# ============================================================
# Health indexes evolution over time
# Third world" (1965 baseline)
# using OMS data (1960–2023)
# - Labels are defined ONLY using 1965 thresholds (fixed)
# - Animation runs for the full oms time range (1960–2023)
# ============================================================
library(ggplot2)
library(gganimate)
library(dplyr)
library(readr)

# This assumes that the project works with the repository structure
# If the directory structure changes, adjust the following command
oms <- read_csv("../../../../data/processed/oms_fertility_lifeexp.csv")

# --- Controls ---
frames_per_year <- 15   # higher = slower & smoother
fps <- 20               # MUST be a factor of 100 for GIFs

# --- Rule thresholds ---
# The concept of third world is latent
# The following proxy roughly matches that in 1965
fertility_cutoff <- 3.5
lifeexp_cutoff   <- 65

# --- Data Processing---
# Ensure correct types + keep the full 1960–2023 range that oms has
oms <- oms %>%
  transmute(
    country = as.character(country),
    iso3 = as.character(iso3),
    year = as.numeric(year),
    population = as.numeric(population),
    life_expectancy = as.numeric(life_expectancy),
    fertility = as.numeric(fertility)
  ) #%>%
  #filter(!is.na(year), !is.na(fertility), !is.na(life_expectancy), !is.na(population)) %>%
  #filter(year >= 1960, year <= 2023)

years <- sort(unique(oms$year))
nframes <- length(years) * frames_per_year

# Create year-label data for EVERY frame (prevents flicker)
frame_times <- seq(min(years), max(years), length.out = nframes)

year_df_full <- data.frame(
  year = frame_times,
  x = Inf,
  y = -Inf,
  year_label = round(frame_times)
)

# ============================================================
# 1) DEFINE GROUPS FROM 1965 ONLY (FIXED LABELS)
#    If a country has no 1965 observation, it becomes NA ("Unknown")
# ============================================================

oms_1965 <- oms %>%
  filter(year == 1965) %>%
  select(country, iso3, fertility, life_expectancy, population) %>%
  mutate(
    world_type = case_when(
      fertility < fertility_cutoff & life_expectancy > lifeexp_cutoff ~ "First world",
      TRUE ~ "Third world"
    )
  )

# Join those 1965-based labels into the full dataset
oms <- oms %>%
  left_join(oms_1965 %>% select(country, world_type), by = "country") %>%
  mutate(
    world_type = if_else(is.na(world_type), "Unknown", world_type),
    world_type = factor(world_type, levels = c("First world", "Third world", "Unknown"))
  )

# ============================================================
# 2) ANIMATION (COLORED BY 1965 GROUP)
# ============================================================

p <- ggplot(
  oms,
  aes(
    fertility,
    life_expectancy,
    size = population,
    colour = world_type
  )
) +
  geom_point(alpha = 0.7, show.legend = TRUE) +
  geom_text(
    data = year_df_full,
    aes(x = x, y = y, label = year_label),
    inherit.aes = FALSE,
    hjust = 1.1,
    vjust = -0.5,
    colour = "grey80",
    size = 25,
    alpha = 0.4
  ) +
  scale_colour_manual(values = c(
    "First world" = "#1b9e77",
    "Third world" = "#d95f02",
    "Unknown"     = "grey70"
  )) +
  scale_x_continuous(breaks = c(0, 2, 4, 6, 8, 10)) +
  guides(size = "none") +
  labs(
    title = "Change in 2 health indexes (1960–2023)",
    subtitle = "Third world countries catch up over time",
    x = "Children per Woman",
    y = "Life Expectancy",
    colour = "Color"
  ) +
  theme(
    axis.title.x  = element_text(size = 20),
    axis.title.y  = element_text(size = 20),
    axis.text.x   = element_text(size = 16),
    axis.text.y   = element_text(size = 16),
    plot.title    = element_text(size = 22),
    plot.subtitle = element_text(size = 16),
    legend.title  = element_text(size = 14),
    legend.text   = element_text(size = 12)
  ) +
  transition_time(year) +
  ease_aes("linear")

anim <- animate(
  p,
  nframes = nframes,
  fps = fps,
  renderer = gifski_renderer()
)

# This assumes that the project works with the repository structure
# If the directory structure changes, adjust the following command

anim_save(
  "../../../../plots/english/scatterplots/oms_fertility_lifeexp.gif",
  anim
)
