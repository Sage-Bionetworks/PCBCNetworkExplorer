obj.tf_mirna <- synGet("syn5579744")

d.tf_mirna <- fread(getFileLocation(obj.tf_mirna), data.table=FALSE) %>% 
  mutate(mirna=str_replace(mirna, "hsa-miR-", ""))

diffStates.tf_mirna <- d.tf_mirna %>% select(Comparison) %>% 
  mutate(Comparison=str_replace(Comparison, "_vs_", "_")) %>% 
  tidyr::separate(Comparison, c("first", "second")) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames") %>% 
  select(value) %>% 
  distinct()

diffStates.tf_mirna <- diffStates.tf_mirna$value

nodeData.tf_mirna <- d.tf_mirna %>%
  select(mrna, mirna) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames", variable.name="group", value.name="name") %>% 
  select(name, group) %>% 
  distinct() %>% 
  mutate(id=name) %>% 
  left_join(nodeProperties)

edgeData.tf_mirna <- d.tf_mirna %>% 
  select(mrna, mirna, Comparison, changeFishersZ, fdr) %>%
  rename(source=mirna, target=mrna) %>% 
  mutate(group="tf_mirna")

network.tf_mirna <- edgeData.tf_mirna
