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

getNumVar2EachVar1InPrdofDelta<-function(sel, prd, var1, var2, measure) {
	return(tapply((1:numofdeltas)[sel], delta[sel, prd],
		function(x) {return(tapply(delta[x, var2], delta[x, var1], measure))}))
}
convtArrOfListToDF<-function(arrList, usename=TRUE) {
    if (usename) {
        t <- data.frame(cid=character(0),m=character(0),measure=numeric(0))
        for (m in names(arrList)){
    		tv <- arrList[[m]]
    		t <- tryCatch({
                rbind(t, data.frame(cid=names(tv),m=rep(as.numeric(m), length(tv)),
    			 measure=tv, row.names=NULL))
                }, error=function(e){
                    rbind(t, data.frame(cid=names(tv),m=rep(m, length(tv)),
                 measure=tv, row.names=NULL))
                }, warning=function(w){
                    rbind(t, data.frame(cid=names(tv),m=rep(m, length(tv)),
                 measure=tv, row.names=NULL))
                })
    	}
    }
    else {
        t <- data.frame(m=character(0),measure=numeric(0))
        for (m in names(arrList)){
            tv <- arrList[[m]]
            t <- tryCatch({
                rbind(t, data.frame(m=rep(as.numeric(m), length(tv)), measure=tv, row.names=NULL))
                }, error=function(e){
                    rbind(t, data.frame(m=rep(m, length(tv)), measure=tv, row.names=NULL))
                }, warning=function(w){
                    rbind(t, data.frame(m=rep(m, length(tv)), measure=tv, row.names=NULL))
                })
        }
    }

	return(t)
}

# monthly log: extracted from delta
## monthly committer
mcmtr <- data.frame(cid=character(0),m=numeric(0),numChg=integer(0),
    numAthrs=integer(0), adjNumAthrs=numeric(0),
    numMods=integer(0), adjNumMods=numeric(0))
### num of changes each year committed
modsInRoot <- unique(delta$mod[delta$mod!=delta$f]) # certa and usr will be dropped
for (mod in modsInRoot) { # cannot be directly run, you should modified before run
    ## init setting
    tsel <- delta$mod == mod
    # for root module, should run the code within this loop, loop not included
    # tsel <- 1:numofdeltas
    # mod <- 'root'

    tdf <- data.frame(aid=character(0), m=numeric(0), numChg=integer(0))
    print(mod)

    t <- tryCatch({
        convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'cid', 'aid', length))
        }, error = function(e) {
            cat(mod, 'error\n');
            return(NULL)
        })
    if (is.null(t)) next
    t$mod <- mod
    colnames(t)[3] <- 'numChgs'
    ########### or:
    # t <- as.data.frame(table(delta$cid, delta$y))
    # colnames(t) <- c('cid', 'm', 'numChg')
    # t$mod <- 'root'
    tdf <- rbind(tdf, t)
    ### num of athrs every cmtr committed for, each period
    t <- convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'cid', 'aid', numOfUnique))
    colnames(t)[3]<-'numAthrs'
    t$mod <- mod
    tdf <- merge(tdf, t, by=c('cid', 'mod', 'm'))
    ### num of adjusted athrs every cmtr committed for, each period
    t <- convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'cid', 'aid', adjNumOfUnique))
    colnames(t)[3]<-'adjNumAthrs'
    t$mod <- mod
    tdf <- merge(tdf, t, by=c('cid', 'mod', 'm'))
    ### num of modules every cmtr committed for, each period
    t <- convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'cid', 'mod', numOfUnique))
    colnames(t)[3]<-'numMods'
    t$mod <- mod
    tdf <- merge(tdf, t, by=c('cid', 'mod', 'm'))
    ### num of adjusted modules every cmtr committed for, each period
    t <- convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'cid', 'mod', adjNumOfUnique))
    colnames(t)[3]<-'adjNumMods'
    t$mod <- mod
    tdf <- merge(tdf, t, by=c('cid', 'mod', 'm'))

    mcmtr <- rbind(mcmtr, tdf)
}

## monthly author
mathr <- data.frame(aid=character(0), m=numeric(0), numChg=integer(0),
    numCmtrs=integer(0), adjNumCmtrs=numeric(0),
    numMods=integer(0), adjNumMods=numeric(0))
### num of changes each year coded
## root module & sub modules
modsInRoot <- unique(delta$mod[delta$mod!=delta$f])
#modsInRoot <- modsInRoot # 'certs' and 'usr' only has one change
for (mod in modsInRoot) { # cannot be directly run, you should modified before run
    ## init setting
    tsel <- delta$mod == mod
    tdf <- data.frame(aid=character(0), m=numeric(0), numChg=integer(0))
    # for root module
    # tsel <- 1:numofdeltas
    # mod <- 'root'
    print(mod)

    t <- tryCatch({
        convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'aid', 'aid', length))
        }, error = function(e) {
            cat(mod, 'error\n');
            return(NULL)
        })
    if (is.null(t)) next
    t$mod <- mod
    colnames(t)[c(1,3)] <- c('aid','numChgs')
    ########### or:
    # t <- as.data.frame(table(delta$cid, delta$y))
    # colnames(t) <- c('cid', 'm', 'numChg')
    # t$mod <- 'root'
    tdf <- rbind(tdf, t)
    ### num of cmtrs every athr committed to, each period
    t <- convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'aid', 'cid', numOfUnique))
    colnames(t)[c(1,3)]<-c('aid','numCmtrs')
    t$mod <- mod
    tdf <- merge(tdf, t, by=c('aid', 'mod', 'm'))
    ### num of adjusted cmtrs every athr committed to, each period
    t <- convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'aid', 'cid', adjNumOfUnique))
    colnames(t)[c(1,3)]<-c('aid','adjNumCmtrs')
    t$mod <- mod
    tdf <- merge(tdf, t, by=c('aid', 'mod', 'm'))
    ### num of modules every athr coded for, each period
    t <- convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'aid', 'mod', numOfUnique))
    colnames(t)[c(1,3)]<-c('aid','numMods')
    t$mod <- mod
    tdf <- merge(tdf, t, by=c('aid', 'mod', 'm'))
    ### num of adjusted modules every cmtr committed for, each period
    t <- convtArrOfListToDF(getNumVar2EachVar1InPrdofDelta(tsel, 'm', 'aid', 'mod', adjNumOfUnique))
    colnames(t)[c(1,3)]<-c('aid','adjNumMods')
    t$mod <- mod
    tdf <- merge(tdf, t, by=c('aid', 'mod', 'm'))

    mathr <- rbind(mathr, tdf)
}

## monthly ana for each mod of root
### num Chgs in each month for each mod
numChgs.in.month.mod.al <- t2apply(mathr$numChgs, mathr$m,  mathr$mod, sum)
png('numChgs-month.mod.png', width=800, height=600)
t <- numChgs.in.month.mod.al
tcol <- rainbow(length(t) + 1)[-1]
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)+10),
    main='# of changes in each month for each module',
    xlab='natural month', ylab='# of changes')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='l')
