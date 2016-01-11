setwd("D:/M8400t-N000/linuxhistory/")
load("./.RData")
picdir <- "../SyncDirectory/research/linux/pics/"
mod.month <- table(delta$mod,delta$m);

sel.mod <- names(sort(-table(delta$mod))[1:7]);
x.axis <- as.numeric(names(mod.month[1,]))

png(paste(picdir,"deltas-in-mod.png",sep="") , width=800,height=600);
plot(x.axis, mod.month[sel.mod[1],], type='l', col=1, main="Number of deltas on each module each month", xlab = "natural month", ylab = "# of deltas")
for(i in 2:7){lines(x.axis, mod.month[sel.mod[i],],col=i,lty=1)}
legend(2006,7500,legend=sel.mod,cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();

###########
x$acompany <- sub(".*@(.*)", "\\1", as.character(x$ae),perl=TRUE)
delta$acompany <- sub(".*@(.*)", "\\1", as.character(delta$ae),perl=TRUE)
aemail.tb <- sort(table(delta$acompany), decreasing = T)
mod.company<- table(delta$mod, delta$acompany)
delta$ccompany <- sub(".*@(.*)", "\\1", as.character(delta$ce), perl=T)
cemail.tb <- sort(table(delta$ccompany), decreasing = T)

# how author2committer varied in each sub module of drivers 
drivers.sel.delta<-delta$mod == 'drivers'
month <- sort(unique(delta$m))
minmonth <- min(month)
maxmonth <- max(month)
nummonth <- length(month)
mod.in.drivers <- unique(delta$mmod[drivers.sel.delta])
mod.in.drivers.tb<-sort(table(delta$mmod[drivers.sel.delta]), decreasing=T)
cnt.1mod.3year<-function(x) {
	cnt<-rep(0, nummonth);
	for ( i in x){
		imth<- (i - minmonth) * 12 + 1
		st <-max(1, imth - 36)
		ed <- min(nummonth, imth + 36)
		cnt[st:ed] <- cnt[st:ed] + 1
	}
	return(cnt)
}

#deltacnt.in.mod.in.drivers.3year <- as.data.frame(
#	matrix(0, nrow=length(mod.in.drivers), ncol=length(month), 
#		dimnames=list(mod=mod.in.drivers, month=round(month, 3))))
deltacnt.in.mod.in.drivers.3year <-data.frame(mod.in.drivers)
deltacnt.in.mod.in.drivers.3year$numdelta <- tapply(delta$m[drivers.sel.delta], delta$mmod[drivers.sel.delta], cnt.1mod.3year)
rownames(deltacnt.in.mod.in.drivers.3year) <- names(deltacnt.in.mod.in.drivers.3year$numdelta)
mod.to.show<-names(mod.in.drivers.tb)[1:7]
