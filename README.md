# Real_Estate_Exploratory_Analysis

Exploratory Analysis of the Texas Real Estate Market

# Texas Real Estate Analysis

## Project Overview
This project analyzes real estate data from Texas, focusing on market trends across different cities. By examining variables such as sales volumes, median prices, and inventory levels, the analysis provides insights into the real estate market dynamics in Texas cities over time.

### Dataset Description
The dataset contains information about real estate transactions in various Texas cities including:
* **City information (categorical)**
* **Monthly sales numbers**
* **Sales volume (in millions of dollars)**
* **Median price of homes**
* **Number of listings**
* **Months of inventory**
* **Year and month data for temporal analysis**

## Key Analysis Components

### Descriptive Statistics
1. **Basic Data Exploration**:
   * **Data structure and dimensions**
   * **Summary statistics for numeric variables**
   * **Frequency distributions for categorical variables (cities)**

2. **Statistical Measures**:
   * **Measures of central tendency (mean, median)**
   * **Measures of dispersion (variance, standard deviation, IQR)**
   * **Distribution shape analysis (skewness, kurtosis)**

3. **Frequency Analysis**:
   * **Classification of data into intervals**
   * **Absolute and relative frequency distributions**
   * **Calculation of the Gini index for inequality measurement**

### Derived Metrics
* **Average Price Calculation**: **Total volume divided by number of sales**
* **Listing Effectiveness**: **Ratio of sales to listings (normalized to percentage)**

### Comparative Analysis
* **Summary statistics grouped by city and year**
* **Variance analysis of key metrics across different dimensions**

## Visualization Methods

### Box Plots
* **Median home price distribution across cities**
* **Sales volume distribution by city and year**

### Bar Charts
* **Monthly sales trends across different years**
* **City-specific performance comparisons**

### Line Charts
* **Temporal analysis of sales data**
* **Comparison of cities over the full time period**

## Key Findings
* **Different cities show varying patterns in median home prices**
* **Seasonal trends are evident in monthly sales data**
* **Year-over-year changes reveal market growth/contraction periods**
* **Listing effectiveness varies significantly between markets**

## Usage
The analysis script can be run in R and requires the following packages:
* **ggplot2**
* **dplyr**
* **moments**

## Future Improvements
Potential enhancements include:
* **Predictive modeling of future price trends**
* **Correlation analysis with economic indicators**
* **Geographic visualization of price variations**
* **Seasonality adjustment techniques**

