---
title: "new Mrakdown trial"
author: "Tulsi Ram Gompo"
date: "12/9/2016"
output: html_document
---




```r
getwd()
```

```
## [1] "/Users/Tulsigompo/Desktop/course_project_debate/New_R_mark_down"
```

```r
source("style.R")
source("r_profile.R")
custom_css(TRUE)
```

```
## Error in eval(expr, envir, enclos): could not find function "custom_css"
```

```r
custom_css(rprofile=FALSE,loc=file.path(getwd(),"New_R_mark_down"),style=NULL, source= TRUE)
```

```
## Error in eval(expr, envir, enclos): could not find function "custom_css"
```








![plot of chunk pressure](figure/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
