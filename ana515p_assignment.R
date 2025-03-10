---
  title: "ana515p_assignment"
author: "Jihoon Park"
date: "2025-03-09"
output: html_document
---
  
  # Load necessary packages
  ```{r setup, include=FALSE}
library(readxl) # For reading excel
library(dplyr) # For data manipulation
library(stringr) # For string cleaning
library(writexl) # For exporting cleaned data
library(ggplot2) # For visualizations
```

# Read and Merge Data from Two Sheets
```{r}
# Read data from both sheets in the Excel file
president_2020_1 <- read_excel("/Users/jihoonpark/Documents/R_projects/ANA515P/presidential_polls_2020.xlsx", sheet=1)
president_2020_2 <- read_excel("/Users/jihoonpark/Documents/R_projects/ANA515P/presidential_polls_2020.xlsx", sheet=2)

# Ensure data type consistency before merging
president_2020_1$startdate <- as.character(president_2020_1$startdate)
president_2020_2$startdate <- as.character(president_2020_2$startdate)

president_2020_1$weight <- as.numeric(president_2020_1$weight)
president_2020_2$weight <- as.numeric(president_2020_2$weight)

president_2020_1$influence <- as.numeric(president_2020_1$influence)
president_2020_2$influence <- as.numeric(president_2020_2$influence)

president_2020_1$pct <- as.numeric(president_2020_1$pct)
president_2020_2$pct <- as.numeric(president_2020_2$pct)

# Merge the two sheets into one dataset
president_2020 <- bind_rows(president_2020_1, president_2020_2)

# view 
View(president_2020)

```

# Cleaning State Names
```{r}
# Define a mapping of full state names to abbreviations
state_mapping <- c(
  "ALABAMA" = "AL", "ALASKA" = "AK", "ARIZONA" = "AZ", "ARKANSAS" = "AR", "CALIFORNIA" = "CA", 
  "COLORADO" = "CO", "CONNECTICUT" = "CT", "DELAWARE" = "DE", "FLORIDA" = "FL", "GEORGIA" = "GA", 
  "HAWAII" = "HI", "IDAHO" = "ID", "ILLINOIS" = "IL", "INDIANA" = "IN", "IOWA" = "IA", 
  "KANSAS" = "KS", "KENTUCKY" = "KY", "LOUISIANA" = "LA", "MAINE" = "ME", "MARYLAND" = "MD", 
  "MASSACHUSETTS" = "MA", "MICHIGAN" = "MI", "MINNESOTA" = "MN", "MISSISSIPPI" = "MS", 
  "MISSOURI" = "MO", "MONTANA" = "MT", "NEBRASKA" = "NE", "NEVADA" = "NV", "NEW HAMPSHIRE" = "NH", 
  "NEW JERSEY" = "NJ", "NEW MEXICO" = "NM", "NEW YORK" = "NY", "NORTH CAROLINA" = "NC", 
  "NORTH DAKOTA" = "ND", "OHIO" = "OH", "OKLAHOMA" = "OK", "OREGON" = "OR", "PENNSYLVANIA" = "PA", 
  "RHODE ISLAND" = "RI", "SOUTH CAROLINA" = "SC", "SOUTH DAKOTA" = "SD", "TENNESSEE" = "TN", 
  "TEXAS" = "TX", "UTAH" = "UT", "VERMONT" = "VT", "VIRGINIA" = "VA", "WASHINGTON" = "WA", 
  "WEST VIRGINIA" = "WV", "WISCONSIN" = "WI", "WYOMING" = "WY"
)

president_2020 <- president_2020 %>%
  mutate(
    state = str_to_upper(state),  # Convert to uppercase
    state = str_trim(state),      # Remove leading/trailing spaces
    state = recode(state, !!!state_mapping)  # Map full state names to abbreviations
  )


```

# Remove Rows with All NA Values
```{r}

# Automatically select the 17 columns
all_vars <- names(president_2020)[1:17]

# Remove rows where all 17 columns are NA
president_2020 <- president_2020 %>%
  filter(rowSums(!is.na(select(., all_of(all_vars)))) > 0)

# Justification: Rows with only missing values provide no useful information for analysis.

# Check the cleaned dataset
View(president_2020) #617rows -> 414rows

```

# Cleaning Character Variables
```{r}

# Remove special characters and convert to lowercase for uniformity
president_2020 <- president_2020 %>%
  mutate(
    candidate_name = str_to_lower(str_replace_all(candidate_name, "[^a-zA-Z0-9]", "")),
    pollster = str_to_lower(str_replace_all(pollster, "[^a-zA-Z0-9]", "")),
    population = str_to_lower(str_replace_all(population, "[^a-zA-Z0-9]", ""))
  )

# Justification: Special characters and inconsistent casing could cause issues in grouping and comparisons.

# Check cleaned values
View(president_2020)

```

# Visualization
```{r}
#1. Polling Distributions by State
ggplot(president_2020, aes(x = state, y = trend_and_house_adjusted_pct)) +
  geom_boxplot(aes(fill = state)) +
  labs(title = "Distribution of Adjusted Polling Percentages by State",
       x = "State", y = "Trend & House Adjusted Poll %") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate state names for readability

# Justification: Boxplots allow for an easy comparison of polling variations across states.



#2. Bar Chart - Average Adjusted Polling Percentage by State
# Compute average polling percentage per state
state_avg <- president_2020 %>%
  group_by(state) %>%
  summarise(avg_poll = mean(trend_and_house_adjusted_pct, na.rm = TRUE)) %>%
  arrange(desc(avg_poll))  # Sort from highest to lowest

# Bar chart visualization
ggplot(state_avg, aes(x = reorder(state, avg_poll), y = avg_poll, fill = avg_poll)) +
  geom_col() +
  coord_flip() +  # Flip for better readability
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Average Adjusted Polling Percentage by State",
       x = "State", y = "Adjusted Poll %") +
  theme_minimal()

# Justification: Bar charts make it easier to see which states have the highest polling percentages.


```
# Save the cleaned data.
```{r}

write.csv(president_2020, "presidnet_2020_cleaned.csv", row.names = FALSE)

```


