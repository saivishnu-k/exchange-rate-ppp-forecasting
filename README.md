# Exchange rate forecasting and PPP testing (Ireland and UK)

## Overview
This repository contains the code used to reproduce the core results from the EC6011 Business Forecasting report on Ireland and the United Kingdom using monthly data from January 2014 to December 2024. The analysis tests Purchasing Power Parity and forecasts the log real exchange rate using the Box Jenkins ARIMA methodology in R. 

## What this code reproduces
1. Log transformations of nominal exchange rate, real exchange rate, CPI Ireland, CPI UK :contentReference[oaicite:2]{index=2}
2. Stationarity testing using ADF tests :contentReference[oaicite:3]{index=3}
3. Absolute PPP test using regression of log nominal exchange rate on log relative prices, with slope around minus 1.029 and R squared around 0.36 
4. Relative PPP test using regression of change in log nominal exchange rate on inflation differential, showing no support with slope near zero and p value around 0.989 
5. ARIMA model comparison for log real exchange rate and selection of ARIMA(0,1,0) using AIC and Ljung Box diagnostics (p value around 0.8596) 
6. 12 month forecast from ARIMA(0,1,0) :contentReference[oaicite:7]{index=7}

## Data required
The script expects a single Excel file named data.xlsx in the same folder as analysis.R.

Minimum required columns:
Date
NER
CPI_IE
CPI_UK

Optional column:
RER

Definitions used in the report:
NER is GBP per EUR
RER is computed as NER times CPI_UK divided by CPI_IE 

If your column names differ, the script still works because it uses flexible matching.

## How to run
1. Upload data.xlsx into the repository
2. Open analysis.R in RStudio
3. Run the script from top to bottom

The script prints model summaries and saves key plots in the working directory.

## Notes
This is a student project replication of the report workflow. The results are expected to match the report narrative, including the selection of ARIMA(0,1,0) as the best fitting model for log real exchange rate over this sample period. 
