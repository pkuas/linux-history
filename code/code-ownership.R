# t3apply <- function(v, g3, g2, g1, f) {tapply(1:length(g1), g1, function(x) {
# 	return(t2apply(v[x], g3[x], g2[x], f))
# 	})}
# #athrs per file
athrownership <- list()
mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
tsel <- delta$mod %in% mods; 
for (i in 1:length(mods)) {
	sel <- tsel & delta$mod == mods[i]
	athrownership[[mods[i]]] <- unlist(lapply(
		t2apply(delta$aid[sel], delta$f[sel], delta$m[sel], numOfUnique), 
		mean))
}
pdf('./athrcodeowner.pdf', width=10,height=6, onefile=FALSE, paper = "special")
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0.8, 4),
    main='Average # of authors per file per month',
    xlab='Natural month', ylab='# of authors')
col <- 1:length(mods)
for (i in 1:length(col)) {
	x <- athrownership[[mods[i]]]
    lines(as.numeric(names(x)), x, col=col[i], type='b', lty=1, lwd=1, cex=0.6)
}
legend(2014, 4, legend=mods,cex=1,lwd=2, lty=1,
    col=col ,bg="white");
dev.off()

cmtrownership <- list()
mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
tsel <- delta$mod %in% mods; 
for (i in 1:length(mods)) {
	sel <- tsel & delta$mod == mods[i]
	cmtrownership[[mods[i]]] <- unlist(lapply(
		t2apply(delta$cid[sel], delta$f[sel], delta$y[sel], numOfUnique), 
		mean))
}
pdf('./cmtrcodeowner.pdf', width=10,height=6, onefile=FALSE, paper = "special")
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0.9, 1.7),
    main='Average # of committers per file per month',
    xlab='Natural month', ylab='# of committers')
col <- 1:length(mods)
for (i in (1:length(col))) {
	x <- cmtrownership[[mods[i]]]
    lines(as.numeric(names(x)), x, col=col[i], type='b', lty=1, lwd=1, cex=0.6)
}
legend(2014, 1.7, legend=mods,cex=1,lwd=2, lty=1,
    col=col ,bg="white");
dev.off()
