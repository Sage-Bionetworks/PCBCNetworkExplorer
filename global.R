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

# source("tf_mirna.R")
# source("tf_methyl.R")
# source("nontf_mirna.R")
# 
# diffStates <- unique(c(diffStates.tf_mirna, 
#                        diffStates.tf_methyl,
#                        diffStates.nontf_mirna))
# 
# nodeData <- rbind(nodeData.tf_mirna, 
#                   nodeData.tf_methyl,
#                   nodeData.nontf_mirna)
# 
# edgeData <- rbind(edgeData.tf_mirna, 
#                   edgeData.tf_methyl,
#                   edgeData.nontf_mirna)
# 
# network <- edgeData
