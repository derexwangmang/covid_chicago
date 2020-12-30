# covid_chicago
Exploratory Data Analysis of Chicago COVID-19 Data

## Purpose

My Exploratory Data Analysis focused on visualizing how the coronavirus exacerbated existing inequalities. As part of my project, I retrieved datasets that included cases and deaths in the Chicagoland area, diabetes rates, asthma rates, and income levels. Because my original dataset about COVID-19 cases was separated by ZIP code, I used ZIP code as the unique key across datasets. I explored the following questions:

* What is the overall trend of coronavirus cases and deaths in the Chicagoland area?
* How does median income relate to coronavirus case and death rates?
* How do medical conditions, specifically diabetes and asthma rates, relate to the rates of coronavirus cases and deaths?

## Datasets

* [COVID-19 Cases, Tests, and Deaths by ZIP Code](https://data.cityofchicago.org/Health-Human-Services/COVID-19-Cases-Tests-and-Deaths-by-ZIP-Code/yhhz-zm2v)

This dataset provides information on COVID-19 statistics separated by zip code (City of Chicago, 2020). These statistics include zip code, week number, weekly cases, weekly tests, percent tested positive weekly, and weekly deaths.

* [Public Health Statistics - Diabetes](https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Diabetes-hospitalizations/vekt-28b5)

This dataset provides information about the number of hospital discharges for those with diabetes between 2000 and 2011 (Illinois Department of Public Health, 2012). The dataset contains variables include the zip code, the number of hospializations in each year, and the crude rate in each year, providing information about medical conditions that exist among different populations.

* [Public Health Statistics - Asthma](https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Asthma-hospitalizations-i/vazh-t57q)

The fourth dataset provides information about the number of hospital discharges for those with asthma between 2000 and 2011 (Illinois Department of Public Health, 2012). The dataset contains variables include the zip code, the number of hospializations in each year, and the crude rate in each year, providing information about medical conditions that exist among different populations.

* [Obtaining Median Income Data for Zip Codes](https://www.reddit.com/r/datasets/comments/hixfeo/how_to_obtain_median_income_data_for_zip_codes/)

The above source is an informative guide to accessing the median income data for different zip codes ("How to obtain," 2020). Later, I leveraged the `tidycensus` API to retrieve the data.

## Methodology

Combing these data with the original coronavirus case data, I fitted and visualized trendlines, separated by the previous mentioned factors. I identified two significant patterns.

## Findings

1. The higher the income, the lower the rates. When examining the case and death rates across ZIP codes with varying incomes, I aggregated the data by income levels of 20000. The highest peaks were found in ZIP codes with the lowest incomes, and the lowest peaks in ZIP codes with the highest incomes. This may be a result of white collar work, where workers within those ZIP codes successfully transitioned to a work from environment. Their reduced contact with others may have led to decreased cases. Another potential reason is that those from the lowest income ZIP codes use public transportation to travel, which may expose them to more cases, whereas those from the wealthy population may have their own method of transportation.

2. ZIP codes with higher asthma rates had higher death rates than the death rates for ZIP codes with lower asthma rates. While the trends are the same, with a peak around 04/26 and a constant rate of near 0 afterwards, the death rates were significantly higher than that of the ZIP codes with the lowest asthma rates. Since the coronavirus affects the respiratory system, and asthma is a medical condition that affects the lungs, I expected the death rate to be higher for the ZIP code with higher rates of asthma. This visualization below quantifies my assumption, illustrating how the populations with higher asthma rates have larger peaks that extend over longer periods of time.

## Citations

City of Chicago. (2020, October 15). *COVID-19 Cases, Tests, and Deaths by ZIP Code*. Chicago Data Portal. https://data.cityofchicago.org/Health-Human-Services/COVID-19-Cases-Tests-and-Deaths-by-ZIP-Code/yhhz-zm2v.

City of Chicago. (2020, September 10). *COVID-19 Testing Sites. Chicago Data Portal*. https://data.cityofchicago.org/Health-Human-Services/COVID-19-Testing-Sites/thdn-3grx.

*How to obtain median income data for zip codes*. Reddit. (2020). https://www.reddit.com/r/datasets/comments/hixfeo/how_to_obtain_median_income_data_for_zip_codes/.

Illinois Department of Public Health (IDPH). (2012, August 6). *Public Health Statistics - Diabetes hospitalizations in Chicago, 2000 - 2011*. Chicago Data Portal. https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Diabetes-hospitalizations/vekt-28b5.

Illinois Department of Public Health (IDPH). (2012, September 17). *Public Health Statistics - Asthma hospitalizations in Chicago, by year, 2000 - 2011*. Chicago Data Portal. https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Asthma-hospitalizations-i/vazh-t57q.
