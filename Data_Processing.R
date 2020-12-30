# Data Processing


# Libraries ---------------------------------------------------------------

library(tidyverse)
library(tidycensus)

# NOTE: All data were retrieved on November 17, 2020.

# COVID Cases by ZIP ------------------------------------------------------

# Reads in data
cases <- read_csv("data/unprocessed/COVID-19_Cases__Tests__and_Deaths_by_ZIP_Code.csv")

# Processes data
# The City of Chicago revised its testing metrics: "NOTE: Starting 10/29/2020, the testing-related columns in this dataset will be based on individual tests, even if performed on the same person, rather than unique people" (City of Chicago, 2020). Thus, I split the data before and after the new metric.

# Rearranges dataset by Week Number and ZIP Code
# Filters out observations with updated metrics
# Mutates `Cases - Weekly` and `Case Rate - Weekly` since values < 5 will be considered missing otherwise (City of Chicago, 2020)
# Drops rows with missing ZIP codes
# Filters out rows with no `Population` data
cases_processed_before_metric_change <- cases %>%
  arrange(`Week Number`) %>%
  group_by(`ZIP Code`) %>%
  arrange(`ZIP Code`) %>%
  filter(`Week End` < "10/29/2020") %>%
  mutate(`Cases - Weekly` = case_when(is.na(`Cases - Weekly`) == TRUE ~ 2.5,
                                      TRUE ~ `Cases - Weekly`),
         `Case Rate - Weekly` = case_when(is.na(`Case Rate - Weekly`) == TRUE ~ 2.5 / Population * 100000,
                                      TRUE ~ `Case Rate - Weekly`)) %>%
  drop_na(`ZIP Code`) %>%
  filter(`Population` != 0)

# Writes updated data to directory
write_csv(cases_processed_before_metric_change, "data/processed/COVID-19_ZIP_Before_Metric_Change.csv")

# Rearranges dataset by Week Number and ZIP Code
# Filters out observations with non-updated metrics
# Mutates `Cases - Weekly` and `Case Rate - Weekly` since values < 5 will be considered missing otherwise (City of Chicago, 2020)
# Drops rows with missing ZIP codes
# Filters out rows with no `Population` data
cases_processed_after_metric_change <- cases %>%
  arrange(`Week Number`) %>%
  group_by(`ZIP Code`) %>%
  arrange(`ZIP Code`) %>%
  filter(`Week End` >= "10/29/2020") %>%
  mutate(`Cases - Weekly` = case_when(is.na(`Cases - Weekly`) == TRUE ~ 2.5,
                                      TRUE ~ `Cases - Weekly`),
         `Case Rate - Weekly` = case_when(is.na(`Case Rate - Weekly`) == TRUE ~ 2.5 / Population * 100000,
                                          TRUE ~ `Case Rate - Weekly`)) %>%
  drop_na(`ZIP Code`) %>%
  filter(`Population` != 0)

# Writes updated data to directory
write_csv(cases_processed_after_metric_change, "data/processed/COVID-19_ZIP_After_Metric_Change.csv")


# COVID Testing Sites -----------------------------------------------------

# Reads in data
sites <- read_csv("data/unprocessed/COVID-19_Testing_Sites.csv")

# Processes data

# Drops all other data other than the 5 last characters of the address (the ZIP code)
sites <- str_sub(sites$Address, start = -5) %>%
  as.numeric()

# Coerced NAs, indicating outlier
# Outlier was "Howard Brown Health Mobile," which listed its location as
# Chicago, IL, due to its mobile nature
sites_processed <- as_tibble(sites[complete.cases(sites)]) %>%
  arrange(value) %>%
  rename(`ZIP Code` = value)

sites_processed <- sites_processed %>%
  group_by(`ZIP Code`) %>%
  count() %>%
  arrange(`ZIP Code`)

# Writes updated data to directory
write_csv(sites_processed, "data/processed/COVID-19_Testing_Sites.csv")


# Diabetes Hospitalizations -----------------------------------------------

# Reads in data
diabetes <- read_csv("data/unprocessed/Public_Health_Statistics-_Diabetes_hospitalizations_in_Chicago__2000_-_2011.csv")

# Processes data

# Identifies the rows with multiple ZIP codes
rows_with_multiple_zip <- diabetes$`ZIP code (or aggregate)` %>%
  str_detect("&")

# Generates a list of the values from the rows with multiple ZIP codes
zip_codes <- diabetes[rows_with_multiple_zip, ]$`ZIP code (or aggregate)` %>%
  str_match_all("[0-9]+") %>%
  unlist() %>%
  as.numeric()