legend(2005, 7000, legend=c('drivers', 'arch'),cex=1,lwd=1,
    col=tcol[c('drivers', 'arch')] ,bg="white");
dev.off();

### num of athrs in each month for each module
numAthrs.in.month.mod.al <- t2apply(mathr$aid, mathr$m, mathr$mod, length)
png('numAthrs-month.mod.png', width=800, height=600)
t <- numAthrs.in.month.mod.al
tcol <- rainbow(length(t) + 1)[-1]
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)+10),
    main='# of authors in each month for each module',
    xlab='natural month', ylab='# of authors')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='l')
legend(2005, 700, legend=c('drivers', 'arch'),cex=1,lwd=1,
    col=tcol[c('drivers', 'arch')] ,bg="white");
dev.off();

### num of cmtrs in each month for each module
numCmtrs.in.month.mod.al <- t2apply(mcmtr$cid, mcmtr$m, mcmtr$mod, length)
png('numCmtrs-month.mod.png', width=800, height=600)
t <- numCmtrs.in.month.mod.al
tcol <- rainbow(length(t) + 1)[-1]
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)+10),
    main='# of committers in each month for each module',
    xlab='natural month', ylab='# of committers')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='l')
legend(2005, 120, legend=c('drivers', 'arch', 'fs'),cex=1,lwd=1,
    col=tcol[c('drivers', 'arch', 'fs')] ,bg="white");
dev.off();

### num of new comers in each month for each module
tsel <- delta$tenure==0
numJoiners.in.month.mod.al <- t2apply(delta$aid[tsel], delta$m[tsel], delta$mod[tsel], numOfUnique) # joiners
png('numJoiners-month.mod.png', width=800, height=600)
t <- numJoiners.in.month.mod.al
tcol <- rainbow(length(t) + 1)[-1]
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)+3),
    main='# of joiners in each month for each module',
    xlab='natural month', ylab='# of joiners')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='l')
legend(2007, 100, legend=c('drivers', 'arch'),cex=1,lwd=1,
    col=tcol[c('drivers', 'arch')] ,bg="white");
dev.off();

### num of new committers in each month for each module
tsel <- delta$ctenure == 0
numNewCmtrs.in.month.mod.al <- t2apply(delta$cid[tsel], delta$m[tsel], delta$mod[tsel], numOfUnique)
png('numNewCmtrs-month.mod.png', width=800, height=600)
t <- numNewCmtrs.in.month.mod.al
tcol <- rainbow(length(t) )
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)),
    main='# of new committers in each month for each module',
    xlab='natural month', ylab='# of new committers')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='l')
legend(2007, 6, legend=c('drivers', 'arch', 'fs', 'net'),cex=1,lwd=1,
    col=tcol[c('drivers', 'arch', 'fs', 'net')] ,bg="white");
dev.off();


## deepen into drivers, monthly ana for each mod of drivers
tsel <- delta$mod == 'drivers' & delta$mmod != delta$f
mods.in.drivers <- unique(delta$mmod[tsel])
tcol <- rainbow(length(mods.in.drivers))
tcol <- sample(tcol, replace=F)
names(tcol) <- mods.in.drivers
### num of changes in each month for each modules of drivers
numChgs.in.month.mdrivers.al <- t2apply(delta$aid[tsel], delta$m[tsel], delta$mmod[tsel], length)
png('numChgs-month.mdrivers.png', width=800, height=600)
t <- numChgs.in.month.mdrivers.al
tplt <- unique(c(head(names(sort(-unlist(lapply(t, sum)))), n=5),
	head(names(sort(-unlist(lapply(t, max)))), n=5)))
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t[['drivers/gpu']])+3),
    main='# of changes in each month for each module of drivers',
    xlab='natural month', ylab='# of changes')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='l')
legend(2005, 3000, legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();
sink('numChgs.in.month.mdrivers.al.txt', append=F)
print(t)
sink()
### num of authors in each month for each modules of drivers
numAthrs.in.month.mdrivers.al <- t2apply(delta$aid[tsel], delta$m[tsel], delta$mmod[tsel], numOfUnique)
png('numAthrs-month.mdrivers.png', width=800, height=600)
t <- numAthrs.in.month.mdrivers.al
tplt <- unique(	head(names(sort(-unlist(lapply(t, max)))), n=8))
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t[['drivers/net']])+3),
    main='# of authors in each month for each module of drivers',
    xlab='natural month', ylab='# of authors')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='l')
legend(2005, 176, legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();
sink('numAthrs.in.month.mdrivers.al.txt', append=F)
print(t)
sink()
### num of cmtrs in each month for each modules of drivers
numCmtrs.in.month.mdrivers.al <- t2apply(delta$cid[tsel], delta$m[tsel], delta$mmod[tsel], numOfUnique)
png('numCmtrs-month.mdrivers.png', width=800, height=600)
t <- numCmtrs.in.month.mdrivers.al
tplt <- unique(	head(names(sort(-unlist(lapply(t, max)))), n=5))
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t[['drivers/gpu']])+2),
    main='# of committers in each month for each module of drivers',
    xlab='natural month', ylab='# of committers')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='l')
legend(2005, 25, legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();
sink('numCmtrs.in.month.mdrivers.al.txt', append=F)
print(t)
sink()

# yearly ana of modules in root
getIncRate <- function(x){
	tname <- 2005:2015
	t <- rep(0, length(tname))
	names(t) <- tname
	t[names(x)] <- x
	nx <- length(t)
	return((t[-1] - t[-nx]) / t[-nx] * 100)
}

modsel <- delta$mod != delta$f
joinersel <- delta$tenure == 0
ncmtrsel <- delta$ctenure == 0
## num of changes
numChgs.mod.year.ar <- t2apply(delta$aid[modsel], delta$y[modsel], delta$mod[modsel], length)
png('numChgs-year.mod.png', width=800, height=600)
t <- numChgs.mod.year.ar
tcol <- rainbow(length(t) )
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
tplt <- c('drivers', 'arch', 'fs', 'kernel', 'mm')
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)),
    main='# of changes in each year for each module',
    xlab='natural year', ylab='# of changes')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2006, 60000, legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();
### increase rate
png('numChgsIncR-year.mod.png', width=800, height=600)
t <- numChgs.mod.year.ar
tplt <- c('drivers', 'arch', 'fs', 'kernel', 'mm')
t <- lapply(t[tplt], getIncRate)
plot(1, type='n', xlim=c(2005, 2016),
	ylim=c(min(unlist(lapply(t, min))), max(unlist(lapply(t, max)))),
    main='Increase rate of changes in each year for each module',
    xlab='natural year', ylab='Increase rate(%)')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2012, max(unlist(lapply(t, max))), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();

