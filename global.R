library(synapseClient)
synapseLogin()

library(data.table)
library(plyr)
library(dplyr)
library(reshape2)
library(stringr)
library(tidyr)

obj <- synGet("syn5579744")
d <- fread(getFileLocation(obj), data.table=FALSE)

diffStates <- d %>% select(Comparison) %>% 
  mutate(Comparison=str_replace(Comparison, "_vs_", "_")) %>% 
  tidyr::separate(Comparison, c("first", "second")) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames") %>% 
  select(value) %>% 
  distinct()
diffStates <- diffStates$value

d2 <- d

nodeProperties <- data.frame(group=c("mrna", "mirna"),
                             color=c("#888888", "#FF0000"),
                             shape=c("ellipse", "square"))

nodeData <- d2 %>%
  select(mrna, mirna) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames", variable.name="group", value.name="name") %>% 
  select(name, group) %>% 
  distinct() %>% 
  mutate(id=name) %>% 
  left_join(nodeProperties)

edgeData <- d2 %>% 
  select(mrna, mirna, Comparison, changeFishersZ, fdr) %>%
  rename(source=mirna, target=mrna)

network <- edgeData

# network <- createCytoscapeJsNetwork(d.nodes, d.edges)
# rcytoscapejs(network$nodes, network$edges)


