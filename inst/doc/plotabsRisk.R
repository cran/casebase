## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE, 
  results='hide',
  fig.show='all',
  comment = "#>"
)

## ----eval=TRUE----------------------------------------------------------------
library(casebase)
library(survival)
library(ggplot2)


data("brcancer")
mod_cb_glm <- fitSmoothHazard(cens ~ estrec*log(time) + 
                                  horTh + 
                                  age + 
                                  menostat + 
                                  tsize + 
                                  tgrade + 
                                  pnodes + 
                                  progrec,
                              data = brcancer,
                              time = "time", ratio = 10)

summary(mod_cb_glm)

## -----------------------------------------------------------------------------
smooth_risk_brcancer <- absoluteRisk(object = mod_cb_glm, 
                                     newdata = brcancer[c(1,50),])

class(smooth_risk_brcancer)
plot(smooth_risk_brcancer)

## -----------------------------------------------------------------------------
plot(smooth_risk_brcancer, 
     id.names = c("Covariate Profile 1","Covariate Profile 50"), 
     legend.title = "Type", 
     xlab = "time (days)", 
     ylab = "Cumulative Incidence (%)") 

## -----------------------------------------------------------------------------
plot(smooth_risk_brcancer, 
     id.names = c("Covariate Profile 1","Covariate Profile 50"), 
     legend.title = "Type", 
     xlab = "time (days)", 
     ylab = "Cumulative Incidence (%)") + ggplot2::theme_linedraw() 

## -----------------------------------------------------------------------------
cols <- c("#8E063B","#023FA5")

smooth_risk_typical <- absoluteRisk(object = mod_cb_glm, newdata = "typical")
y <- with(brcancer, survival::Surv(time, cens))
plot(y, fun = "event", conf.int = F, col = cols[1], lwd = 2)
plot(smooth_risk_typical, add = TRUE, col = cols[2], lwd = 2, gg = FALSE)
legend("bottomright", 
       legend = c("Kaplan-Meier", "casebase"), 
       col = cols,
       lty = 1,
       lwd = 2,
       bg = "gray90")

## -----------------------------------------------------------------------------
smooth_surv_brcancer <- absoluteRisk(object = mod_cb_glm, 
                                     newdata = brcancer[c(1,50),],
                                     type = "survival")

plot(smooth_surv_brcancer)

## ----eval=requireNamespace("glmnet", quietly = TRUE)--------------------------
mod_cb_glmnet <- fitSmoothHazard(cens ~ estrec*time + 
                                     horTh + 
                                     age + 
                                     menostat + 
                                     tsize + 
                                     tgrade + 
                                     pnodes + 
                                     progrec,
                                 data = brcancer,
                                 time = "time", 
                                 ratio = 1, 
                                 family = "glmnet")

smooth_risk_glmnet <- absoluteRisk(object = mod_cb_glmnet, 
                                   newdata = brcancer[1:10,], 
                                   s = "lambda.min")
plot(smooth_risk_glmnet)

## -----------------------------------------------------------------------------
mod_cb_gam <- fitSmoothHazard(cens ~ estrec + time + 
                                     horTh + 
                                     age + 
                                     menostat + 
                                     tsize + 
                                     tgrade + 
                                     pnodes + 
                                     progrec,
                                 data = brcancer,
                                 time = "time", 
                                 ratio = 1, 
                                 family = "gam")

smooth_risk_gam <- absoluteRisk(object = mod_cb_gam, 
                                newdata = brcancer[1:10,])
plot(smooth_risk_gam)

## ----echo=FALSE, eval=TRUE----------------------------------------------------
print(sessionInfo(), locale = F)