## num of authors
numAthrs.mod.year.ar <- t2apply(delta$aid[modsel], delta$y[modsel], delta$mod[modsel], numOfUnique)
png('numAthrs-year.mod.png', width=800, height=600)
t <- numAthrs.mod.year.ar
tcol <- rainbow(length(t) )
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
tplt <- c('drivers', 'arch', 'fs', 'net', 'kernel', 'mm')
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)),
    main='# of authors in each year for each module',
    xlab='natural year', ylab='# of authors')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2006, max(t$drivers), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();
### increase rate
png('numAthrsIncR-year.mod.png', width=800, height=600)
t <- numAthrs.mod.year.ar
tplt <- c('drivers', 'arch', 'fs', 'kernel', 'mm')
t <- lapply(t[tplt], getIncRate)
plot(1, type='n', xlim=c(2005, 2016),
	ylim=c(min(unlist(lapply(t, min))), max(unlist(lapply(t, max)))),
    main='Increase rate of authors in each year for each module',
    xlab='natural year', ylab='Increase rate(%)')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2012, max(unlist(lapply(t, max))), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();

## num of cmtrs
numCmtrs.mod.year.ar <- t2apply(delta$cid[modsel], delta$y[modsel], delta$mod[modsel], numOfUnique)
png('numCmtrs-year.mod.png', width=800, height=600)
t <- numCmtrs.mod.year.ar
tcol <- rainbow(length(t) )
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
tplt <- c('drivers', 'arch', 'fs', 'net', 'kernel', 'mm')
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)),
    main='# of committers in each year for each module',
    xlab='natural year', ylab='# of committers')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2006, max(t$drivers), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();
### increase rate
png('numCmtrsIncR-year.mod.png', width=800, height=600)
t <- numCmtrs.mod.year.ar
tplt <- c('drivers', 'arch', 'fs', 'kernel', 'mm')
t <- lapply(t[tplt], getIncRate)
plot(1, type='n', xlim=c(2005, 2016),
	ylim=c(min(unlist(lapply(t, min))), max(unlist(lapply(t, max)))),
    main='Increase rate of committers in each year for each module',
    xlab='natural year', ylab='Increase rate(%)')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2012, max(unlist(lapply(t, max))), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();

## num of new comers
tsel <- modsel & joinersel
numJoiners.mod.year.ar <- t2apply(delta$aid[tsel], delta$y[tsel], delta$mod[tsel], numOfUnique)
png('numJoiners-year.mod.png', width=800, height=600)
t <- numJoiners.mod.year.ar
tcol <- rainbow(length(t) )
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
tplt <- c('drivers', 'arch', 'fs', 'net', 'kernel', 'mm')
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)),
    main='# of new comers in each year for each module',
    xlab='natural year', ylab='# of new comers')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2006, max(t$drivers), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();
### increase rate
png('numJoinersIncR-year.mod.png', width=800, height=600)
t <- numJoiners.mod.year.ar
tplt <- c('drivers', 'arch', 'fs', 'kernel', 'mm')
t <- lapply(t[tplt], getIncRate)
plot(1, type='n', xlim=c(2005, 2016),
	ylim=c(min(unlist(lapply(t, min))), max(unlist(lapply(t, max)))),
    main='Increase rate of new comers in each year for each module',
    xlab='natural year', ylab='Increase rate(%)')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2014, max(unlist(lapply(t, max))), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();

## num of new cmtrs
tsel <- modsel & ncmtrsel
numNewCmtrs.mod.year.ar <- t2apply(delta$cid[tsel], delta$y[tsel], delta$mod[tsel], numOfUnique)
png('numNewCmtrs-year.mod.png', width=800, height=600)
t <- numNewCmtrs.mod.year.ar
tcol <- rainbow(length(t) )
names(tcol) <- names(t)
tplt <- names(t)[!(names(t) %in% c('root'))]
tplt <- c('drivers', 'arch', 'fs', 'net', 'kernel', 'mm')
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, max(t$drivers)),
    main='# of new committers in each year for each module',
    xlab='natural year', ylab='# of new committers')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2006, max(t$drivers), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();
### increase rate
png('numCmtrsIncR-year.mod.png', width=800, height=600)
t <- numNewCmtrs.mod.year.ar
tplt <- c('drivers', 'arch', 'fs', 'kernel', 'mm')
t <- lapply(t[tplt], getIncRate)
plot(1, type='n', xlim=c(2005, 2016),
	ylim=c(min(unlist(lapply(t, min))), max(unlist(lapply(t, max)))),
    main='Increase rate of new comers in each year for each module',
    xlab='natural year', ylab='Increase rate(%)')
for (i in tplt) lines(as.numeric(names(t[[i]])), t[[i]], col=tcol[i], type='b')
legend(2014, max(unlist(lapply(t, max))), legend=tplt,cex=1,lwd=1,
    col=tcol[tplt] ,bg="white");
dev.off();

# structure analysis, disconcern time
## see each author/committer contributed to how many modules of root
### non-adjusted
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
### adjusted num of modules
adjmods.author.arr <- tapply(delta$mod, delta$aid, adjNumOfUnique)
adjmods.cmtr.arr <- tapply(delta$mod, delta$cid, adjNumOfUnique)
png("box.dvprs-adjNumMods.png", width=800,height=600);
boxplot(numMods ~ dvpr,
	data=data.frame(numMods=c(adjmods.author.arr, adjmods.cmtr.arr),
		dvpr=c(rep('author', length(adjmods.author.arr)),
			rep('committer', length(adjmods.cmtr.arr)))),
	main="Developers' adjusted modules", ylab='# of adjusted modules')
text(2,c(4.5, 4.3), labels=paste(c("# of authors:","# of committers:"),
	c(length(adjmods.author.arr), length(adjmods.cmtr.arr))),
	cex=1,col=1,bg="white");
dev.off()

## see each author/committer contributed to how many modules of drivers
drivers.delta.sel <- delta$mod == 'drivers' & delta$mmod != delta$f
### non-adjusted
mods.author.indrivers.arr <- tapply(delta$mmod[drivers.delta.sel], delta$aid[drivers.delta.sel], numOfUnique)
authors.numMods.indrivers.tb <- table(mods.author.indrivers.arr)
mods.cmtr.indrivers.arr <- tapply(delta$mmod[drivers.delta.sel], delta$cid[drivers.delta.sel], numOfUnique)
cmtrs.numMods.indrivers.tb <- table(mods.cmtr.indrivers.arr)
png("CFG.dvprs-numMods.indrivers.png", width=800,height=600);
plot(c(0, as.numeric(names(authors.numMods.indrivers.tb))), c(0, cumsum(authors.numMods.indrivers.tb/sum(authors.numMods.indrivers.tb))), ylim=c(0,1),main = "CFG of developers' modules in drivers",type='b', pch=2, lty=3,xlab="Number of modules",ylab="CF", col=2);
lines(c(0, as.numeric(names(cmtrs.numMods.indrivers.tb))), c(0, cumsum(cmtrs.numMods.indrivers.tb/sum(cmtrs.numMods.indrivers.tb))), type='b', pch=2, lty=3, col=3);
legend(50, 0.6,legend=c("author","committer"),cex=1,lwd=2,col=2:3,bg="white");
dev.off()
### adjusted
adjmods.author.indrivers.arr <- tapply(delta$mmod[drivers.delta.sel], delta$aid[drivers.delta.sel], adjNumOfUnique)
adjmods.cmtr.indrivers.arr <- tapply(delta$mmod[drivers.delta.sel], delta$cid[drivers.delta.sel], adjNumOfUnique)
png("box.dvprs-adjNumMods.indrivers.png", width=800,height=600);
boxplot(numMods ~ dvpr,
	data=data.frame(numMods=c(adjmods.author.indrivers.arr, adjmods.cmtr.indrivers.arr),
		dvpr=c(rep('author', length(adjmods.author.indrivers.arr)),
			rep('committer', length(adjmods.cmtr.indrivers.arr)))),
	main="Developers' adjusted modules in drivers", ylab='# of adjusted modules')
