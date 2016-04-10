mozpath <- '/store1/code/mozilla20160401/log/mozilla-central'
mozpath <- '/store1/chenqy/linuxhistory/mozilla-central'
datapath <- mozpath
# 291125:fceee99ec164;

# tails of some cmts are dropped if the cmt had ';'
moz <- read.table(mozpath, sep=";",quote='\"',
    col.names=c("v","t","an","ae","cmt"), fill=T,
    colClasses=c(rep("character", 5)));

t <- strsplit(moz$t, '.', fixed=T)
#for(i in 1:length(t)) { if(is.na((as.integer(t[[i]][1])))) print(i)}
moz$t <- unlist(lapply(t, function(x) return(as.integer(x[1]))))
moz$tz <- unlist(lapply(t, function(x) return(as.integer(substring(x[2], 2)))))

delta <- moz
