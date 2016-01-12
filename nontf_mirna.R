obj.nontf_mirna <- synGet("syn5583716")
d.nontf_mirna <- fread(getFileLocation(obj.nontf_mirna), data.table=FALSE) %>% 
  mutate(mirna=str_replace(mirna, "hsa-miR-", ""))

diffStates.nontf_mirna <- d.nontf_mirna %>% select(Comparison) %>% 
  mutate(Comparison=str_replace(Comparison, "_vs_", "_")) %>% 
  tidyr::separate(Comparison, c("first", "second")) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames") %>% 
  select(value) %>% 
  distinct()

diffStates.nontf_mirna <- diffStates.nontf_mirna$value

nodeData.nontf_mirna <- d.nontf_mirna %>%
  select(mrna, mirna) %>% 
  name_rows() %>% 
  melt(id.vars=".rownames", variable.name="group", value.name="name") %>% 
  select(name, group) %>% 
  distinct() %>% 
  mutate(id=name, group=as.character(group))

nodeData.nontf_mirna$group[nodeData.nontf_mirna$group == "mrna"] <- "nontf_mrna"

nodeData.nontf_mirna <- nodeData.nontf_mirna %>% 
  left_join(nodeProperties)

edgeData.nontf_mirna <- d.nontf_mirna %>% 
  select(mrna, mirna, Comparison, changeFishersZ, fdr) %>%
  rename(source=mirna, target=mrna) %>% 
  mutate(group="nontf_mirna")

network.nontf_mirna <- edgeData.nontf_mirna