axis(2, c(1, seq(2, max(adjmods.author.indrivers.arr) + 1, 2)))
text(1.5,c(9.5, 9.3), labels=paste(c("# of authors:","# of committers:"),
	c(length(adjmods.author.indrivers.arr), length(adjmods.cmtr.indrivers.arr))),
	cex=1,col=1,bg="white");
dev.off()

## see each author/committer contributed to how many modules of drivers/staging
staging.delta.sel <- delta$mmod == 'drivers/staging' & delta$smod != delta$f
### not adjusted
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
### adjusted
adjmods.author.instaging.arr <- tapply(delta$smod[staging.delta.sel], delta$aid[staging.delta.sel], adjNumOfUnique)
adjmods.cmtr.instaging.arr <- tapply(delta$smod[staging.delta.sel], delta$cid[staging.delta.sel], adjNumOfUnique)
png("box.dvprs-adjNumMods.instaging.png", width=800,height=600);
boxplot(numMods ~ dvpr,
	data=data.frame(numMods=c(adjmods.author.instaging.arr, adjmods.cmtr.instaging.arr),
		dvpr=c(rep('author', length(adjmods.author.instaging.arr)),
			rep('committer', length(adjmods.cmtr.instaging.arr)))),
	main="Developers' adjusted modules in staging", ylab='# of adjusted modules')
axis(2, c(1, seq(2, max(adjmods.author.instaging.arr) + 1, 2)))
text(1.5,c(9.5, 8.3), labels=paste(c("# of authors:","# of committers:"),
	c(length(adjmods.author.instaging.arr), length(adjmods.cmtr.instaging.arr))),
	cex=1,col=1,bg="white");
dev.off()

## see each core author/committer contributed to how many modules of root
###: It could be this case: core authors/committers touched more modules, so we need
### non-adjusted
#### core authors
chgsofauthor.utb <- table(delta$aid)
chgsofauthor.tb <- sort(chgsofauthor.utb, decreasing=T)
coreAuthor.chgsofauthor.sel <- cumsum(chgsofauthor.tb)/sum(chgsofauthor.tb) <= 0.8
coreAuthor.delta.sel <- coreAuthor.chgsofauthor.sel[delta$aid]
coreAuthor.chgsofauthorUtb.sel <- coreAuthor.chgsofauthor.sel[names(chgsofauthor.utb)]
coreAuthor.modsAuthorArr.sel <- coreAuthor.chgsofauthor.sel[names(mods.author.arr)]
mods.coreAuthor.arr <- tapply(delta$mod[coreAuthor.delta.sel], delta$aid[coreAuthor.delta.sel], numOfUnique)
coreAuthors.numMods.tb <- table(mods.coreAuthor.arr)
#### core committers
chgsOfCmtrs.utb <- table(delta$cid)
chgsOfCmtrs.tb <- sort(chgsOfCmtrs.utb, decreasing=T)
coreCmtr.chgsOfCmtrs.sel <- cumsum(chgsOfCmtrs.tb)/sum(chgsOfCmtrs.tb) <= 0.8
coreCmtr.delta.sel <- coreCmtr.chgsOfCmtrs.sel[delta$cid]
mods.coreCmtr.arr <- tapply(delta$mod[coreCmtr.delta.sel], delta$cid[coreCmtr.delta.sel], numOfUnique)
#### plot
##### CFG
coreCmtrs.numMods.tb <- table(mods.coreCmtr.arr)
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
##### boxplot
png("box.coreDvprs-numMods.png", width=800,height=600);
boxplot(numMods ~ dvpr,
	data=data.frame(numMods=c(mods.coreAuthor.arr, mods.coreCmtr.arr),
		dvpr=c(rep('author', length(mods.coreAuthor.arr)),
			rep('committer', length(mods.coreCmtr.arr)))),
	main="Core developers' modules", ylab='# of modules')
dev.off()

### adjusted core dvprs
adjmods.coreAuthor.arr <- tapply(delta$mod[coreAuthor.delta.sel], delta$aid[coreAuthor.delta.sel], adjNumOfUnique)
adjmods.coreCmtr.arr <- tapply(delta$mod[coreCmtr.delta.sel], delta$cid[coreCmtr.delta.sel], adjNumOfUnique)
png("box.coreDvprs-adjNumMods.png", width=800,height=600);
boxplot(numMods ~ dvpr,
	data=data.frame(numMods=c(adjmods.coreAuthor.arr, adjmods.coreCmtr.arr),
		dvpr=c(rep('author', length(adjmods.coreAuthor.arr)),
			rep('committer', length(adjmods.coreCmtr.arr)))),
	main="Core developers' adjusted modules", ylab='# of adjusted modules')
text(2,c(3.5, 3.3), labels=paste(c("# of authors:","# of committers:"),
	c(length(adjmods.coreAuthor.arr), length(adjmods.coreCmtr.arr))),
	cex=1,col=1,bg="white");
dev.off()

# author-committer mapping
#: i.e., how many committers each author's code is committed
#: and how many authors' code is committed by a committer
## in root: non-adjusted & adjusted
numAthrs.cmtr.arr <- tapply(delta$aid, delta$cid, numOfUnique)
adjNumAthrs.cmtr.arr <- tapply(delta$aid, delta$cid, adjNumOfUnique)
numCmtrs.athr.arr <- tapply(delta$cid, delta$aid, numOfUnique)
adjNumCmtrs.athr.arr <- tapply(delta$cid, delta$aid, adjNumOfUnique)
### non-adjusted
png("box.numPtnrs-dvpr.png", width=800,height=600);
boxplot(numPtnrs ~ dvpr,
	data=data.frame(numPtnrs=c(numCmtrs.athr.arr, numAthrs.cmtr.arr),
		dvpr=c(rep('author', length(numCmtrs.athr.arr)),
			rep('committer', length(numAthrs.cmtr.arr)))),
	main="# of partners for each developer", ylab='# of partners')
text(1.5, c(3000, 2850), labels=paste(c("# of authors:","# of committers:"),
	c(length(numCmtrs.athr.arr), length(numAthrs.cmtr.arr))),
	cex=1,col=1,bg="white");
