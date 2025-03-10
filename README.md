# McDaniel
# ANA515P Assignment: Presidential Poll Data Cleaning & Visualization

## Project Description
This project focuses on cleaning and analyzing presidential poll data from 2020. The dataset includes various polling statistics from multiple sources, which required preprocessing to standardize state names, remove missing values, and clean text data.

## Data Cleaning Process
- State Names: Converted to uppercase and standardized to two-letter abbreviations.
- Missing Data: Removed rows where all key variables were missing.
- Character Variables: Removed special characters and normalized text format.
- Numeric Variables: Ensured correct data types for calculations.

## Visualizations
1. Boxplot: Shows the distribution of adjusted polling percentages by state.
2. Bar Chart: Displays the average adjusted polling percentage per state.

## Dataset Files
- `presidential_polls_2020.xlsx` -> the original dataset
- `president_2020_cleaned.cvs` -> cleaned dataset

## How to Run the Code
1. Install required R packages: `ggplot2`, `dplyr`, `readxl`, `stringr`, `writexl`
2. Run `ana515p_assignment.R` to process the data and generate visualizations.


