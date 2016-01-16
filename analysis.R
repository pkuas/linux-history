# commen
numofdeltas <- nrow(delta)
month <- sort(unique(delta$m))
minmonth <- min(month)
maxmonth <- max(month)
nummonth <- length(month)

# overall ana

## how LOC varys
adds.month.arr <- tapply(delta$add, delta$m, sum)
dels.month.arr <- tapply(delta$del, delta$m, sum)
png("loc-month.png", width=800,height=600);
plot(as.numeric(names(adds.month.arr)), adds.month.arr, ylim=c(1,1e6),main = "Lines of code each month",type="l",xlab="Tenure (months)",ylab="# each month");
lines(as.numeric(names(dels.month.arr)),dels.month.arr, col=2);
legend(2005, 1e6,legend=c("Lines of added code","Lines of deleted code"),cex=1,lwd=2,col=rep(1:2),bg="white"); 
dev.off();

## how num of changes, files/modules touched varys
chgs.month.arr <- tapply(delta$aid, delta$m, length)
tt <- max(chgs.month.arr)
files.month.arr <- tapply(delta$f, delta$m, numOfUnique)
mods.month.arr <- tapply(delta$mod, delta$m, numOfUnique)
png("changes.files.mods-month.png", width=800,height=600);
plot(as.numeric(names(chgs.month.arr)), chgs.month.arr, ylim=c(1,tt+10),main = "# of changes, files and modules touched each month",type="l",xlab="Tenure (months)",ylab="# each month", col=1);
lines(as.numeric(names(files.month.arr)),files.month.arr, col=2);
lines(as.numeric(names(mods.month.arr)),mods.month.arr * 100, col=3);
legend(2010, tt,legend=c("# of changes","# of files touched", "# of modules touched * 100"),cex=1,lwd=2,col=rep(1:3),bg="white"); 
dev.off()

## how num of authors/committers/joiners/LTCs/core-committers varys
authors.month.arr <- tapply(delta$aid, delta$m, numOfUnique) # authors
tt <- max(authors.month.arr)
cmtrs.month.arr <- tapply(delta$cid, delta$m, numOfUnique) # committers
tsel <- delta$tenure==0
joiners.month.arr <- tapply(delta$aid[tsel], delta$m[tsel], numOfUnique) # joiners
tsel <- tsel & delta$contr3y
tsel[is.na(tsel)] <- FALSE
ltcs.month.arr <- tapply(delta$aid[tsel], delta$m[tsel], numOfUnique) # LTC
ltcratio.month.arr <- ltcs.month.arr / joiners.month.arr[1:(length(joiners.month.arr) - 36 - 1)]
png("dvprs-month.png", width=800,height=600);
plot(as.numeric(names(authors.month.arr)), authors.month.arr, ylim=c(1,tt+10),main = "# of developers each month",type="l",xlab="Tenure (months)",ylab="# each month", col=1);
lines(as.numeric(names(cmtrs.month.arr)),cmtrs.month.arr, col=2);
lines(as.numeric(names(joiners.month.arr)),joiners.month.arr, col=4);
lines(as.numeric(names(ltcs.month.arr)),ltcs.month.arr, col=3);
legend(2005, tt,legend=c("# of authors","# of committers", "# of joiners", "# of LTCs"),cex=1,lwd=2,col=rep(1:4),bg="white"); 
dev.off()
png("ltcratio-month.png", width=800,height=600)
tt <- max(ltcratio.month.arr)
plot(as.numeric(names(ltcratio.month.arr)), ltcratio.month.arr, ylim=c(0,tt),main = "Ratio of LTCs to joiners each month",type="l",xlab="Tenure (months)",ylab="Ratio", col=2);
dev.off()