dev.off()
### adjusted
png("box.adjNumPtnrs-dvpr.png", width=800,height=600);
boxplot(adjNumPtnrs ~ dvpr,
	data=data.frame(adjNumPtnrs=c(adjNumCmtrs.athr.arr, adjNumAthrs.cmtr.arr),
		dvpr=c(rep('author', length(adjNumCmtrs.athr.arr)),
			rep('committer', length(adjNumAthrs.cmtr.arr)))),
	main="adjusted # of partners for each developer", ylab='adjusted # of partners')
text(1.5, c(12, 11.4), labels=paste(c("# of authors:","# of committers:"),
	c(length(adjNumCmtrs.athr.arr), length(adjNumAthrs.cmtr.arr))),
	cex=1,col=1,bg="white");
dev.off()

numAthrs.cmtr.indrivers.arr <- tapply(delta$aid[drivers.delta.sel], delta$cid[drivers.delta.sel], numOfUnique)
adjNumAthrs.cmtr.indrivers.arr <- tapply(delta$aid[drivers.delta.sel], delta$cid[drivers.delta.sel], adjNumOfUnique)

png("box.numChg-cmtr.year.png", width=800,height=600);
boxplot(numChg ~ mod * m, data=mcmtr, col=c("gold", 'darkgreen'))
title('Boxplot of # of changes for committers each year')
dev.off()

png("box.mcmtr.png", width=800,height=600);
b<-boxplot(adjNumAthrs ~ mod.f *m, data=mcmtr, ylim=c(0, 8), col=c("gold","darkgreen"))
axis(2, c(1, 8, 2))
dev.off()

# structrue ana using igraph
mkEdges <- function(fr, to) {
	nfr <- length(fr); nto <- length(to);
	if (nfr == 1){ edges<-rep(fr, nto * 2); edges[seq(2, nto * 2, 2)] <- to; return(edges)}
	else if (nto == nfr){edges <- c(); edges[seq(1, nfr * 2, 2)] <- fr; edges[seq(2, nto * 2, 2)] <- to; return(edges);}
	else if (nto != 1) return(NULL);
	edges<-rep(to, nfr * 2); edges[seq(1, nfr * 2, 2)] <- fr; return(edges)
}

library('igraph', lib='/home/pkuas/R/x86_64-redhat-linux-gnu-library/3.1/')
lnx <- graph.empty() + vertex(name='root', tp='mod')
dirList <- list.dirs('./linux', full.names = FALSE, recursive = TRUE)
dirList <- dirList[dirList != '']
dirList <- dirList[substr(dirList, 1, 1) != '.']
dirFathList <- dirList
dirFathList[unlist(lapply(strsplit(dirList, '/', fixed=T), length)) == 1] <- 'root'
dirFathList <- sub("(.*)/.*","\\1",dirFathList,perl=T,useBytes=T);
lnx <- add.vertices(lnx, length(dirList), attr=list(name=dirList, tp='mod'))
lnx <- add.edges(lnx, mkEdges(dirFathList, dirList), attr=list(tp='sub'))

#
modsInRoot <- unique(delta$mod[delta$mod!=delta$f]) # certa and usr will be dropped
for (mod in modsInRoot) {
    tsel <- mcmtr$mod == mod
    png(paste("box.numAthrs-cmtr.", mod, ".month.png", sep=''), width=800,height=600);
    tryCatch({
        boxplot(mcmtr$numAthrs[tsel] ~ mcmtr$m[tsel], ylim=c(1, 15),
            main=paste('Boxplot of # authors per committer committed code for in', mod),
            xlab='natural month', ylab='# of authors')
        }, error=function(e){
            print(e)
            return(NULL)
        })
    dev.off()
    png(paste("box.adjNumAthrs-cmtr.", mod, ".month.png", sep=''), width=800,height=600);
    tryCatch({
        boxplot(mcmtr$adjNumAthrs[tsel] ~ mcmtr$m[tsel], ylim=c(1, 4),
            main=paste('Boxplot of adjusted # authors per committer committed code for in', mod),
            xlab='natural month', ylab='adjusted # of authors')
        }, error=function(e){
            print(e)
            return(NULL)
        })
    dev.off()
}
tsel <- !mcmtr$mod %in% c('root', 'arch','drivers')
png(paste("box.numAthrs-cmtr.n-a-d.month.png", sep=''), width=800,height=600);
tryCatch({
    boxplot(mcmtr$numAthrs[tsel] ~ mcmtr$m[tsel], ylim=c(1, 15),
        main=paste('Boxplot of # authors per committer committed code for in ELSE'),
        xlab='natural month', ylab='# of authors')
    }, error=function(e){
        print(e)
        return(NULL)
    })
dev.off()
png(paste("box.adjNumAthrs-cmtr.n-a-d.month.png", sep=''), width=800,height=600);
tryCatch({
    boxplot(mcmtr$adjNumAthrs[tsel] ~ mcmtr$m[tsel], ylim=c(1, 4),
        main=paste('Boxplot of adjusted # authors per committer committed code for in ELSE'),
        xlab='natural month', ylab='adjusted # of authors')
    }, error=function(e){
        print(e)
        return(NULL)
    })
dev.off()
# contribution trace
## root
### time of always being an author, or from an author to a committer
tmAthr2Cmtr.athr.arr <- -tapply(delta$afr1cmt, delta$aid, min)
tmAlwaysAthr.athr.arr <- 2015.917 - tapply(delta$ty, delta$aid, min)
tsel <- is.na(tmAthr2Cmtr.athr.arr)
tmAlwaysAthr.athr.arr[names(tmAthr2Cmtr.athr.arr)[!tsel]] <- NA
trc = data.frame(aid=names(tmAthr2Cmtr.athr.arr), tp=rep('Become committer', length(tmAthr2Cmtr.athr.arr)), tm=as.vector(tmAthr2Cmtr.athr.arr), stringsAsFactors=F)
trc$tm[trc$tm <= 0] <- NA
trc$tp[tsel] <- 'Always author'
trc$tp <- as.factor(trc$tp)
trc$tm[tsel] <- as.vector(tmAlwaysAthr.athr.arr)[tsel]
png('box.tmAthr2Cmtr.AthrAlways-athr.png', width=800,height=600);
boxplot(tm ~ tp, data = trc, main='Time of always being an author, or from author to committer, in years')
text(1.5,c(9.5, 8.5), labels=paste(c("# of always:","# of a2committer:"),
	c(sum(tsel), sum(tmAthr2Cmtr.athr.arr > 0, na.rm=T))),
	cex=1,col=1,bg="white");
dev.off()
### num of changes before being a committer (each month)
#### Prerequisite: previous data frame named 'trc', 'mathr'
trc$numChgsBef <- tapply(delta$afr1cmt, delta$aid, numOfLessThan0)
tsel <- is.na(trc$numChgsBef)
trc$numChgsBef[tsel] <- tapply(delta$v, delta$aid, length)[tsel]
png('box.numChgsBef-tmAthr2Cmtr.AthrAlways-athr.png', width=800,height=600);
boxplot(numChgsBef ~ tp, data = trc, main='# of changes of always being an author, or from author to committer')
text(1.5,c(7000, 6500), labels=paste(c("# of always:","# of a2committer:"),
	c(sum(tsel), sum(tmAthr2Cmtr.athr.arr > 0, na.rm=T))),
	cex=1,col=1,bg="white");
