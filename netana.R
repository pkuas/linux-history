ibrary('igraph', lib='/home/pkuas/R/x86_64-redhat-linux-gnu-library/3.1/')
library('lsa')
mkEdgesFrmTb <- function(tb) {
    idx <-which(tb > 0)
    numrow <- nrow(tb)
    rnames <- rownames(tb)
    cnames <- colnames(tb)
    return(mkEdges(rnames[(idx - 1) %% numrow + 1], cnames[(idx - 1) %/% numrow + 1]))
}
tsel <- delta$mod == 'drivers' & delta$y >= 2015
ttb <- table(delta$f[tsel], delta$aid[tsel])
tcos <- cosine(ttb)
ttcos <-  tcos
#ttcos[tcos < 0.1] <- 0
dn <- graph_from_adjacency_matrix(ttcos, mode='undirected', weighted='w', diag=F)#, add.colnames=NA,add.rownames=NA)
E(dn)$tp <- 0 # is cos
V(dn)$isa <- TRUE # author
numChgs <- table(delta$aid[tsel])
V(dn)[names(numChgs)]$numChgs <- numChgs
tcmtr <- unique(delta$cid[tsel])
tcmtrToAdd <- tcmtr[!tcmtr %in% V(dn)$name]
dn <- add.vertices(dn, length(tcmtrToAdd), attr=list(name=tcmtrToAdd))
V(dn)[tcmtrToAdd]$numChgs <- 0
V(dn)$isc <- FALSE
V(dn)[tcmtrToAdd]$isa <- FALSE
V(dn)[tcmtr]$isc <- TRUE
ttb <- prop.table(table(delta$aid[tsel], delta$cid[tsel]), margin=1)
dn <- add.edges(dn, mkEdgesFrmTb(ttb), attr=list(w=ttb[which(ttb>0)], tp=1)) # tp:1, cmt
