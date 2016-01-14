source("tf_mirna.R")
source("tf_methyl.R")
source("nontf_mirna.R")

diffStates <- unique(c(diffStates.tf_mirna, 
                       diffStates.tf_methyl,
                       diffStates.nontf_mirna))

nodeData <- rbind(nodeData.tf_mirna, 
                  nodeData.tf_methyl,
                  nodeData.nontf_mirna)

edgeData <- rbind(edgeData.tf_mirna, 
                  edgeData.tf_methyl,
                  edgeData.nontf_mirna)

network <- edgeData