dev.off()
## in modules of root
### time of always being an author, or from an author to a committer
tsel <- delta$mod != delta$f
tmAthr2Cmtr.athr.mod.ar <- t2apply(delta$afr1cmt[tsel], delta$aid[tsel], delta$mod[tsel], min)
t<-convtArrOfListToDF(tmAthr2Cmtr.athr.mod.ar)
colnames(t) <- c('cid', 'mod', 'tmAthr2Cmtr')
t$tmAthr2Cmtr[t$tmAthr2Cmtr >= 0] <- NA
t$tmAthr2Cmtr <- -t$tmAthr2Cmtr
boxplot(tmAthr2Cmtr ~ mod, data=t, las=2)

# trace
## explore how modules touched in each revision
tsel <- delta$mod != delta$f
t <- tapply(delta$mod[tsel], delta$v[tsel], unique)
t <- lapply(t, sort)
tt <- lapply(t, length)
vsnModCnt <- c()
vsnModCnt['#$#$'] <- 0
res <- lapply(t, function(x) {
	pt <- Reduce(paste, x);
	if (is.na(vsnModCnt[pt])) {vsnModCnt[pt] <<- 1;}
	else {vsnModCnt[pt] <<- vsnModCnt[pt] + 1;}
	})
vsnModCnt <- sort(vsnModCnt, decreasing=T)
sink('mod-coocurr.txt', append=F)
print(vsnModCnt)
sink()


getModTrcIdx<-function(idx, tp='ty') { # idx is in delta
	return(idx[order(delta[idx, tp])])
}
tsel <- delta$mod != delta$f
athrTrc <- tapply((1:nrow(delta))[tsel], delta$aid[tsel], getModTrcIdx, tp='ty')
cmtrTrc <- tapply((1:nrow(delta))[tsel], delta$cid[tsel], getModTrcIdx, tp='cty')
getMainMod <- function(idx){
    t <- tapply(idx, delta$mod[idx], function(x) {return(sum(delta$add[x], delta$del[x]))})
    return(names(t)[which.max(t)])
}
tsel <- delta$mod != delta$f
mainModOfRev <- tapply((1:nrow(delta))[tsel], delta$v[tsel], getMainMod)
delta$mainMod <- substr(mainModOfRev[delta$v], 1, 2)
zipTrc <- function(trc) {
    m <- delta$mainMod[trc]
    return(trc[which(c('#$', m) != c(m, NA))])
}
athrTrcZip <- lapply(athrTrc, zipTrc)
cmtrTrcZip <- lapply(cmtrTrc, zipTrc)
## all years for author
athrTrcTree <- list()
res <- lapply(athrTrcZip, function(idx){
    pathes <- Reduce(paste, delta$mainMod[idx], accumulate=T)
    nidx <- length(idx)
    dtimes <- c(0, delta$ty[idx][-1] - delta$ty[idx][-nidx])
    if (is.null(athrTrcTree[[pathes[1]]])) {athrTrcTree[[pathes[1]]] <<- 1;}
        else {athrTrcTree[[pathes[1]]] <<- athrTrcTree[[pathes[1]]] + 1}
    if (nidx == 1) return(NULL);
    for (i in 2:min(nidx, 5)){
        if (is.null(athrTrcTree[[pathes[i]]])) {athrTrcTree[[pathes[i]]] <<- c(dtimes[i]);}
        else {athrTrcTree[[pathes[i]]] <<- c(athrTrcTree[[pathes[i]]], dtimes[i])}
    }
    })
#athrTrcTree <- athrTrcTree[which(unlist(lapply(athrTrcTree, length)) >= 20)]
athrTrcTree <- athrTrcTree[sort(names(athrTrcTree))]
athrTrcTreeSmry <- lapply(athrTrcTree, mySummary)
athrTrcTreeSmry <- athrTrcTreeSmry[which(unlist(lapply(athrTrcTree, length)) >= 20)]
sink('athrTrcTreeSmry.md', append=F)
print(athrTrcTreeSmry)
sink()

## 3-year period for author
athrTrcTree3year <- list()
res <- lapply(athrTrcZip, function(idx, tmrange = 3) {
    idx <- idx[delta$ty[idx] - delta$ty[idx[1]] <= tmrange]
	pathes <- Reduce(paste, delta$mainMod[idx], accumulate=T)
	nidx <- length(idx)
	dtimes <- c(0, delta$ty[idx][-1] - delta$ty[idx][-nidx])
    for (i in 1:min(nidx, 5)) {
        if (is.null(athrTrcTree3year[[pathes[i]]])) {athrTrcTree3year[[pathes[i]]] <<- list()}
    }
	maxst <- delta$m[idx[1]]
	st <- maxst - 3
	while (st <= maxst) {
		mth <- as.character(round(st, 3))
		#cat(round(maxst, 10), st, ed, mth, nidx, pathes, '\n')
		if (nidx > 0) {
			if (is.null(athrTrcTree3year[[pathes[1]]][[mth]])) {athrTrcTree3year[[pathes[1]]][[mth]] <<- 1}
		    else {athrTrcTree3year[[pathes[1]]][[mth]] <<- athrTrcTree3year[[pathes[1]]][[mth]] + 1}
		    if (nidx > 1) {
			    for (i in 2:min(nidx, 5)) {
			    	if (is.null(athrTrcTree3year[[pathes[i]]][[mth]])) {athrTrcTree3year[[pathes[i]]][[mth]] <<- c(dtimes[i])}
			    	else {athrTrcTree3year[[pathes[i]]][[mth]] <<- c(athrTrcTree3year[[pathes[i]]][[mth]], dtimes[i])}
			    }
			}
		}
	    st <- st + 1/12
	}
	})

### order
for (tp in names(athrTrcTree3year)) {
	athrTrcTree3year[[tp]] <- athrTrcTree3year[[tp]][sort(names(athrTrcTree3year[[tp]]))]
}
athrTrcTree3year <- athrTrcTree3year[sort(names(athrTrcTree3year))]

t <- convtArrOfListToDF(athrTrcTree3year[['ar dr']], usename=F)
colnames(t) <- c('m', 'dt')
t <- t[t$m >=2005 & t$m <= 2009.918, ]
boxplot(dt ~ m, data=t, ylim=c(0,1.5))

