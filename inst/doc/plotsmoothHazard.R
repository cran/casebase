## ----setup, include = FALSE---------------------------------------------------
evaluate_vignette <- requireNamespace("visreg", quietly = TRUE) & requireNamespace("splines", quietly = TRUE)
knitr::opts_chunk$set(
  collapse = TRUE, 
  eval = evaluate_vignette,
  results='hide',
  fig.show='all',
  comment = "#>"
)

## -----------------------------------------------------------------------------
#  library(casebase)
#  library(visreg)
#  library(splines)
#  library(ggplot2)
#  data("brcancer")
#  str(brcancer)

## ----results='show'-----------------------------------------------------------
#  mod_cb <- fitSmoothHazard(cens ~ ns(log(time), df = 3) + hormon,
#                            data = brcancer,
#                            time = "time")
#  summary(mod_cb)

## ----results='hide', fig.show='all'-------------------------------------------
#  par(mfrow = c(1, 2))
#  plot(mod_cb,
#       hazard.params = list(xvar = "time",
#                            cond = list(hormon = 0),
#                            alpha = 0.05,
#                            main = "No Hormonal Therapy Hazard Function"))
#  
#  plot(mod_cb,
#       hazard.params = list(xvar = "time",
#                            cond = list(hormon = 1),
#                            alpha = 0.05,
#                            main = "Hormonal Therapy Hazard Function"))

## -----------------------------------------------------------------------------
#  plot(mod_cb,
#       hazard.params = list(xvar = "time",
#                            by = "hormon",
#                            alpha = 0.05,
#                            ylab = "Hazard"))

## -----------------------------------------------------------------------------
#  plot_results <- plot(mod_cb,
#       hazard.params = list(xvar = "time",
#                            by = "hormon",
#                            alpha = 0.10,
#                            ylab = "Hazard",
#                            plot = FALSE))

## ----results='show'-----------------------------------------------------------
#  head(plot_results$fit)

## -----------------------------------------------------------------------------
#  gg_object <- plot(mod_cb,
#                    hazard.params = list(xvar = "time",
#                                         by = "hormon",
#                                         alpha = 0.20, # 80% CI
#                                         ylab = "Hazard",
#                                         gg = TRUE))

## ----results='show'-----------------------------------------------------------
#  attr(gg_object,"class")

## -----------------------------------------------------------------------------
#  gg_object +
#    theme_minimal()+
#    theme(legend.position = "bottom") +
#    labs(title = "Casebase") +
#    scale_x_continuous(n.breaks = 10)

## ----results='show'-----------------------------------------------------------
#  mod_cb_tvc <- fitSmoothHazard(cens ~ hormon * ns(log(time), df = 3),
#                                data = brcancer,
#                                time = "time")
#  summary(mod_cb_tvc)

## -----------------------------------------------------------------------------
#  plot(mod_cb_tvc,
#       hazard.params = list(xvar = "time",
#                            by = "hormon",
#                            alpha = 0.05,
#                            ylab = "Hazard"))

## ----results='show'-----------------------------------------------------------
#  mod_cb_tvc <- fitSmoothHazard(cens ~ estrec * ns(log(time), df = 3),
#                                data = brcancer,
#                                time = "time")
#  summary(mod_cb_tvc)

## -----------------------------------------------------------------------------
#  # computed at the 10th, 50th and 90th quantiles of estrec
#  plot(mod_cb_tvc,
#       hazard.params = list(xvar = "time",
#                            by = "estrec",
#                            alpha = 1,
#                            ylab = "Hazard"))

## -----------------------------------------------------------------------------
#  # computed at quartiles of estrec
#  plot(mod_cb_tvc,
#       hazard.params = list(xvar = c("time"),
#                            by = "estrec",
#                            alpha = 1,
#                            breaks = 4,
#                            ylab = "Hazard"))

## -----------------------------------------------------------------------------
#  # computed where I want
#  plot(mod_cb_tvc,
#       hazard.params = list(xvar = c("time"),
#                            by = "estrec",
#                            alpha = 1,
#                            breaks = c(3,2200),
#                            ylab = "Hazard"))

