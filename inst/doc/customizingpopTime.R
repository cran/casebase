## -----------------------------------------------------------------------------
evaluate_vignette <- requireNamespace("colorspace", quietly = TRUE)
knitr::opts_chunk$set(eval = evaluate_vignette)

## ----setup, echo=TRUE, message=FALSE, warning=FALSE---------------------------
library(survival)
library(casebase)
library(ggplot2)
library(data.table)
library(colorspace)

data("ERSPC")

# create poptime object for ERSPC data with exposure attribute
x <- popTime(ERSPC, time = "Follow.Up.Time", event = "DeadOfPrCa", exposure = "ScrArm")
head(x)

## -----------------------------------------------------------------------------
list(data = x,
     mapping = aes(x = time, ymin = 0, ymax = ycoord),
     fill = "grey80",
     alpha = 0.5)

## -----------------------------------------------------------------------------
ribbon.params <- list(fill = "#0072B2")

## -----------------------------------------------------------------------------
(new_ribbon_params <- utils::modifyList(list(data = x,
                                            mapping = aes(x = time, ymin = 0, ymax = ycoord),
                                            fill = "grey80",
                                            alpha = 0.5), 
                                       ribbon.params))

## -----------------------------------------------------------------------------
ggplot() + base::do.call("geom_ribbon", new_ribbon_params)

## -----------------------------------------------------------------------------
exposure_variable <- attr(x, "exposure")
default_facet_params <- list(facets = exposure_variable, ncol = 1)

## -----------------------------------------------------------------------------
ggplot() + 
    base::do.call("geom_ribbon", new_ribbon_params) + 
    base::do.call("facet_wrap", default_facet_params) 

# this is equivalent to
# plot(x, add.case.series = FALSE)

## -----------------------------------------------------------------------------
# Use character vectors as lookup tables:
group_status <- c(
  `0` = "Control Arm",
  `1` = "Screening Arm"
)

plot(x, 
     add.case.series = FALSE, # do not plot the case serires
     facet.params = list(labeller = labeller(ScrArm = group_status), # change labels
                         strip.position = "right") # change facet position
     ) 

## -----------------------------------------------------------------------------
fill_cols <- colorspace::qualitative_hcl(n = 3, palette = "Dark3")

(fill_colors <- c("Case series" = fill_cols[1],
                 "Competing event" = fill_cols[3],
                 "Base series" = fill_cols[2]))

## -----------------------------------------------------------------------------
color_cols <- colorspace::darken(col = fill_cols, amount = 0.3)

(color_colors <- c("Case series" = color_cols[1],
                   "Competing event" = color_cols[3],
                   "Base series" = color_cols[2]))

## ----echo=FALSE---------------------------------------------------------------
plot(seq_along(fill_colors), 
     c(1 ,1 ,2),
     main = "Default colors in casebase population time plots",
     type = "n",
     bty = "n",
     xaxt = "n",
     xlim = c(0,3),
     yaxt = "n",
     xlab = "",
     ylab = "")
points(c(0.5, 1.5, 2.5), c(1.5,1.5,1.5),
       pch = 21, col = color_colors, 
       bg = fill_colors, 
       cex = 8)
text(c(0.5, 1.5, 2.5), c(1.5,1.5,1.5)*1.2,
     labels = names(fill_colors))

## -----------------------------------------------------------------------------
ggplot() + do.call("geom_point", list(data = x[event == 1],
                     mapping = aes(x = time, y = yc, 
                                   colour = "Case series", fill = "Case series"),
                     size = 1.5,
                     alpha = 0.5,
                     shape = 21))

## -----------------------------------------------------------------------------
fill_cols <- colorspace::sequential_hcl(n = 3, palette = "Viridis")

(fill_colors <- c("Case series" = fill_cols[1],
                 "Competing event" = fill_cols[3],
                 "Base series" = fill_cols[2]))

color_cols <- colorspace::darken(col = fill_cols, amount = 0.3)

(color_colors <- c("Case series" = color_cols[1],
                   "Competing event" = color_cols[3],
                   "Base series" = color_cols[2]))

## ----eval=FALSE---------------------------------------------------------------
#  do.call("scale_fill_manual", utils::modifyList(
#    list(name = element_blank(),
#         breaks = c("Case series", "Competing event", "Base series"),
#         values = old_cols), list(values = fill_colors))
#  )
#  
#  do.call("scale_colour_manual", utils::modifyList(
#    list(name = element_blank(),
#         breaks = c("Case series", "Competing event", "Base series"),
#         values = old_cols), list(values = color_colors))
#  )

## -----------------------------------------------------------------------------
# this data ships with the casebase package
data("bmtcrr")

popTimeData <- popTime(data = bmtcrr, time = "ftime", exposure = "D")
plot(popTimeData,
     add.case.series = TRUE, 
     add.base.series = TRUE,
     add.competing.event = TRUE,
     comprisk = TRUE,
     fill.params = list(values = fill_colors),
     color.params = list(value = color_colors))

## -----------------------------------------------------------------------------
plot(popTimeData,
     add.case.series = TRUE, 
     add.base.series = TRUE,
     add.competing.event = TRUE,
     ratio = 1,
     comprisk = TRUE,
     legend = TRUE,
     fill.params = list(values = fill_colors))

## -----------------------------------------------------------------------------
# this data ships with the casebase package
data("bmtcrr")

popTimeData <- popTime(data = bmtcrr, time = "ftime", exposure = "D")
plot(popTimeData,
     add.case.series = TRUE, 
     add.base.series = TRUE,
     add.competing.event = TRUE,
     comprisk = TRUE,
     case.params = list(mapping = aes(x = time, y = yc, fill = "Relapse", colour = "Relapse")),
     base.params = list(mapping = aes(x = time, y = ycoord, fill = "Base series", colour = "Base series")),
     competing.params = list(mapping = aes(x = time, y = yc, fill = "Competing event", colour = "Competing event")),
     fill.params = list(name = "Legend Name",
                          breaks = c("Relapse", "Base series", "Competing event"),
                          values = c("Relapse" = "blue", "Competing event" = "hotpink", "Base series" = "orange")))

## ----eval=FALSE---------------------------------------------------------------
#  # this will work because mapping is the name of the
#  # argument of the list
#  case.params = list(mapping = aes(x = time, y = yc, colour = "Relapse", fill = "Relapse"))

## ----eval=FALSE---------------------------------------------------------------
#  # this will NOT work because the argument of the list has no name
#  # and therefore utils::modifyList, will not override the defaults.
#  case.params = list(aes(x = time, y = yc, colour = "Relapse", fill = "Relapse"))

## ----echo=FALSE, eval=TRUE----------------------------------------------------
print(sessionInfo(), locale = F)

