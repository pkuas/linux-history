# init
delta$ae<-as.character(delta$ae)
delta$an<-as.character(delta$an)
delta$ce<-as.character(delta$ce)
delta$cn<-as.character(delta$cn)
numdeltas<-dim(delta)[1]

# dir setting
## one sei win 10
setwd("D:/M8400t-N000/linuxhistory/")
load("./.RData")
picdir <- "../SyncDirectory/research/linux/pics/"
## on pae
picdir <- "./"

# commen
numOfUnique<-function(x) {return(length(unique(x)))}
month <- sort(unique(delta$m))
minmonth <- min(month)
maxmonth <- max(month)
nummonth <- length(month)
mod.month.tb <- table(delta$mod,delta$m);

# plot number of deltas in each mod each month
sel.mod <- names(sort(-table(delta$mod))[1:7]);
xaxis <- as.numeric(names(mod.month.tb[1,]))
png(paste(picdir,"deltas-in-mod.png",sep="") , width=800,height=600);
plot(xaxis, mod.month.tb[sel.mod[1],], type='l', col=1, main="Number of deltas on each module each month", xlab = "natural month", ylab = "# of deltas")
for(i in 2:7){lines(xaxis, mod.month.tb[sel.mod[i],],col=i,lty=1)}
legend(2006,7500,legend=sel.mod,cex=1,lwd=2,col=rep(1:7),bg="white");
dev.off();

# count author/committer's domain name (company)
delta$acompany <- sub(".*@(.*)", "\\1", as.character(delta$ae),perl=TRUE)
acompany.tb <- sort(table(delta$acompany), decreasing = T)
mod.acompany.tb<- table(delta$mod, delta$acompany)
delta$ccompany <- sub(".*@(.*)", "\\1", as.character(delta$ce), perl=T)
ccompany.tb <- sort(table(delta$ccompany), decreasing = T)

# how author2committer varied in each sub module of drivers
drivers.delta.sel<-delta$mod == 'drivers'
mod.in.drivers <- sort(unique(delta$mmod[drivers.delta.sel]))
mod.in.drivers.tb<-sort(table(delta$mmod[drivers.delta.sel]), decreasing=T)
row.delta.sel<-c("mmod", "aid", "cid")
authorcnt.in.mod.in.drivers.3year <- as.data.frame(
	matrix(0, nrow=nummonth-36, ncol=length(mod.in.drivers),
		dimnames=list(month=round(month[1:(nummonth-36)], 3), mod=mod.in.drivers)))
cmtrcnt.in.mod.in.drivers.3year <- authorcnt.in.mod.in.drivers.3year
a2cInModInDrivers3year<-authorcnt.in.mod.in.drivers.3year
st<-minmonth
ed<-st+3
while (ed < 2015.91){
	tmpdelta<-delta[drivers.delta.sel & delta$m >= st & delta$m < ed, row.delta.sel]
	tres<-tapply(tmpdelta$aid, tmpdelta$mmod, numOfUnique)
	rowIndex<-as.character(round(st, 3))
	authorcnt.in.mod.in.drivers.3year[rowIndex, names(tres)]<-tres
	tres<-tapply(tmpdelta$cid, tmpdelta$mmod, numOfUnique)
	cmtrcnt.in.mod.in.drivers.3year[rowIndex, names(tres)]<-tres
	a2cInModInDrivers3year[rowIndex,]<-authorcnt.in.mod.in.drivers.3year[rowIndex,]/cmtrcnt.in.mod.in.drivers.3year[rowIndex,]
	st<-st+1/12
	ed<-st+3
}
mod.to.show<-names(mod.in.drivers.tb)[1:7]
png(paste(picdir, "a2c-in-mod-in-drivers.png", sep=""), width=800,height=600)
xaxis<-month[1:(nummonth-36)]
plot(xaxis, a2cInModInDrivers3year[,mod.to.show[1]],
	type='l', col=1, main="Ratio of authors to committers (in 3-year period) on each drivers/* over time", xlab = "natural month", ylab = "ratio", ylim=c(0, 27))
