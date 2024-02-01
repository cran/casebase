## ----include = FALSE----------------------------------------------------------
evaluate_vignette <- requireNamespace("dplyr", quietly = TRUE) && 
    requireNamespace("lubridate", quietly = TRUE)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  eval = evaluate_vignette
)

set.seed(20230802)

## ----stanford-poptime---------------------------------------------------------
library(survival)
library(casebase)

stanford_popTime <- popTime(jasa, time = "futime", 
                            event = "fustat")
plot(stanford_popTime)

## -----------------------------------------------------------------------------
library(dplyr)
library(lubridate)

cb_data <- sampleCaseBase(jasa, time = "futime", 
                          event = "fustat", ratio = 10)

## -----------------------------------------------------------------------------
# Define exposure variable
cb_data <- mutate(cb_data,
                  txtime = time_length(accept.dt %--% tx.date, 
                                       unit = "days"),
                  exposure = case_when(
                    is.na(txtime) ~ 0L,
                    txtime > futime ~ 0L,
                    txtime <= futime ~ 1L
                  ))

## ----warning = FALSE----------------------------------------------------------
library(splines)
# Fit several models
fit1 <- fitSmoothHazard(fustat ~ exposure,
                        data = cb_data, time = "futime")
fit2 <- fitSmoothHazard(fustat ~ exposure + futime,
                        data = cb_data, time = "futime")
fit3 <- fitSmoothHazard(fustat ~ exposure + bs(futime),
                        data = cb_data, time = "futime")
fit4 <- fitSmoothHazard(fustat ~ exposure*bs(futime),
                        data = cb_data, time = "futime")

## -----------------------------------------------------------------------------
# Compute AIC
c("Model1" = AIC(fit1),
  "Model2" = AIC(fit2),
  "Model3" = AIC(fit3),
  "Model4" = AIC(fit4))

## ----stanford-hazard----------------------------------------------------------
# Compute hazards---
# First, create a list of time points for both exposure status
hazard_data <- expand.grid(exposure = c(0, 1),
                           futime = seq(0, 1000,
                                        length.out = 100))
# Set the offset to zero
hazard_data$offset <- 0 
# Use predict to get the fitted values, and exponentiate to 
# transform to the right scale
hazard_data$hazard = exp(predict(fit4, newdata = hazard_data,
                                 type = "link"))
# Add labels for plots
hazard_data$Status = factor(hazard_data$exposure,
                            labels = c("NoTrans", "Trans"))

library(ggplot2)
ggplot(hazard_data, aes(futime, hazard, colour = Status)) +
    geom_line() +
    theme_minimal() +
    theme(legend.position = 'top') +
    ylab('Hazard') + xlab('Follow-up time')

