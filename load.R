# synapseClient::synapseLogin()

assayShapes <- data.frame(assay=c('TF', 'mirna', 'methyl'),
                          shape=c('circle', 'box', 'triangle'))

obj.network <- synGet("syn7346460")
active.int <- fread(getFileLocation(obj.network), data.table=F)

obj.regulators <- synGet("syn7357665")
# Loads into key.regulators.w list
load(getFileLocation(obj.regulators))

obj.signatures <- synGet("syn7187534")
gx.signatures <- fread(getFileLocation(obj.signatures), data.table=F)

rownameToFirstColumn <- function(DF,colname){
  DF <- as.data.frame(DF)
  DF[,colname] <- row.names(DF)
  DF <- DF[,c(dim(DF)[2],1:(dim(DF)[2]-1))]
  return(DF)
}

all.networks = lapply(names(key.regulators.w), function(x, Signatures, keyRegulators, activeInt){
  edge = activeInt %>%
    filter(from.state == 'SC', to.state == x) %>%
    dplyr::select(feature, target, Assay, coexpression, dataSource)
  vertex = rbindlist(list( activeInt %>%
                             filter(from.state == 'SC', to.state == x) %>%
                             dplyr::select(feature, feature.assay, feature.lfc, feature.beta, feature.fdr) %>%
                             dplyr::rename(assay = feature.assay, lfc = feature.lfc, beta = feature.beta, fdr = feature.fdr),
                           activeInt %>%
                             filter(from.state == 'SC', to.state == x) %>%
                             dplyr::select(target, target.assay, target.lfc, target.beta, target.fdr) %>%
                             dplyr::rename(feature = target, assay = target.assay,
                                           lfc = target.lfc, beta = target.beta, fdr = target.fdr)),
                     use.names = T, fill = T) %>%
    as.data.frame %>%
    unique %>%
    left_join(keyRegulators[[x]]$score %>%
                rownameToFirstColumn('feature') %>%
                dplyr::rename(enrich.score = DF)) %>%
    left_join(keyRegulators[[x]]$fdr %>%
                rownameToFirstColumn('feature') %>%
                dplyr::rename(enrich.fdr = DF))

  vertex$global.reg[vertex$feature %in% keyRegulators[[x]]$global.regulators] = 1
  vertex$local.reg[vertex$feature %in% keyRegulators[[x]]$local.regulators] = 1

  Signatures = filter(Signatures, from.state == 'SC' || from.state == x)
  vertex$signature[vertex$feature %in% Signatures$feature] = 1

  return(list(edge = edge, node = vertex))
}, gx.signatures, key.regulators.w, active.int)
names(all.networks) = names(key.regulators.w)



