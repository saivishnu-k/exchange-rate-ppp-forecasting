# Exchange Rate Forecasting and Purchasing Power Parity  
Ireland and United Kingdom (2014 to 2024)

## Overview
This repository contains the final academic report and supporting R code for a time series analysis of the Ireland United Kingdom exchange rate from 2014 to 2024. The study examines Purchasing Power Parity and applies Box Jenkins ARIMA modelling to forecast the real exchange rate.

This project was completed as part of the EC6011 Business Forecasting module.

## Contents
- Final project report in PDF format  
- Reproducible R analysis script  
- Summary of methodology and findings  

## Objectives
- Analyse nominal and real EUR GBP exchange rate behaviour  
- Test absolute and relative Purchasing Power Parity  
- Apply ARIMA modelling using the Box Jenkins methodology  
- Generate short term forecasts  
- Interpret results in an applied economic context  

## Methodology
- Log transformation of exchange rate and CPI series  
- Augmented Dickey Fuller tests for stationarity  
- Regression based PPP testing  
- ARIMA identification using ACF and PACF  
- Model selection using AIC and residual diagnostics  
- 12 month forecasting  

## Key Findings
- Exchange rate and CPI series are non stationary in levels  
- Absolute PPP shows statistical significance but weak theoretical support  
- Relative PPP is not supported in this sample period  
- ARIMA(0,1,0) is selected as the best forecasting model  
- Forecasts are flat with increasing uncertainty over time  

## Files
- `Forecasting_Exchange_Rates_PPP_Ireland_UK_2014_2024.pdf`  
  Final academic report  

- `analysis.R`  
  R script reproducing the main analysis and forecasting workflow  

## Data Notice
The dataset used in this project is not included due to size and licensing restrictions.  
The `analysis.R` script requires a local Excel dataset and will not run without the data file.

Users wishing to reproduce the analysis should provide their own dataset with equivalent variables.

## Skills Demonstrated
- Time series analysis  
- ARIMA modelling  
- Econometric testing  
- Statistical interpretation  
- R programming  
- Applied forecasting  

## Author
Sai Vishnu Kandagattla  
MSc Business Analytics  
University College Cork
