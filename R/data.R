#' Data on the men in the European Randomized Study of Prostate Cancer Screening
#'
#' @description This data set lists the individual observations for 159,893 men
#'   in the core age group between the ages of 55 and 69 years at entry.
#'
#' @format A data frame with 159,893 observations on the following 3 variables:
#'   \describe{ \item{ScrArm}{Whether in Screening Arm (1) or non-Screening arm
#'   (0) (\code{numeric})} \item{Follow.Up.Time}{The time, measured in years
#'   from randomization, at which follow-up was terminated}
#'   \item{DeadOfPrCa}{Whether follow-up was terminated by Death from Prostate
#'   Cancer (1) or by death from other causes, or administratively (0)} }
#'
#' @details The men were recruited from seven European countries (centers). Each
#'   centre began recruitment at a different time, ranging from 1991 to 1998.
#'   The last entry was in December 2003. The uniform censoring date was
#'   December 31, 2006. The randomization ratio was 1:1 in six of the seven
#'   centres. In the seventh, Finland, the size of the screening group was fixed
#'   at 32,000 subjects. Because the whole birth cohort underwent randomization,
#'   this led to a ratio, for the screening group to the control group, of
#'   approximately 1 to 1.5, and to the non-screening arm being larger than the
#'   screening arm.
#'
#'   The randomization of the Finnish cohorts were carried out on January 1 of
#'   each of the 4 years 1996 to 1999. This, coupled with the uniform December
#'   31 2006 censoring date, lead to large numbers of men with exactly 11, 10, 9
#'   or 8 years of follow-up.
#'
#'   Tracked backwards in time (i.e. from right to left), the Population-Time
#'   plot shows the recruitment pattern from its beginning in 1991, and in
#'   particular the Jan 1 entries in successive years.
#'
#'   Tracked forwards in time (i.e. from left to right), the plot for the first
#'   3 years shows attrition due entirely to death (mainly from other causes).
#'   Since the Swedish and Belgian centres were the last to close their
#'   recruitment - in December 2003 - the minimum potential follow-up is three
#'   years. Tracked further forwards in time (i.e. after year 3) the attrition
#'   is a combination of deaths and staggered entries.
#'
#' @source The individual censored values were recovered by James Hanley from
#'   the Postcript code that the NEJM article (Schroder et al., 2009) used to
#'   render Figure 2 (see Liu et al., 2014, for details). The uncensored values
#'   were more difficult to recover exactly, as the 'jumps' in the Nelson-Aalen
#'   plot are not as monotonic as first principles would imply. Thus, for each
#'   arm, the numbers of deaths in each 1-year time-bin were estimated from the
#'   differences in the cumulative incidence curves at years 1, 2, ... , applied
#'   to the numbers at risk within the time-interval. The death times were then
#'   distributed at random within each bin.
#'
#'   The interested reader can 'see' the large numbers of individual censored
#'   values by zooming in on the original pdf Figure, and watching the Figure
#'   being re-rendered, or by printing the graph and watching the printer
#'   'pause' while it superimposes several thousand dots (censored values) onto
#'   the curve. Watching these is what prompted JH to look at what lay 'behind'
#'   the curve. The curve itself can be drawn using fewer than 1000 line
#'   segments, and unless on peers into the PostScript) the almost 160,000 dots
#'   generated by Stata are invisible.
#' @references Liu Z, Rich B, Hanley JA. Recovering the raw data behind a
#'   non-parametric survival curve. Systematic Reviews 2014; 3:151.
#'   \doi{10.1186/2046-4053-3-151}.
#' @references Schroder FH, et al., for the ERSPC Investigators. Screening and
#'   Prostate-Cancer Mortality in a Randomized European Study. N Engl J Med
#'   2009; 360:1320-8. \doi{10.1056/NEJMoa0810084}.
#' @examples
#' data("ERSPC")
#' set.seed(12345)
#' pt_object_strat <- casebase::popTime(ERSPC[sample(1:nrow(ERSPC), 10000),],
#'                                      event = "DeadOfPrCa",
#'                                      exposure = "ScrArm")
#'
#' plot(pt_object_strat,
#'      facet.params = list(ncol = 2))
"ERSPC"

