obj.tf_methyl <- synGet("syn5579746")
d.tf_methyl <- fread(getFileLocation(obj.tf_methyl), data.table=FALSE)

diffStates.tf_methyl <- d.tf_methyl %>% select(Comparison) %>% 
  mutate(Comparison=str_replace(Comparison, "_vs_", "_")) %>% 
  tidyr::separate(Comparison, c("first", "second")) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames") %>% 
  select(value) %>% 
  distinct()

diffStates.tf_methyl <- diffStates.tf_methyl$value

nodeData.tf_methyl <- d.tf_methyl %>%
  select(mrna, methyl) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames", variable.name="group", value.name="name") %>% 
  select(name, group) %>% 
  distinct() %>% 
  mutate(id=name) %>% 
  left_join(nodeProperties)

edgeData.tf_methyl <- d.tf_methyl %>% 
  select(mrna, methyl, Comparison, changeFishersZ, fdr) %>%
  rename(source=methyl, target=mrna) %>% 
  mutate(group="tf_methyl")

network.tf_methyl <- edgeData.tf_methyl
