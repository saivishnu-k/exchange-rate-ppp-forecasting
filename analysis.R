# Exchange rate forecasting and PPP testing (Ireland and UK)
# Supporting code for the report: PPP tests + ARIMA modelling + 12 month forecast

suppressPackageStartupMessages({
  library(readxl)
  library(tseries)
  library(forecast)
  library(moments)
})

# =========================
# User configuration
# =========================
# Put your dataset in the same folder as this script or update the path below.
DATA_FILE <- "Final Dataset BF.xlsx"

# If your dataset begins in January of START_YEAR set START_MONTH to 1
START_YEAR <- 2014
START_MONTH <- 1

# Sheet name if needed (set to NULL to use first sheet)
SHEET_NAME <- NULL

# =========================
# Load data
# =========================
if (!file.exists(DATA_FILE)) {
  stop(
    paste(
      "Dataset file not found:", DATA_FILE,
      "\nAdd the file to this folder or update DATA_FILE in the script."
    )
  )
}

df <- read_excel(DATA_FILE, sheet = SHEET_NAME)

# Expected columns in the Excel file
# Nominal Exchange Rate
# Real Excahnge Rate  (note the spelling in the original dataset)
# CPI Ireland 2023
# CPI UK 2023

required_cols <- c(
  "Nominal Exchange Rate",
  "Real Excahnge Rate",
  "CPI Ireland 2023",
  "CPI UK 2023"
)

missing_cols <- setdiff(required_cols, names(df))
if (length(missing_cols) > 0) {
  stop(
    paste(
      "Missing required columns:",
      paste(missing_cols, collapse = ", "),
      "\nPlease check your Excel file headers."
    )
  )
}

# Coerce numeric
df[["Nominal Exchange Rate"]] <- as.numeric(df[["Nominal Exchange Rate"]])
df[["Real Excahnge Rate"]] <- as.numeric(df[["Real Excahnge Rate"]])
df[["CPI Ireland 2023"]] <- as.numeric(df[["CPI Ireland 2023"]])
df[["CPI UK 2023"]] <- as.numeric(df[["CPI UK 2023"]])

# =========================
# Transformations
# =========================
df$log_nominal_exchange <- log(df[["Nominal Exchange Rate"]])
df$log_real_exchange <- log(df[["Real Excahnge Rate"]])
df$log_CPI_home <- log(df[["CPI Ireland 2023"]])
df$log_CPI_foreign <- log(df[["CPI UK 2023"]])

df_clean <- df[complete.cases(df[, c(
  "log_nominal_exchange",
  "log_real_exchange",
  "log_CPI_home",
  "log_CPI_foreign"
)]), ]

cat("\nSkewness and kurtosis (log series)\n")
sk <- sapply(df_clean[, c("log_nominal_exchange", "log_real_exchange", "log_CPI_home", "log_CPI_foreign")], skewness)
ku <- sapply(df_clean[, c("log_nominal_exchange", "log_real_exchange", "log_CPI_home", "log_CPI_foreign")], kurtosis)
print(round(sk, 4))
print(round(ku, 4))

# Visual inspection (optional)
par(mfrow = c(2, 2))
plot(df$log_nominal_exchange, type = "l", main = "Log nominal exchange rate", xlab = "", ylab = "")
plot(df$log_real_exchange, type = "l", main = "Log real exchange rate", xlab = "", ylab = "")
plot(df$log_CPI_home, type = "l", main = "Log CPI Ireland", xlab = "", ylab = "")
plot(df$log_CPI_foreign, type = "l", main = "Log CPI UK", xlab = "", ylab = "")

# =========================
# Stationarity testing
# =========================
cat("\nADF tests (levels)\n")
print(adf.test(na.omit(df$log_nominal_exchange)))
print(adf.test(na.omit(df$log_real_exchange)))
print(adf.test(na.omit(df$log_CPI_home)))
print(adf.test(na.omit(df$log_CPI_foreign)))

# ACF and PACF plots for exchange rates (optional)
par(mfrow = c(2, 2))
acf(na.omit(df$log_nominal_exchange), main = "ACF log nominal exchange")
pacf(na.omit(df$log_nominal_exchange), main = "PACF log nominal exchange")
acf(na.omit(df$log_real_exchange), main = "ACF log real exchange")
pacf(na.omit(df$log_real_exchange), main = "PACF log real exchange")

# =========================
# PPP testing
# =========================
cat("\nAbsolute PPP test\n")
df$log_relative_price <- df$log_CPI_home - df$log_CPI_foreign
df_ppp <- na.omit(df[, c("log_nominal_exchange", "log_relative_price")])

ppp_model <- lm(log_nominal_exchange ~ log_relative_price, data = df_ppp)
print(summary(ppp_model))

cat("\nRelative PPP test\n")
df_diff <- df[-1, ]
df_diff$diff_log_exchange <- diff(df$log_nominal_exchange)
df_diff$diff_log_CPI_home <- diff(df$log_CPI_home)
df_diff$diff_log_CPI_foreign <- diff(df$log_CPI_foreign)
df_diff$inflation_diff <- df_diff$diff_log_CPI_home - df_diff$diff_log_CPI_foreign

rel_ppp_model <- lm(diff_log_exchange ~ inflation_diff, data = df_diff)
print(summary(rel_ppp_model))

# =========================
# ARIMA modelling
# =========================
log_RER_ts <- ts(
  na.omit(df$log_real_exchange),
  start = c(START_YEAR, START_MONTH),
  frequency = 12
)

cat("\nDifferencing suggested by ndiffs\n")
cat("ndiffs:", ndiffs(log_RER_ts), "\n")

# Candidate models with d = 1
model1 <- Arima(log_RER_ts, order = c(0, 1, 0))
model2 <- Arima(log_RER_ts, order = c(1, 1, 0))
model3 <- Arima(log_RER_ts, order = c(0, 1, 1))
model4 <- Arima(log_RER_ts, order = c(1, 1, 1))
model5 <- Arima(log_RER_ts, order = c(2, 1, 0))
model6 <- Arima(log_RER_ts, order = c(0, 1, 2))
model7 <- Arima(log_RER_ts, order = c(2, 1, 2))

models <- list(model1, model2, model3, model4, model5, model6, model7)
model_names <- c(
  "ARIMA(0,1,0)",
  "ARIMA(1,1,0)",
  "ARIMA(0,1,1)",
  "ARIMA(1,1,1)",
  "ARIMA(2,1,0)",
  "ARIMA(0,1,2)",
  "ARIMA(2,1,2)"
)

cat("\nModel diagnostics (Ljung Box lag 12)\n")
for (i in seq_along(models)) {
  cat("\n", model_names[i], "\n")
  s <- summary(models[[i]])
  print(s)

  cat("\nLjung Box\n")
  print(Box.test(residuals(models[[i]]), lag = 12, type = "Ljung-Box"))
}

cat("\nAIC comparison\n")
print(AIC(model1, model2, model3, model4, model5, model6, model7))

# Choose the best model (set to model1 to match the report selection)
best_model <- model1

cat("\nSelected model\n")
print(summary(best_model))

# Forecast 12 months
fc <- forecast(best_model, h = 12)

png("forecast_log_real_exchange.png", width = 1200, height = 700)
plot(fc, main = "12 month forecast of log real exchange rate", xlab = "Time", ylab = "Log RER")
dev.off()

cat("\nSaved forecast plot: forecast_log_real_exchange.png\n")
