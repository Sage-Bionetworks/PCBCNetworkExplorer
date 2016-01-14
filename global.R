library(data.table)
library(plyr)
library(dplyr)
library(reshape2)
library(stringr)
library(tidyr)

nodeProperties <- data.frame(group=c("mrna", "nontf_mrna", 
                                     "mirna", "methyl"),
                             color=c("#888888", "#008800", "#880000", "#000088"),
                             shape=c("ellipse", "ellipse", "square", "square"))