## all years for committer
cmtrTrcTree <- list()
res <- lapply(cmtrTrcZip, function(idx){
    pathes <- Reduce(paste, delta$mainMod[idx], accumulate=T)
    nidx <- length(idx)
    dtimes <- c(0, delta$cty[idx][-1] - delta$cty[idx][-nidx])
    if (is.null(cmtrTrcTree[[pathes[1]]])) {cmtrTrcTree[[pathes[1]]] <<- 1;}
        else {cmtrTrcTree[[pathes[1]]] <<- cmtrTrcTree[[pathes[1]]] + 1}
    if (nidx == 1) return(NULL);
    for (i in 2:min(nidx, 5)){
        if (is.null(cmtrTrcTree[[pathes[i]]])) {cmtrTrcTree[[pathes[i]]] <<- c(dtimes[i]);}
        else {cmtrTrcTree[[pathes[i]]] <<- c(cmtrTrcTree[[pathes[i]]], dtimes[i])}
    }
    })
#cmtrTrcTree <- cmtrTrcTree[which(unlist(lapply(cmtrTrcTree, length)) >= 50)]
cmtrTrcTree <- cmtrTrcTree[sort(names(cmtrTrcTree))]
cmtrTrcTreeSmry <- lapply(cmtrTrcTree, mySummary)
cmtrTrcTreeSmry <- cmtrTrcTreeSmry[which(unlist(lapply(cmtrTrcTree, length)) >= 5)]
sink('cmtrTrcTreeSmry.md', append=F)
print(cmtrTrcTreeSmry)
sink()

## 3-year period for committer
cmtrTrcTree3year <- list()
res <- lapply(cmtrTrcZip, function(idx, tmrange = 3) {
    idx <- idx[delta$ty[idx] - delta$ty[idx[1]] <= tmrange]
	pathes <- Reduce(paste, delta$mainMod[idx], accumulate=T)
	nidx <- length(idx)
    dtimes <- c(0, delta$cty[idx][-1] - delta$cty[idx][-nidx])
    for (i in 1:min(nidx, 5)) {
        if (is.null(cmtrTrcTree3year[[pathes[i]]])) {cmtrTrcTree3year[[pathes[i]]] <<- list()}
    }
	maxst <- delta$cm[idx[1]]
	st <- maxst - 3
	while (st <= maxst) {
		mth <- as.character(round(st, 3))
		#cat(round(maxst, 10), st, ed, mth, nidx, pathes, '\n')
		if (nidx > 0) {
			if (is.null(cmtrTrcTree3year[[pathes[1]]][[mth]])) {cmtrTrcTree3year[[pathes[1]]][[mth]] <<- 1}
		    else {cmtrTrcTree3year[[pathes[1]]][[mth]] <<- cmtrTrcTree3year[[pathes[1]]][[mth]] + 1}
		    if (nidx > 1) {
			    for (i in 2:min(nidx, 5)) {
			    	if (is.null(cmtrTrcTree3year[[pathes[i]]][[mth]])) {cmtrTrcTree3year[[pathes[i]]][[mth]] <<- c(dtimes[i])}
			    	else {cmtrTrcTree3year[[pathes[i]]][[mth]] <<- c(cmtrTrcTree3year[[pathes[i]]][[mth]], dtimes[i])}
			    }
			}
		}
	    st <- st + 1/12
	    ed <- st + 3
	}
	})
for (tp in names(cmtrTrcTree3year)) {
	cmtrTrcTree3year[[tp]] <- cmtrTrcTree3year[[tp]][sort(names(cmtrTrcTree3year[[tp]]))]
}
cmtrTrcTree3year <- cmtrTrcTree3year[sort(names(cmtrTrcTree3year))]

## combine author trace and committer trace
smodsCared <- c('dr', 'ar', 'ne', 'ke', 'mm', 'fs', 'so')
zipAcTrcTillCmtr <- function(tpmodz) {
    isa <- rep(FALSE, length(smodsCared)) # mark if one dvpr has become one module's athr
    names(isa) <- smodsCared
    isc <- isa
    n <- length(tpmodz)
    tsel <- rep(TRUE, n)
    tp <- substr(tpmodz, 1, 1)
    mod <- substr(tpmodz, 3, 4)
    for (i in 1:n) {
        if (!mod[i] %in% smodsCared) {
            tsel[i] <- FALSE;
        } else if (isc[mod[i]]) {
            tsel[i] <- FALSE;
        } else if (tp[i] == 'c') {
            isc[mod[i]] <- TRUE;
        } else if (isa[mod[i]]) {
            tsel[i] <- FALSE
        } else {
            isa[mod[i]] <- TRUE
        }
    }
    return(which(tsel))
}
## sequentail unique zip
acTrcTree <- list()
## one occurence zip, unitl as a cmtr
acTrcTree1zipc <- list()

for (cmtr in names(cmtrTrc)) {
    t <- data.frame(tp=rep('c', length(cmtrTrc[[cmtr]])), idx=cmtrTrc[[cmtr]])
    t <- rbind(t, data.frame(tp=rep('a', length(athrTrc[[cmtr]])), idx=athrTrc[[cmtr]]))
    t <- t[order(c(delta$cty[cmtrTrc[[cmtr]]], delta$ty[athrTrc[[cmtr]]])), ]
    tpmod <- paste(t$tp, delta$mainMod[t$idx], sep='-')
    tsel <- which(c('#$', tpmod) != c(tpmod, NA))
    tz <- t[tsel, ]
    tpmodz <- tpmod[tsel]
    nidx <- length(tsel)
    pathes <- Reduce(paste, tpmodz, accumulate=T)
    tm <- delta$ty[tz$idx]
    tsel <- substr(tpmodz, 1, 1) == 'c'
    tm[tsel] <- delta$cty[tz$idx[tsel]]
    # dtimes <- c(0, tm[-1] - tm[-nidx])
    acTrcTree[[cmtr]] <- list(tpmodz=tpmodz, tm=tm)
    tsel <- zipAcTrcTillCmtr(tpmodz)
    tpmodz <- tpmodz[tsel]
    tm <- tm[tsel]
    acTrcTree1zipc[[cmtr]] <- list(tpmodz=tpmodz, tm=tm)
}
#### first module as an athr
tc <- rep(0, length(smodsCared))
names(tc) <- smodsCared
for (cmtr in names(acTrcTree1zipc)){
    t <- acTrcTree1zipc[[cmtr]][['tpmodz']][1]
    tm <- substr(t, 3, 4)
    if (substr(t, 1, 1) == 'a') tc[tm] <- tc[tm] + 1
}

