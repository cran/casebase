## ----setup, echo=TRUE, message=FALSE, warning=FALSE---------------------------
library(survival)
library(casebase)
library(ggplot2)
library(data.table)

## -----------------------------------------------------------------------------
data("ERSPC")
head(ERSPC)

## -----------------------------------------------------------------------------
pt_object <- casebase::popTime(ERSPC, event = "DeadOfPrCa")

## -----------------------------------------------------------------------------
head(pt_object)
class(pt_object)

## -----------------------------------------------------------------------------
# plot method for objects of class 'popTime'
plot(pt_object)

## -----------------------------------------------------------------------------
# stratified population time plot
pt_object_strat <- casebase::popTime(ERSPC, 
                                     event = "DeadOfPrCa", 
                                     exposure = "ScrArm")

## -----------------------------------------------------------------------------
head(pt_object_strat)
class(pt_object_strat)

## -----------------------------------------------------------------------------
attr(pt_object_strat, "exposure")

## -----------------------------------------------------------------------------
plot(pt_object_strat)

## -----------------------------------------------------------------------------
plot(pt_object_strat,
     facet.params = list(ncol = 2))

## -----------------------------------------------------------------------------
plot(pt_object_strat,
     add.base.series = TRUE)

## ----error=TRUE---------------------------------------------------------------
# load data
data(bmtcrr)
str(bmtcrr)

# table of event status by exposure
table(bmtcrr$Status, bmtcrr$D)

# error because it can't determine a time variable
popTimeData <- popTime(data = bmtcrr)

## -----------------------------------------------------------------------------
popTimeData <- popTime(data = bmtcrr, time = "ftime")
class(popTimeData)

## -----------------------------------------------------------------------------
plot(popTimeData,
     add.case.series = FALSE)

## -----------------------------------------------------------------------------
plot(popTimeData,
     add.case.series = FALSE,
     ribbon.params = list(color = "red", fill = "blue", size = 2, alpha = 0.2))

## -----------------------------------------------------------------------------
plot(popTimeData,
     add.case.series = TRUE,
     comprisk = TRUE)

## -----------------------------------------------------------------------------
plot(popTimeData,
     add.case.series = TRUE,
     add.base.series = TRUE,
     comprisk = TRUE)

## -----------------------------------------------------------------------------
plot(popTimeData,
     add.case.series = TRUE,
     add.base.series = TRUE,
     add.competing.event = TRUE,
     comprisk = TRUE)

## -----------------------------------------------------------------------------
plot(popTimeData,
     add.case.series = TRUE,
     add.base.series = FALSE,
     add.competing.event = TRUE,
     comprisk = TRUE)

## -----------------------------------------------------------------------------
# create 'popTime' object
popTimeData <- popTime(data = bmtcrr, time = "ftime", exposure = "D")
attr(popTimeData, "exposure")

plot(popTimeData,
     add.case.series = TRUE,
     add.base.series = TRUE,
     add.competing.event = TRUE,
     comprisk = TRUE)

## -----------------------------------------------------------------------------
plot(popTimeData,
     add.case.series = TRUE,
     add.base.series = TRUE,
     add.competing.event = TRUE,
     comprisk = TRUE,
     case.params = list(mapping = aes(x = time, y = yc, colour = "Relapse", fill = "Relapse")),
     base.params = list(mapping = aes(x = time, y = ycoord, colour = "Base series", fill = "Base series")),
     competing.params = list(mapping = aes(x = time, y = yc, colour = "Competing event", fill = "Competing event")),
     fill.params = list(name = "Legend Name",
                        breaks = c("Relapse", "Base series", "Competing event"),
                        values = c("Relapse" = "blue", 
                                   "Competing event" = "red", 
                                   "Base series" = "orange"))
     )

## -----------------------------------------------------------------------------
# veteran data in library(survival)
data("veteran")
str(veteran)
popTimeData <- casebase::popTime(data = veteran)
class(popTimeData)
plot(popTimeData)

## -----------------------------------------------------------------------------
# Label the factor so that it appears in the plot
veteran <- transform(veteran, trt = factor(trt, levels = 1:2,
                                           labels = c("standard", "test")))

# create 'popTime' object
popTimeData <- popTime(data = veteran, exposure = "trt")

# object of class 'popTime'
class(popTimeData)

# has name of exposure variable as an attribute
attr(popTimeData, "exposure")

## -----------------------------------------------------------------------------
# plot method for objects of class 'popTime'
plot(popTimeData)

## -----------------------------------------------------------------------------
# data from library(survival)
data("heart")
str(heart)

# create time variable for time in study
heart <- transform(heart,
                   time = stop - start,
                   transplant = factor(transplant,
                                       labels = c("no transplant", "transplant")))

# stratify by transplant indicator
popTimeData <- popTime(data = heart, exposure = "transplant")

plot(popTimeData)

## -----------------------------------------------------------------------------
# data from library(survival)
data("cancer")
str(cancer)

# since the event indicator 'status' is numeric, it must have
# 0 for censored and 1 for event
cancer <- transform(cancer,
                    status = status - 1,
                    sex = factor(sex, levels = 1:2,
                                 labels = c("Male", "Female")))

popTimeData <- popTime(data = cancer)
plot(popTimeData)

## -----------------------------------------------------------------------------
popTimeData <- popTime(data = cancer, exposure = "sex")

plot(popTimeData,
     casebase.theme = FALSE)

## -----------------------------------------------------------------------------
set.seed(1)
nobs <- 500

# simulation parameters
a1 <- 1.0
b1 <- 200
a2 <- 1.0
b2 <- 50
c1 <- 0.0
c2 <- 0.0

# end of study time
eost <- 10

# e event type 0-censored, 1-event of interest, 2-competing event
# t observed time/endpoint
# z is a binary covariate
DTsim <- data.table(ID = seq_len(nobs), z=rbinom(nobs, 1, 0.5))
setkey(DTsim, ID)
DTsim[,`:=` (event_time = rweibull(nobs, a1, b1 * exp(z * c1)^(-1/a1)),
             competing_time = rweibull(nobs, a2, b2 * exp(z * c2)^(-1/a2)),
             end_of_study_time = eost)]
DTsim[,`:=`(event = 1 * (event_time < competing_time) +
                2 * (event_time >= competing_time),
            time = pmin(event_time, competing_time))]
DTsim[time >= end_of_study_time, event := 0]
DTsim[time >= end_of_study_time, time:=end_of_study_time]

## -----------------------------------------------------------------------------
# create 'popTime' object
popTimeData <- popTime(data = DTsim, time = "time", event = "event")
plot(popTimeData)

## -----------------------------------------------------------------------------
# stratified by binary covariate z
popTimeData <- popTime(data = DTsim, time = "time", event = "event", exposure = "z")

# we can line up the plots side-by-side instead of one on top of the other
# we can also change the theme by adding 
plot(popTimeData,
     facet.params = list(ncol = 2)) + theme_linedraw()

## ----echo=FALSE, eval=TRUE----------------------------------------------------
print(sessionInfo(), locale = FALSE)