#' Data on transplant patients
#'
#' Data on patients who underwent haematopoietic stem cell transplantation for
#' acute leukemia.
#'
#' @format A dataframe with 177 observations and 7 variables: \describe{
#'   \item{Sex}{Gender of the individual} \item{D}{Disease: lymphoblastic or
#'   myeloblastic leukemia, abbreviated as ALL and AML, respectively}
#'   \item{Phase}{Phase at transplant (Relapse, CR1, CR2, CR3)} \item{Age}{Age
#'   at the beginning of follow-up} \item{Status}{Status indicator: 0=censored,
#'   1=relapse, 2=competing event} \item{Source}{Source of stem cells: bone
#'   marrow and peripheral blood, coded as BM+PB, or peripheral blood only,
#'   coded as PB} \item{ftime}{Failure time in months} }
# @source Available at the following website:
#   \url{http://www.stat.unipg.it/luca/R/}
#' @references Scrucca L, Santucci A, Aversa F. Competing risk analysis using R:
#'   an easy guide for clinicians. Bone Marrow Transplant. 2007 Aug;40(4):381-7.
#'   \doi{10.1038/sj.bmt.1705727}.
"bmtcrr"

#' Simulated data under Weibull model with Time-Dependent Treatment Effect
#'
#' This simulated data is and description is taken verbatim from the
#' \code{simsurv}.
#'
#' Simulated data under a standard Weibull survival model that incorporates a
#' time-dependent treatment effect (i.e. non-proportional hazards). For the
#' time-dependent effect we included a single binary covariate (e.g. a treatment
#' indicator) with a protective effect (i.e. a negative log hazard ratio), but
#' we will allow the effect of the covariate to diminish over time. The data
#' generating model will be \deqn{h_i(t) = \gamma \lambda (t ^{\gamma - 1})
#' exp(\beta_0 X_i + \beta_1 X_i x log(t))} where where Xi is the binary
#' treatment indicator for individual i, \eqn{\lambda} and \eqn{\gamma} are the
#' scale and shape parameters for the Weibull baseline hazard, \eqn{\beta_0} is
#' the log hazard ratio for treatment when t=1 (i.e. when log(t)=0), and
#' \eqn{\beta_1} quantifies the amount by which the log hazard ratio for
#' treatment changes for each one unit increase in log(t). Here we are assuming
#' the time-dependent effect is induced by interacting the log hazard ratio with
#' log time. The true parameters are 1. \eqn{\beta_0} = -0.5 2. \eqn{\beta_1} =
#' 0.15 3. \eqn{\lambda} = 0.1 4. \eqn{\gamma} = 1.5
#'
#' @format A dataframe with 1000 observations and 4 variables: \describe{
#'   \item{id}{patient id} \item{eventtime}{time of event} \item{status}{event
#'   indicator (1 = event, 0 = censored)} \item{trt}{binary treatment
#'   indicator}}
#' @source See \code{simsurv} vignette:
#'   \url{https://cran.r-project.org/package=simsurv/vignettes/simsurv_usage.html}
#'
#' @examples
#' if (requireNamespace("splines", quietly = TRUE)) {
#' library(splines)
#' data("simdat")
#' mod_cb <- casebase::fitSmoothHazard(status ~ trt + ns(log(eventtime),
#'                                                       df = 3) +
#'                                    trt:ns(log(eventtime),df=1),
#'                                    time = "eventtime",
#'                                    data = simdat,
#'                                    ratio = 1)
#' }
#' @references Sam Brilleman (2019). simsurv: Simulate Survival Data. R package
#'   version 0.2.3. https://CRAN.R-project.org/package=simsurv
"simdat"

