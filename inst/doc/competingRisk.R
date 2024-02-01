## ----echo=TRUE, eval=TRUE-----------------------------------------------------
set.seed(12345)
library(casebase)
data(bmtcrr)
head(bmtcrr)

## ----poptime1, eval=TRUE------------------------------------------------------
nobs <- nrow(bmtcrr)
ftime <- bmtcrr$ftime
ord <- order(ftime, decreasing = FALSE)

# We split the person-moments in four categories:
# 1) at-risk
# 2) main event
# 3) competing event
# 4) censored
yCoords <- cbind(cumsum(bmtcrr[ord, "Status"] == 2), 
                 cumsum(bmtcrr[ord, "Status"] == 1),
                 cumsum(bmtcrr[ord, "Status"] == 0))
yCoords <- cbind(yCoords, nobs - rowSums(yCoords))

# Plot only at-risk
plot(0, type = 'n', xlim = c(0, max(ftime)), ylim = c(0, nobs), 
     xlab = 'Follow-up time', ylab = 'Population')
polygon(c(0, 0, ftime[ord], max(ftime), 0),
        c(0, nobs, yCoords[,4], 0, 0), col = "grey90")
cases <- bmtcrr[, "Status"] == 1

# randomly move the cases vertically
moved_cases <- yCoords[cases[ord], 4] * runif(sum(cases))
points((ftime[ord])[cases[ord]], moved_cases, pch = 20, 
       col = "red", cex = 1)

## ----poptime2, eval=TRUE------------------------------------------------------
# Plot at-risk and events
plot(0, type = 'n', xlim = c(0, max(ftime)), ylim = c(0, nobs), 
     xlab = 'Follow-up time', ylab = 'Population')
polygon(x = c(0,ftime[ord], max(ftime), 0), 
        y = c(0, yCoords[,2], 0, 0), 
        col = "firebrick3")
polygon(x = c(0, ftime[ord], ftime[rev(ord)], 0, 0),
        y = c(0, yCoords[,2], rev(yCoords[,2] + yCoords[,4]), nobs, 0), 
        col = "grey90")

# randomly move the cases vertically
moved_cases <- yCoords[cases[ord], 2] + yCoords[cases[ord], 4] * runif(sum(cases))
points((ftime[ord])[cases[ord]], moved_cases, pch = 20,
       col = "red", cex = 1)
legend("topright", legend = c("Relapse", "At-risk"), 
       col = c("firebrick3", "grey90"),
       pch = 15)

## ----poptime3, eval=TRUE------------------------------------------------------
plot(0, type = 'n', xlim = c(0, max(ftime)), ylim = c(0, nobs), 
     xlab = 'Follow-up time', ylab = 'Population')
polygon(x = c(0, max(ftime), max(ftime), 0),
        y = c(0, 0, nobs, nobs), col = "white")
# Event of interest
polygon(x = c(0,ftime[ord], max(ftime), 0), 
        y = c(0, yCoords[,2], 0, 0), 
        col = "firebrick3")
# Risk set
polygon(x = c(0, ftime[ord], ftime[rev(ord)], 0, 0),
        y = c(0, yCoords[,2], rev(yCoords[,2] + yCoords[,4]), nobs, 0), 
        col = "grey90")
# Competing event
polygon(x = c(0, ftime[ord], max(ftime), 0), 
        y = c(nobs, nobs - yCoords[,1], nobs, nobs), 
        col = "dodgerblue2")

# randomly move the cases vertically
moved_cases <- yCoords[cases[ord], 2] + yCoords[cases[ord], 4] * runif(sum(cases))
points((ftime[ord])[cases[ord]], moved_cases, pch = 20,
       col = "red", cex = 1)
legend("topright", legend = c("Relapse", "Competing event", "At-risk"), 
       col = c("firebrick3", "dodgerblue2", "grey90"),
       pch = 15)

## ----eval=TRUE, warning=FALSE-------------------------------------------------
model1 <- fitSmoothHazard(Status ~ ftime + Sex + D + Phase + Source + Age, 
                          data = bmtcrr, 
                          ratio = 100,
                          time = "ftime")
summary(model1)

## ----eval=TRUE, warning=FALSE-------------------------------------------------
model2 <- fitSmoothHazard(Status ~ log(ftime) + Sex + D + Phase + Source + Age, 
                          data = bmtcrr, 
                          ratio = 100, 
                          time = "ftime")
summary(model2)

## ----eval=TRUE, warning=FALSE-------------------------------------------------
model3 <- fitSmoothHazard(
    Status ~ splines::bs(ftime) + Sex + D + Phase + Source + Age, 
    data = bmtcrr, 
    ratio = 100, 
    time = "ftime")
summary(model3)

## ----absRisk, eval=TRUE, warning = FALSE--------------------------------------
linearRisk <- absoluteRisk(object = model1, time = 24, newdata = bmtcrr[1:10,])
logRisk <- absoluteRisk(object = model2, time = 24, newdata = bmtcrr[1:10,])
splineRisk <- absoluteRisk(object = model3, time = 24, newdata = bmtcrr[1:10,])

## ----absRiskPlot, eval=TRUE---------------------------------------------------
plot(linearRisk, logRisk,
     xlab = "Linear", ylab = "Log/Spline", pch = 19,
     xlim = c(0,1), ylim = c(0,1), col = 'red')
points(linearRisk, splineRisk,
       col = 'blue', pch = 19)
abline(a = 0, b = 1, lty = 2, lwd = 2)
legend("topleft", legend = c("Log", "Spline"),
       pch = 19, col = c("red", "blue"))

## ----echo=FALSE, eval=TRUE----------------------------------------------------
print(sessionInfo(), locale = FALSE)