## how avg of files/modules touched by one person varys
authors.month.arr <- tapply(delta$aid, delta$m, numOfUnique) # authors
chgspson.month.arr <- tapply(delta$aid, delta$m, length) / author.month.arr
tt <- max(chgspson.month.arr) / 2
modspson.month.arr <- tapply(1:numofdeltas, delta$m, function(x) {numauthor <- numOfUnique(delta$aid[x]); modspson <- tapply(delta$mod[x], delta$aid[x], numOfUnique); return(sum(modspson) / numauthor)})
flspson.month.arr <- tapply(1:numofdeltas, delta$m, function(x) {numauthor <- numOfUnique(delta$aid[x]); flspson <- tapply(delta$f[x], delta$aid[x], numOfUnique); return(sum(flspson) / numauthor)})
png("changes.files.mods-avrgpson.month.png", width=800,height=600);
plot(as.numeric(names(chgspson.month.arr)), chgspson.month.arr, ylim=c(1,tt),main = "Average productivity over time",type="l",xlab="Tenure (months)",ylab="#", col=1);
lines(as.numeric(names(flspson.month.arr)), flspson.month.arr * 2, col=2);
lines(as.numeric(names(modspson.month.arr)), modspson.month.arr * 10, col=3);
legend(2005, tt,legend=c("# of changes per author","# of files per author * 2", "# of modules per author * 10"),cex=1,lwd=2,col=rep(1:3),bg="white"); 
dev.off()

## how avg of LOC per person varys
addspson.month.arr <- tapply(1:numofdeltas, delta$m, function(x) {numauthor <- numOfUnique(delta$aid[x]); addspson<-tapply(delta$add[x], delta$aid[x], mean); return(sum(addspson)/numauthor)})
delspson.month.arr <- tapply(1:numofdeltas, delta$m, function(x) {numauthor <- numOfUnique(delta$aid[x]); delspson<-tapply(delta$del[x], delta$aid[x], mean); return(sum(delspson)/numauthor)})
tt <- 80
png("adds.dels-avrgpchgpson.month.png", width=800,height=600);
plot(as.numeric(names(addspson.month.arr)), addspson.month.arr, ylim=c(0,tt),main = "Average productivity(LOC) over time",type="l",xlab="Tenure (months)",ylab="#", col=1);
lines(as.numeric(names(delspson.month.arr)), delspson.month.arr, col=2);
legend(2005, tt,legend=c("LOC added per change per author","LOC deleted per change per author"),cex=1,lwd=2,col=rep(1:2),bg="white"); 
dev.off()

# structure analysis

## disconcern time
mods.author.arr <- tapply(delta$mod, delta$aid, numOfUnique)
authors.numMods.tb <- table(mods.author.arr)
mods.cmtr.arr <- tapply(delta$mod, delta$cid, numOfUnique)
cmtrs.numMods.tb <- table(mods.cmtr.arr)
png("CFG.dvpr-numMods.png", width=800,height=600);
plot(c(0, as.numeric(names(authors.numMods.tb))), 
	c(0, cumsum(authors.numMods.tb/sum(authors.numMods.tb))), 
	main = "CFG of developers' modules",xlab="Number of modules",ylab="CF",
	ylim=c(0,1), pch=2, lty=3, type='b', col=2);
lines(c(0, as.numeric(names(cmtrs.numMods.tb))), c(0, cumsum(cmtrs.numMods.tb/sum(cmtrs.numMods.tb))),type='b', pch=2, lty=3, col=3);
legend(10, 0.6,legend=paste(c("author: total","committer: total"),
	c(sum(authors.numMods.tb), sum(cmtrs.numMods.tb))),
	cex=1,lwd=2,col=2:3,bg="white"); 
dev.off()

## in drivers
drivers.delta.sel <- delta$mod == 'drivers' & delta$mmod != delta$f
mods.author.indrivers.arr <- tapply(delta$mmod[drivers.delta.sel], delta$aid[drivers.delta.sel], numOfUnique)
authors.numMods.indrivers.tb <- table(mods.author.indrivers.arr)
mods.cmtr.indrivers.arr <- tapply(delta$mmod[drivers.delta.sel], delta$cid[drivers.delta.sel], numOfUnique)
cmtrs.numMods.indrivers.tb <- table(mods.cmtr.indrivers.arr)
png("CFG.dvprs-numMods.indrivers.png", width=800,height=600);
plot(c(0, as.numeric(names(authors.numMods.indrivers.tb))), c(0, cumsum(authors.numMods.indrivers.tb/sum(authors.numMods.indrivers.tb))), ylim=c(0,1),main = "CFG of developers' modules in drivers",type='b', pch=2, lty=3,xlab="Number of modules",ylab="CF", col=2);
lines(c(0, as.numeric(names(cmtrs.numMods.indrivers.tb))), c(0, cumsum(cmtrs.numMods.indrivers.tb/sum(cmtrs.numMods.indrivers.tb))), type='b', pch=2, lty=3, col=3);
legend(50, 0.6,legend=c("author","committer"),cex=1,lwd=2,col=2:3,bg="white"); 
dev.off()

