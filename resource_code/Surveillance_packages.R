library(surveillance)
install.packages("surveillance")
data("salmNewport")
Sys.Date()
load("/Users/Tulsigompo/Downloads/salmNewport.RData")
salmo_out<-read.table("/Users/Tulsigompo/Downloads/salmNewport.RData",header = FALSE)
salmo_out
data.frame(salmo_out)
load("/Users/Tulsigompo/Downloads/abattoir.RData")
ab_data<-read.csv("/Users/Tulsigompo/Downloads/abattoir.RData")
data("salmNewport")
today <- which(epoch(salmNewport) == as.Date("2013-12-23"))
rangeAnalysis <- (today - 4):today
in2013 <- which(isoWeekYear(epoch(salmNewport))$ISOYear == 2013)
algoParameters <- list(range = rangeAnalysis, noPeriods = 10,
                        populationBool = FALSE, b = 4, w = 3, weightsThreshold = 2.58,
                        pastWeeksNotIncluded = 26, pThresholdTrend = 1,
                        thresholdMethod = "nbPlugin", alpha = 0.05, limit54 = c(0, 50))
results <- farringtonFlexible(
   salmNewport[, c("Baden.Wuerttemberg", "North.Rhine.Westphalia")],
   control = algoParameters)
start <- isoWeekYear(epoch(salmNewport)[range(range)[1]])
end <- isoWeekYear(epoch(salmNewport)[range(range)[2]])
 caption <- paste("Results of the analysis of reported S. Newport
                  counts in two German federal states for the weeks W-")