#### ac trc pattern
acp <- list()
for (cmtr in names(acTrcTree1zipc)){
    tpmodz <- acTrcTree1zipc[[cmtr]][['tpmodz']]
    tm <- acTrcTree1zipc[[cmtr]][['tm']]
    nidx <- length(tm)
    dtimes <- c(0, tm[-1] - tm[-nidx])
    p <- Reduce(paste, tpmodz, accumulate=T)
    if (is.null(acp[[p[1]]])) {acp[[p[1]]] <- 1}
    else {acp[[p[1]]] <- acp[[p[1]]] + 1}
    if (nidx == 1) next
    for (i in 2:nidx) {
        if (is.null(acp[[p[i]]])) {acp[[p[i]]] <-  c(dtimes[i])}
        else {acp[[p[i]]] <- c(acp[[p[i]]], dtimes[i]) }
    }
}
acp <- acp[sort(names(acp))]
smry <- lapply(acp, mySummary)
t <- smry[which(unlist(lapply(acp, length)) >= 5)]
#### how dvpr become cmtr of mm, ke
####: where they start; how many mods they contributed to before they become cmtr of mm, ke
tmm<- rep(0, length(smodsCared))
names(tmm) <- smodsCared
tke <- tmm
modsbefmm <- modsbefke <- c()
t1 <- t2 <- c() # how long since they contributed
for (cmtr in names(acTrcTree1zipc)){
    tpmodz <- acTrcTree1zipc[[cmtr]][['tpmodz']]
    tm <- acTrcTree1zipc[[cmtr]][['tm']]
    tp <- substr(tpmodz, 1, 1)
    mods <- substr(tpmodz, 3, 4)
    idx <- match(c('c-mm', 'c-ke'), tpmodz)
    if (!is.na(idx[1])) {
        tmm[mods[1]] <- tmm[mods[1]] + 1
        t1 <- c(t1, tm[idx[1]] - tm[1])
        if (idx[1] > 1) modsbefmm <- c(modsbefmm, unique(mods[1:(idx[1] - 1)]))
    }
    if (!is.na(idx[2])) {
        tke[mods[1]] <- tke[mods[1]] + 1
        t2 <- c(t2, tm[idx[2]] - tm[1])
        if (idx[2] > 1) modsbefke <- c(modsbefke, unique(mods[1:(idx[2] - 1)]))
    }
}

## new method of trace ana
getTop80Mod <-function(idx,xmod='md2') {
    t <- sort(tapply(idx, delta[idx, xmod], function(x) {return(sum(delta$add[x], delta$del[x]))}), decreasing=T)
    cs <- cumsum(t) / sum(t)
    tsel <- c(TRUE, (cs < 0.8)[-length(cs)])
    return(Reduce(paste, names(t)[tsel]))
}
tsel <- delta$md2 %in% smodsCared
t <- round(delta$m[tsel], 3)
athrmtrc <- t2apply((1:nrow(delta))[tsel], t, delta$aid[tsel], getTop80Mod) # athr's monthly trace
athrmchgs <- t2apply(delta$aid[tsel], t, delta$aid[tsel], length)
trc <- list()
res <- lapply(athrmtrc, function(x) {
    mth <- as.numeric(names(x))
    y <- floor(mth[1])
    tsel <- c('#$', x) != c(x, '#$')

    })

# module's correlation
## from author's perspective, in a given period
##: In a given period, for each author, he coded for mod A and mod B, with x chgs and y chgs
##: respectively. then correlation beteewn mod A and mod B should increase min(x, y).
smodsInRoot <- sort(smodsInRoot)
modCor <- matrix(0, nrow=length(smodsInRoot), ncol=length(smodsInRoot),
	dimnames=list(smodsInRoot, smodsInRoot))
tmod <- substr(delta$mod, 1, 2)
tsel <- delta$m >= 2012 & delta$m < 2012 + 1/12
res <- tapply((1:nrow(delta))[tsel], delta$aid[tsel], function(idx) {
	chgs <- tapply(idx, tmod[idx], function(x) {return(sum(delta$add[x], delta$del[x]))})
	#chgs <- chgs[sort(names(chgs))]
	nms <- names(chgs)
	num <- length(nms)
	for (i in 1:num){
		for (j in i:num) {modCor[nms[j], nms[i]] <<- modCor[nms[i], nms[j]] <<- modCor[nms[i], nms[j]] + min(chgs[i], chgs[j])}
	}
	})

modCor

#
library('entropy')
enSummary <- function(x) { # x is vector of counts
	sm <- summary(x);
	t <- as.vector(sm)
	names(t) <- names(sm)
	t['En'] <- entropy(x, method='ML', unit='log2')
	t['Num'] <- length(x);
	return(t)
}
## in modules of root
tsel <- delta$mod != delta$f
### in modules of root, author's contribution summary
t <- tapply(delta$aid[tsel], delta$mod[tsel], function(x) return(enSummary(as.vector(table(x)))))
asmrmod <- matrix(unlist(t),byrow=T, ncol=8,
	dimnames=list(names(t), c('min', 'q1', 'med', 'mean', 'q3', 'max', 'en', 'num')))
asmrmod <- asmrmod[order(-asmrmod[,'en']), ]
## in modules of root, cmtr's contribution summary
t <- tapply(delta$cid[tsel], delta$mod[tsel], function(x) return(enSummary(as.vector(table(x)))))
csmrmod <- matrix(unlist(t),byrow=T, ncol=8,
	dimnames=list(names(t), c('min', 'q1', 'med', 'mean', 'q3', 'max', 'en', 'num')))
csmrmod <- csmrmod[order(-csmrmod[,'en']), ]
## in modules of drivers
tsel <- delta$mod == 'drivers' & delta$mmod != delta$f
t <- tapply(delta$aid[tsel], delta$mmod[tsel], function(x) return(enSummary(as.vector(table(x)))))
asmrmoddr <- matrix(unlist(t),byrow=T, ncol=8,
	dimnames=list(names(t), c('min', 'q1', 'med', 'mean', 'q3', 'max', 'en', 'num')))
asmrmoddr <- asmrmoddr[order(-asmrmoddr[,'en']), ]
## in modules of root, cmtr's contribution summary
t <- tapply(delta$cid[tsel], delta$mmod[tsel], function(x) return(enSummary(as.vector(table(x)))))
csmrmoddr <- matrix(unlist(t),byrow=T, ncol=8,
	dimnames=list(names(t), c('min', 'q1', 'med', 'mean', 'q3', 'max', 'en', 'num')))
csmrmoddr <- csmrmoddr[order(-csmrmoddr[,'en']), ]


t<-sort(tapply(dmsid$dm, dmsid$id, length), decreasing=T)
head(t)
dmsid[dmsid$id=='dave miller',]
t<-sort(tapply(dmsid$id, dmsid$dm, length), decreasing=T)
head(t)
tsel = delta$mmod=='drivers/virtio' & delta$m >= 2012 & delta$m <= 2013
numOfUnique(delta$cid[tsel])
numOfUnique(delta$aid[tsel])
# head(sort(table(unlist(id2dms[ delta$cid[tsel] ])),decreasing=T), n=10)
# head(sort(table(unlist(id2dms[ delta$aid[tsel] ])),decreasing=T), n=10)
# head(sort(table(delta$ccompany[tsel]),decreasing=T), n=10)
### committers' domain
tc <- sort(table(delta$ccompany[tsel]), decreasing=T)
res <- tapply(delta$acompany[tsel], delta$cid[tsel], function(x){return(sort(table(x), decreasing=T))})
lapply(res, head, n=10)

tg <- tapply(delta$aid[tsel], delta$cid[tsel], numOfUnique)
tg
dmsid[dmsid$id=='axboe@carl', ]
names(idmp)[idmp=='axboe@carl']
head(delta[delta$cid=='axboe@carl', c('cty', 'ce')], n=10)