## in drivers/staging
staging.delta.sel <- delta$mmod == 'drivers/staging' & delta$smod != delta$f
mods.author.instaging.arr <- tapply(delta$smod[staging.delta.sel], delta$aid[staging.delta.sel], numOfUnique)
authors.numMods.instaging.tb <- table(mods.author.instaging.arr)
mods.cmtr.instaging.arr <- tapply(delta$smod[staging.delta.sel], delta$cid[staging.delta.sel], numOfUnique)
cmtrs.numMods.instaging.tb <- table(mods.cmtr.instaging.arr)
png("CFG.dvprs-numMods.instaging.png", width=800,height=600);
plot(c(0, as.numeric(names(authors.numMods.instaging.tb))), c(0, cumsum(authors.numMods.instaging.tb/sum(authors.numMods.instaging.tb))), ylim=c(0,1),main = "CFG of developers' modules in staging",type='b', pch=2, lty=3,xlab="Number of modules",ylab="CF", col=2);
lines(c(0, as.numeric(names(cmtrs.numMods.instaging.tb))), c(0, cumsum(cmtrs.numMods.instaging.tb/sum(cmtrs.numMods.instaging.tb))), type='b', pch=2, lty=3, col=3);
abline(h=c(0.8, 0.9, 0.95), lty=2, col='gray')
legend(50, 0.6,legend=c("author","committer"),cex=1,lwd=2,col=2:3,bg="white"); 
dev.off()

## 
### It could be this case: core authors/committers touched more modules, so we need 
### core authors
chgsofauthor.utb <- table(delta$aid)
chgsofauthor.tb <- sort(chgsofauthor.utb, decreasing=T)
coreAuthor.chgsofauthor.sel <- cumsum(chgsofauthor.tb)/sum(chgsofauthor.tb) <= 0.8
coreAuthor.delta.sel <- coreAuthor.chgsofauthor.sel[delta$aid]
coreAuthor.chgsofauthorUtb.sel <- coreAuthor.chgsofauthor.sel[names(chgsofauthor.utb)]
coreAuthor.modsAuthorArr.sel <- coreAuthor.chgsofauthor.sel[names(mods.author.arr)]

mods.coreAuthor.arr <- tapply(delta$mod[coreAuthor.delta.sel], delta$aid[coreAuthor.delta.sel], numOfUnique)
coreAuthors.numMods.tb <- table(mods.coreAuthor.arr)
### core committers
chgsOfCmtrs.utb <- table(delta$cid)
chgsOfCmtrs.tb <- sort(chgsOfCmtrs.utb, decreasing=T)
coreCmtr.chgsOfCmtrs.sel <- cumsum(chgsOfCmtrs.tb)/sum(chgsOfCmtrs.tb) <= 0.8
coreCmtr.delta.sel <- coreCmtr.chgsOfCmtrs.sel[delta$cid]
mods.coreCmtr.arr <- tapply(delta$mod[coreCmtr.delta.sel], delta$cid[coreCmtr.delta.sel], numOfUnique)
coreCmtrs.numMods.tb <- table(mods.coreCmtr.arr)
### plot
png("CFG.coreDvprs-numMods.png", width=800,height=600);
plot(c(0, as.numeric(names(coreAuthors.numMods.tb))), 
	c(0, cumsum(coreAuthors.numMods.tb)/sum(coreAuthors.numMods.tb)),
	main = "CFG of core developers' modules", xlab="Number of modules", ylab="CF",
	ylim = c(0, 1),	type='b',pch=2, lty=3, col=2)
lines(c(0, as.numeric(names(coreCmtrs.numMods.tb))),
	c(0, cumsum(coreCmtrs.numMods.tb)/sum(coreCmtrs.numMods.tb)),
	type='b',pch=2, lty=3, col=3)
abline(h=c(0.8, 0.9, 0.95), lty=2, col='gray')
legend(10, 0.6, legend=paste(c("author: total","committer: total"), 
	c(sum(coreAuthors.numMods.tb), sum(coreCmtrs.numMods.tb))),
	cex=1,lwd=2,col=2:3,bg="white"); 
dev.off()

