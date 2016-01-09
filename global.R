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
d2 <- d %>% filter(str_detect(Comparison, "DE"))

nodeProperties <- data.frame(group=c("mrna", "mirna"),
                             color=c("#888888", "#FF0000"),
                             shape=c("ellipse", "octagon"))

nodeData <- d2 %>%
  select(mrna, mirna) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames", variable.name="group", value.name="name") %>% 
  select(name, group) %>% 
  distinct() %>% 
  mutate(id=name) %>% 
  left_join(nodeProperties)

edgeData <- d2 %>% 
  select(mrna, mirna) %>%
  rename(source=mirna, target=mrna)

id <- nodeData$name
name <- nodeData$name

network <- edgeData

# network <- createCytoscapeJsNetwork(d.nodes, d.edges)
# rcytoscapejs(network$nodes, network$edges)