for(i in 2:7){lines(xaxis, a2cInModInDrivers3year[,mod.to.show[i]],col=i,lty=1)}
legend(2009,28,legend=mod.to.show,cex=1,lwd=2,col=rep(1:7),bg="white");
dev.off();

# how author2committer varied in each module
mods<-sort(unique(delta$mod))
mods.tb<-sort(table(delta$mod), decreasing=T)
row.delta.sel<-c('mod', 'aid', 'cid')
authorcnt.in.mods.3year <- as.data.frame(
	matrix(0, nrow=nummonth-36, ncol=length(mods),
		dimnames=list(month=round(month[1:(nummonth-36)], 3), mod=mods)))
cmtrcnt.in.mods.3year <- authorcnt.in.mods.3year
a2cInMods3year<-authorcnt.in.mods.3year
st<-minmonth
ed<-st+3
while (ed < 2015.91){
	tmpdelta<-delta[delta$m >= st & delta$m < ed, row.delta.sel]
	tres<-tapply(tmpdelta$aid, tmpdelta$mod, numOfUnique)
	rowIndex<-as.character(round(st, 3))
	authorcnt.in.mods.3year[rowIndex, names(tres)]<-tres
	tres<-tapply(tmpdelta$cid, tmpdelta$mod, numOfUnique)
	cmtrcnt.in.mods.3year[rowIndex, names(tres)]<-tres
	a2cInMods3year[rowIndex,]<-authorcnt.in.mods.3year[rowIndex,]/cmtrcnt.in.mods.3year[rowIndex,]
	st<-st+1/12
	ed<-st+3
}
mod.to.show<-names(mods.tb)[1:7]
png(paste(picdir, "a2c-in-mods.png", sep=""), width=800,height=600)
xaxis<-month[1:(nummonth-36)]
plot(xaxis, a2cInMods3year[,mod.to.show[1]],
	type='l', col=1, main="Ratio of authors to committers (in 3-year period) on each module over time", xlab = "natural month", ylab = "ratio", ylim=c(0, 27))
for(i in 2:7){lines(xaxis, a2cInMods3year[,mod.to.show[i]],col=i,lty=1)}
legend(2009,28,legend=mod.to.show,cex=1,lwd=2,col=rep(1:7),bg="white");
dev.off();

# how drivers's a2c ratio varied over time. in 3-year window
authorcnt.in.drivers.3year <- c()
cmtrcnt.in.drivers.3year<-c()
st<-minmonth
ed<-st+3
row.delta.sel<-c("mmod", "aid", "cid")
while (ed < 2015.91){
	tmpdelta<-delta[drivers.delta.sel & delta$m >= st & delta$m < ed, row.delta.sel]
	rowIndex<-as.character(round(st, 3))
	authorcnt.in.drivers.3year[rowIndex]<-numOfUnique(tmpdelta$aid)
	cmtrcnt.in.drivers.3year[rowIndex]<-numOfUnique(tmpdelta$cid)
	st<-st+1/12
	ed<-st+3
}
a2cInDrivers3year<-authorcnt.in.drivers.3year/cmtrcnt.in.drivers.3year

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
deltacnt.in.mod.in.drivers.3year <- tapply(delta$m[drivers.delta.sel], delta$mmod[drivers.delta.sel], cnt.1mod.3year)
mod.to.show<-names(mod.in.drivers.tb)[1:7]
#png(paste(picdir,"deltas-in-mod.png",sep="") , width=800,height=600);
plot(month, unlist(deltacnt.in.mod.in.drivers.3year[mod.to.show[1]]),
	type='l', col=1, main="Number of deltas on each drivers/* each month", xlab = "natural month", ylab = "# of deltas")
for(i in 2:7){lines(month, unlist(deltacnt.in.mod.in.drivers.3year[mod.to.show[i]]),col=i,lty=1)}
legend(2006,65000,legend=mod.to.show,cex=1,lwd=2,col=rep(1:7),bg="white");
#dev.off();