#' Study to Understand Prognoses Preferences Outcomes and Risks of Treatment
#' (SUPPORT)
#'
#' @description The SUPPORT dataset tracks four response variables: hospital
#'   death, severe functional disability, hospital costs, and time until death
#'   and death itself. The patients are followed for up to 5.56 years. Data
#'   included only tracks follow-up time and death.
#'
#' @details Some of the original data was missing. Before imputation, there were
#'   a total of 9105 individuals and 47 variables. Of those variables, a few
#'   were removed before imputation. We removed three response variables:
#'   hospital charges, patient ratio of costs to charge,s and patient
#'   micro-costs. Next, we removed hospital death as it was directly informative
#'   of our event of interest, namely death. We also removed functional
#'   disability and income as they are ordinal covariates. Finally, we removed 8
#'   covariates related to the results of previous findings: we removed SUPPORT
#'   day 3 physiology score (\code{sps}), APACHE III day 3 physiology score
#'   (\code{aps}), SUPPORT model 2-month survival estimate, SUPPORT model
#'   6-month survival estimate, Physician's 2-month survival estimate for pt.,
#'   Physician's 6-month survival estimate for pt., Patient had Do Not
#'   Resuscitate (DNR) order, and Day of DNR order (<0 if before study). Of
#'   these, \code{sps} and \code{aps} were added on after imputation, as they
#'   were missing only 1 observation. First we imputed manually using the normal
#'   values for physiological measures recommended by Knaus et al. (1995). Next,
#'   we imputed a single dataset using \pkg{mice} with default settings. After
#'   imputation, we noted that the covariate for surrogate activities of daily
#'   living was not imputed. This is due to collinearity between the other two
#'   covariates for activities of daily living. Therefore, surrogate activities
#'   of daily living was removed.
#'
#' @format A dataframe with 9104 observations and 34 variables after imputation
#'   and the removal of response variables like hospital charges, patient ratio
#'   of costs to charges and micro-costs. Ordinal variables, namely functional
#'   disability and income, were also removed. Finally, Surrogate activities of
#'   daily living were removed due to sparsity. There were 6 other model scores
#'   in the data-set and they were removed; only aps and sps were kept.
#'   \describe{ \item{Age}{ Stores a double representing age. } \item{death}{
#'   Death at any time up to NDI date: 31DEC94. } \item{sex}{ 0=female, 1=male.
#'   } \item{slos}{ Days from study entry to discharge. } \item{d.time}{ days of
#'   follow-up. } \item{dzgroup}{ Each level of dzgroup: ARF/MOSF w/Sepsis,
#'   COPD, CHF, Cirrhosis, Coma, Colon Cancer, Lung Cancer, MOSF with
#'   malignancy. } \item{dzclass}{ ARF/MOSF, COPD/CHF/Cirrhosis, Coma and cancer
#'   disease classes. } \item{num.co}{ the number of comorbidities. }
#'   \item{edu}{ years of education of patient. } \item{scoma}{ The SUPPORT coma
#'   score based on Glasgow D3. } \item{avtisst}{ Average TISS, days 3-25. }
#'   \item{race}{ Indicates race. White, Black, Asian, Hispanic or other. }
#'   \item{hday}{Day in Hospital at Study Admit} \item{diabetes}{Diabetes (Com
#'   27-28, Dx 73)} \item{dementia}{Dementia (Comorbidity 6) } \item{ca}{Cancer
#'   State} \item{meanbp}{ Mean Arterial Blood Pressure Day 3. } \item{wblc}{
#'   White blood cell count on day 3. } \item{hrt}{ Heart rate day 3. }
#'   \item{resp}{ Respiration Rate day 3. } \item{temp}{ Temperature, in
#'   Celsius, on day 3. } \item{pafi}{ PaO2/(0.01*FiO2) Day 3. } \item{alb}{
#'   Serum albumin day 3. } \item{bili}{ Bilirubin Day 3. } \item{crea}{ Serum
#'   creatinine day 3. } \item{sod}{ Serum sodium day 3. } \item{ph}{ Serum pH
#'   (in arteries) day 3. } \item{glucose}{ Serum glucose day 3. } \item{bun}{
#'   BUN day 3. } \item{urine}{ urine output day 3. } \item{adlp}{ ADL patient
#'   day 3. }  \item{adlsc}{ Imputed ADL calibrated to surrogate, if a surrogate
#'   was used for a follow up.} \item{sps}{SUPPORT physiology score}
#'   \item{aps}{Apache III physiology score} }
#' @source Available at the following website:
#'   \url{https://biostat.app.vumc.org/wiki/Main/SupportDesc}.
#'    note: must unzip and process this data before use.
#' @examples
#' data("support")
#' # Using the matrix interface and log of time
#' x <- model.matrix(death ~ . - d.time - 1, data = support)
#' y <- with(support, cbind(death, d.time))
#'
#' fit_cb <- casebase::fitSmoothHazard.fit(x, y, time = "d.time",
#'                                         event = "death",
#'                                         formula_time = ~ log(d.time),
#'                                         ratio = 1)
#' @references Knaus WA, Harrell FE, Lynn J et al. (1995): The SUPPORT
#'   prognostic model: Objective estimates of survival for seriously ill
#'   hospitalized adults. Annals of Internal Medicine 122:191-203.
#'   \doi{10.7326/0003-4819-122-3-199502010-00007}.
#' @references http://biostat.mc.vanderbilt.edu/wiki/Main/SupportDesc
#' @references
#' http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/Csupport.html
"support"

