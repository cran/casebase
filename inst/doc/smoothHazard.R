## -----------------------------------------------------------------------------
evaluate_vignette <- requireNamespace("eha", quietly = TRUE) && 
    requireNamespace("visreg", quietly = TRUE) && 
    requireNamespace("splines", quietly = TRUE)
knitr::opts_chunk$set(eval = evaluate_vignette)

## -----------------------------------------------------------------------------
#  set.seed(12345)
#  library(casebase)
#  library(survival)
#  data(veteran)
#  table(veteran$status)
#  
#  evtimes <- veteran$time[veteran$status == 1]
#  hist(evtimes, nclass = 30, main = '', xlab = 'Survival time (days)',
#       col = 'gray90', probability = TRUE)
#  tgrid <- seq(0, 1000, by = 10)
#  lines(tgrid, dexp(tgrid, rate = 1.0/mean(evtimes)),
#        lwd = 2, lty = 2, col = 'red')

## -----------------------------------------------------------------------------
#  veteran$prior <- factor(veteran$prior, levels = c(0, 10), labels = c("no","yes"))
#  veteran$celltype <- factor(veteran$celltype,
#                             levels = c('large', 'squamous', 'smallcell', 'adeno'))
#  veteran$trt <- factor(veteran$trt, levels = c(1, 2), labels = c("standard", "test"))

## -----------------------------------------------------------------------------
#  library(eha)
#  y <- with(veteran, Surv(time, status))
#  
#  model1 <- weibreg(y ~ karno + diagtime + age + prior + celltype + trt,
#                    data = veteran, shape = 1)
#  summary(model1)

## -----------------------------------------------------------------------------
#  model2 <- weibreg(y ~ karno + diagtime + age + prior + celltype + trt,
#                    data = veteran, shape = 0)
#  summary(model2)

## -----------------------------------------------------------------------------
#  model3 <- coxph(y ~ karno + diagtime + age + prior + celltype + trt,
#                  data = veteran)
#  summary(model3)

## -----------------------------------------------------------------------------
#  # create popTime object
#  pt_veteran <- popTime(data = veteran)
#  
#  class(pt_veteran)
#  
#  # plot method for objects of class 'popTime'
#  plot(pt_veteran)

## -----------------------------------------------------------------------------
#  model4 <- fitSmoothHazard(status ~ time + karno + diagtime + age + prior +
#               celltype + trt, data = veteran, ratio = 100)
#  summary(model4)

## ----results='show', R.options=list(max.print=1)------------------------------
#  library(visreg)
#  plot(model4,
#       hazard.params = list(alpha = 0.05))

## -----------------------------------------------------------------------------
#  absRisk4 <- absoluteRisk(object = model4, time = 90)
#  mean(absRisk4)
#  
#  ftime <- veteran$time
#  mean(ftime <= 90)

## -----------------------------------------------------------------------------
#  model5 <- fitSmoothHazard(status ~ log(time) + karno + diagtime + age + prior +
#               celltype + trt, data = veteran, ratio = 100)
#  summary(model5)

## -----------------------------------------------------------------------------
#  # Fit a spline for time
#  library(splines)
#  model6 <- fitSmoothHazard(status ~ bs(time) + karno + diagtime + age + prior +
#               celltype + trt, data = veteran, ratio = 100)
#  summary(model6)
#  
#  str(absoluteRisk(object = model6, time = 90))

## -----------------------------------------------------------------------------
#  linearRisk <- absoluteRisk(object = model4, time = 90, newdata = veteran)
#  splineRisk <- absoluteRisk(object = model6, time = 90, newdata = veteran)
#  
#  plot.default(linearRisk, splineRisk,
#       xlab = "Linear", ylab = "Splines", pch = 19)
#  abline(a = 0, b = 1, lty = 2, lwd = 2, col = 'red')

## ----echo = FALSE-------------------------------------------------------------
#  table_coef <- cbind(coefficients(model3),
#                      coefficients(model4)[-(1:2)],
#                      coefficients(model5)[-(1:2)],
#                      coefficients(model6)[-(1:4)])
#  knitr::kable(table_coef, format = "html", digits = 4,
#               col.names = c("Cox model",
#                             "CB linear",
#                             "CB log-linear",
#                             "CB splines"))

## -----------------------------------------------------------------------------
#  # define a specific covariate profile
#  new_data <- data.frame(trt = "test",
#                         celltype = "adeno",
#                         karno = median(veteran$karno),
#                         diagtime = median(veteran$diagtime),
#                         age = median(veteran$age),
#                         prior = "no")
#  
#  # calculate cumulative incidence using casebase model
#  smooth_risk <- absoluteRisk(object = model4,
#                              time = seq(0,300, 1),
#                              newdata = new_data)
#  
#  cols <- c("#8E063B","#023FA5")
#  
#  # cumulative incidence function for the Cox model
#  plot(survfit(model3, newdata = new_data),
#       xlab = "Days", ylab = "Cumulative Incidence (%)", fun = "event",
#       xlim = c(0,300), conf.int = F, col = cols[1],
#       main = sprintf("Estimated Cumulative Incidence (risk) of Lung Cancer\ntrt = test, celltype = adeno, karno = %g,\ndiagtime = %g, age = %g, prior = no", median(veteran$karno), median(veteran$diagtime),
#                      median(veteran$age)))
#  
#  # add casebase curve with legend
#  plot(smooth_risk, add = TRUE, col = cols[2], gg = FALSE)
#  legend("bottomright",
#         legend = c("semi-parametric (Cox)", "parametric (casebase)"),
#         col = cols,
#         lty = c(1, 1),
#         bg = "gray90")

## -----------------------------------------------------------------------------
#  smooth_risk <- absoluteRisk(object = model4,
#                              time = seq(0,300, 1),
#                              newdata = new_data,
#                              type = "survival")
#  
#  plot(survfit(model3, newdata = new_data),
#       xlab = "Days", ylab = "Survival Probability (%)",
#       xlim = c(0,300), conf.int = F, col = cols[1],
#       main = sprintf("Estimated Survival Probability of Lung Cancer\ntrt = test, celltype = adeno, karno = %g,\ndiagtime = %g, age = %g, prior = no", median(veteran$karno), median(veteran$diagtime),
#                      median(veteran$age)))
#  
#  # add casebase curve with legend
#  plot(smooth_risk, add = TRUE, col = cols[2], gg = FALSE)
#  legend("topright",
#         legend = c("semi-parametric (Cox)", "parametric (casebase)"),
#         col = cols,
#         lty = c(1, 1),
#         bg = "gray90")

## ----echo=FALSE, eval=TRUE----------------------------------------------------
print(sessionInfo(), locale = F)