# Retrieves the number of duplicates to create for each row
num_duplicate <- asthma[rows_with_multiple_zip, ]$`ZIP code (or aggregate)` %>%
  str_match_all("[0-9]+") %>%
  map(length) %>%
  unlist()

# Duplicates rows with multiple ZIP codes by the number of different zip codes
expanded_multiple_zip <- diabetes[rows_with_multiple_zip, ] %>%
  mutate(count = num_duplicate) %>%
  uncount(count)

# Iterates through the ZIP codes and replaces values with the appropriate ZIP code
for (i in 1:length(zip_codes)) {
  expanded_multiple_zip$`ZIP code (or aggregate)`[i] <- zip_codes[i]
}

# Creates a copy of the original dataset without the rows with multiple ZIP codes
diabetes_processed <- diabetes[!rows_with_multiple_zip, ]

# Removes the last row which has a location is "CHICAGO"
diabetes_processed <- diabetes_processed %>%
  slice(1:n()-1)

# Appends the duplicated rows and rearranges the data according to the ZIP code
diabetes_processed <- diabetes_processed %>%
  add_row(expanded_multiple_zip) %>%
  arrange(`ZIP code (or aggregate)`)

# Writes updated data to directory
write_csv(diabetes_processed, "data/processed/Public_Health_Statistics-_Diabetes_hospitalizations_in_Chicago__2000_-_2011.csv")


# Asthma Hospitalizations -------------------------------------------------

# Reads in data
asthma <- read_csv("data/unprocessed/Public_Health_Statistics_-_Asthma_hospitalizations_in_Chicago__by_year__2000_-_2011.csv")

# Processes data

# Identifies the rows with multiple ZIP codes
rows_with_multiple_zip <- asthma$`ZIP code (or aggregate)` %>%
  str_detect("&")

# Generates a list of the values from the rows with multiple ZIP codes
zip_codes <- asthma[rows_with_multiple_zip, ]$`ZIP code (or aggregate)` %>%
  str_match_all("[0-9]+") %>%
  unlist() %>%
  as.numeric()

# Retrieves the number of duplicates to create for each row
num_duplicate <- asthma[rows_with_multiple_zip, ]$`ZIP code (or aggregate)` %>%
  str_match_all("[0-9]+") %>%
  map(length) %>%
  unlist()

# Duplicates rows with multiple ZIP codes by the number of different zip codes
expanded_multiple_zip <- asthma[rows_with_multiple_zip, ] %>%
  mutate(count = num_duplicate) %>%
  uncount(count)

# Iterates through the ZIP codes and replaces values with the appropriate ZIP code
for (i in 1:length(zip_codes)) {
  expanded_multiple_zip$`ZIP code (or aggregate)`[i] <- zip_codes[i]
}

# Creates a copy of the original dataset without the rows with multiple ZIP codes
asthma_processed <- asthma[!rows_with_multiple_zip, ]

# Removes the last row which has a location is "CHICAGO"
asthma_processed <- asthma_processed %>%
  slice(1:n()-1)

# Appends the duplicated rows and rearranges the data according to the ZIP code
asthma_processed <- asthma_processed %>%
  add_row(expanded_multiple_zip) %>%
  arrange(`ZIP code (or aggregate)`)

# Writes updated data to directory
write_csv(asthma_processed, "data/processed/Public_Health_Statistics_-_Asthma_hospitalizations_in_Chicago__by_year__2000_-_2011.csv")


# Income Data -------------------------------------------------------------

# Retrieves data through API
census_api_key("#####")

# Reads Data
med_income <- get_acs(geography = "zcta", variables = c(medincome = "B19013_001"), year = 2018)

# Renames column name 
med_income <- rename(med_income, "ZIP Code" = "GEOID")

med_income <- med_income %>%
  mutate(`ZIP Code` = as.numeric(`ZIP Code`))

# Retrieves rows from data based on the ZIP codes present in the cases dataset
med_income <- semi_join(med_income, cases, by = "ZIP Code")

# Writes updated data to directory
write_csv(med_income, "data/processed/median_income_ZIP.csv")


# Citations ---------------------------------------------------------------

# City of Chicago. (2020, October 15). COVID-19 Cases, Tests, and Deaths by ZIP Code. Chicago Data Portal. https://data.cityofchicago.org/Health-Human-Services/COVID-19-Cases-Tests-and-Deaths-by-ZIP-Code/yhhz-zm2v.

