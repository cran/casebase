% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{brcancer}
\alias{brcancer}
\title{German Breast Cancer Study Group 2}
\format{
This data frame contains the observations of 686 women: \describe{
\item{horTh}{hormonal therapy, a factor at two levels \code{no} and
\code{yes}.} \item{hormon}{numeric version of \code{horTh}} \item{age}{of the
patients in years.} \item{menostat}{menopausal status, a factor at two
levels \code{pre} (premenopausal) and \code{post} (postmenopausal).}
\item{meno}{Numeric version of \code{menostat}} \item{tsize}{tumor size (in
mm).} \item{tgrade}{tumor grade, a ordered factor at levels \code{I < II <
  III}.} \item{pnodes}{number of positive nodes.} \item{progrec}{progesterone
receptor (in fmol).} \item{estrec}{estrogen receptor (in fmol).}
\item{time}{recurrence free survival time (in days).} \item{cens}{censoring
indicator (0- censored, 1- event).} }
}
\source{
Torsten Hothorn (2019). TH.data: TH's Data Archive. R package version
1.0-10. https://CRAN.R-project.org/package=TH.data
}
\usage{
brcancer
}
\description{
A data frame containing the observations from the  GBSG2 study.
This is taken almost verbatim from the \code{TH.data} package.
}
\references{
M. Schumacher, G. Basert, H. Bojar,  K. Huebner, M. Olschewski,
W. Sauerbrei, C. Schmoor, C. Beyerle, R.L.A. Neumann and H.F. Rauschecker
for the German Breast Cancer Study Group (1994), Randomized \eqn{2\times2}
trial evaluating hormonal treatment and the duration of chemotherapy in
node-positive breast cancer patients. \emph{Journal of Clinical Oncology},
\bold{12}, 2086--2093.
}
\keyword{datasets}