#' Estrogen plus Progestin and the Risk of Coronary Heart Disease (eprchd)
#'
#' @description This data was reconstructed from the curves in figure 2
#'  (Manson 2003).Compares placebo to hormone treatment.
#' @examples
#' data("eprchd")
#' fit <- fitSmoothHazard(status ~ time + treatment, data = eprchd)
#' @format A dataframe with 16608 observations and 3 variables:
#'   \describe{ \item{time}{ Years (continuous) } \item{status}{
#'   0=censored, 1=event } \item{treatment}{ placebo,
#'   estPro}}
#' @references Manson, J. E., Hsia, J., Johnson, K. C., Rossouw, J. E., Assaf,
#'  A. R., Lasser, N. L., ... & Strickland, O. L. (2003). Estrogen plus
#'  progestin and the risk of coronary heart disease. New England Journal of
#'  Medicine, 349(6), 523-534.
"eprchd"

#' German Breast Cancer Study Group 2
#'
#' @description  A data frame containing the observations from the  GBSG2 study.
#'   This is taken almost verbatim from the `TH.data` package.
#' @format This data frame contains the observations of 686 women: \describe{
#'   \item{horTh}{hormonal therapy, a factor at two levels \code{no} and
#'   \code{yes}.} \item{hormon}{numeric version of `horTh`} \item{age}{of the
#'   patients in years.} \item{menostat}{menopausal status, a factor at two
#'   levels \code{pre} (premenopausal) and \code{post} (postmenopausal).}
#'   \item{meno}{Numeric version of `menostat`} \item{tsize}{tumor size (in
#'   mm).} \item{tgrade}{tumor grade, a ordered factor at levels \code{I < II <
#'   III}.} \item{pnodes}{number of positive nodes.} \item{progrec}{progesterone
#'   receptor (in fmol).} \item{estrec}{estrogen receptor (in fmol).}
#'   \item{time}{recurrence free survival time (in days).} \item{cens}{censoring
#'   indicator (0- censored, 1- event).} }
#' @source Torsten Hothorn (2019). TH.data: TH's Data Archive. R package version
#'   1.0-10. https://CRAN.R-project.org/package=TH.data
#' @references M. Schumacher, G. Basert, H. Bojar,  K. Huebner, M. Olschewski,
#'   W. Sauerbrei, C. Schmoor, C. Beyerle, R.L.A. Neumann and H.F. Rauschecker
#'   for the German Breast Cancer Study Group (1994), Randomized \eqn{2\times2}
#'   trial evaluating hormonal treatment and the duration of chemotherapy in
#'   node-positive breast cancer patients. \emph{Journal of Clinical Oncology},
#'   \bold{12}, 2086--2093.
"brcancer"