## ----perspective-plots, eval = FALSE------------------------------------------
#  visreg2d(mod_cb_tvc,
#           xvar = "time",
#           yvar = "estrec",
#           trans = exp,
#           print.cond = TRUE,
#           zlab = "Hazard",
#           plot.type = "image")
#  
#  visreg2d(mod_cb_tvc,
#           xvar = "time",
#           yvar = "estrec",
#           trans = exp,
#           print.cond = TRUE,
#           zlab = "Hazard",
#           plot.type = "persp")
#  
#  # this can also work if 'rgl' is installed
#  # visreg2d(mod_cb_tvc,
#  #          xvar = "time",
#  #          yvar = "estrec",
#  #          trans = exp,
#  #          print.cond = TRUE,
#  #          zlab = "Hazard",
#  #          plot.type = "rgl")

## ----multiple-predictors, results='show'--------------------------------------
#  mod_cb_tvc <- fitSmoothHazard(cens ~ estrec * ns(log(time), df = 3) +
#                                  horTh +
#                                  age +
#                                  menostat +
#                                  tsize +
#                                  tgrade +
#                                  pnodes +
#                                  progrec,
#                                data = brcancer,
#                                time = "time")
#  summary(mod_cb_tvc)

## ----many-predictors-plot, results='show', R.options=list(max.print=1)--------
#  plot(mod_cb_tvc,
#       hazard.params = list(xvar = "time",
#                            by = "estrec",
#                            alpha = 1,
#                            breaks = 2,
#                            ylab = "Hazard"))

## ----many-predictors-plot-2, results='show', R.options=list(max.print=1)------
#  plot(mod_cb_tvc,
#       hazard.params = list(xvar = "time",
#                            by = "estrec",
#                            cond = list(tgrade = "III", age = 49),
#                            alpha = 1,
#                            breaks = 2,
#                            ylab = "Hazard"))

## ----eprchd, results='show'---------------------------------------------------
#  data("eprchd")
#  eprchd <- transform(eprchd,
#                      treatment = factor(treatment, levels = c("placebo","estPro")))
#  str(eprchd)
#  
#  fit_mason <- fitSmoothHazard(status ~ treatment*time,
#                               data = eprchd,
#                               time = "time")
#  summary(fit_mason)

## ----plot-mason, results='show'-----------------------------------------------
#  newtime <- quantile(fit_mason[["originalData"]][[fit_mason[["timeVar"]]]],
#                      probs = seq(0.01, 0.99, 0.01))
#  
#  # reference category
#  newdata <- data.frame(treatment = factor("placebo",
#                                           levels = c("placebo", "estPro")),
#                        time = newtime)
#  str(newdata)
#  
#  plot(fit_mason,
#       type = "hr",
#       newdata = newdata,
#       var = "treatment",
#       increment = 1,
#       xvar = "time",
#       ci = T,
#       rug = T)

## -----------------------------------------------------------------------------
#  plot(fit_mason,
#       type = "hr",
#       newdata = newdata,
#       exposed = function(data) transform(data, treatment = "estPro"),
#       xvar = "time",
#       ci = T,
#       rug = T)

## ----results='show'-----------------------------------------------------------
#  newdata <- data.frame(treatment = factor("estPro",
#                                           levels = c("placebo", "estPro")),
#                        time = newtime)
#  str(newdata)
#  
#  levels(newdata$treatment)

## -----------------------------------------------------------------------------
#  plot(fit_mason,
#       type = "hr",
#       newdata = newdata,
#       var = "treatment",
#       increment = -1,
#       xvar = "time",
#       ci = TRUE,
#       rug = TRUE)

## ----fig.show='none', results='show'------------------------------------------
#  result <- plot(fit_mason,
#                 type = "hr",
#                 newdata = newdata,
#                 var = "treatment",
#                 increment = -1,
#                 xvar = "time",
#                 ci = TRUE,
#                 rug = TRUE)
#  head(result)

## ----echo=FALSE, eval=TRUE----------------------------------------------------
print(sessionInfo(), locale = F)

