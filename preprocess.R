## init
picdir <- "../SyncDirectory/research/linux/pics/"
wdir <- "/store1/chenqy/linuxhistory/" # on pae
setwd(wdir)
picdir <- "./"
first <- function(x){sort(x)[1];};
spread <- function(x){ length(table(as.character(x))); };
numOfZero <- function(x) {return(sum(x==0))}
lennonzero <- function(x){ length(x[x!=0]); };
numOfUnique<-function(x) {return(length(unique(x)))}
adjNumOfUnique <- function(x) {return(length(x)/max(table(x)))}
cosSim<-function(x, y) {return(sum(x*y)/sqrt(sum(x^2))/sqrt(sum(y^2)))}
numOfLessThan0 <- function(x) {return(sum(x < 0))}
t2apply <- function(v, g2, g1, f) {return(tapply(1:length(g1), g1, function(x) {return(tapply(v[x], g2[x], f))}))}
mySummary <- function(v) {t <- summary(v); t['Num'] <- length(v); return(t)}
startdate <- 2005
enddate <- 2015.917

## read data
lg <- read.table("linux.l2", sep=";",comment.char="", quote="",
	col.names=c("v","an","cn","ae","ce","line","at","ct","f","cmt"),
	colClasses=c(rep("character", 6), rep("integer", 2), rep('character', 2)));

## merge aliases with full dataset using Python
#/ write.table(data.frame(e=c(lg$ae, lg$ce), n=c(lg$an, lg$cn)), file="./e.n.full",
#/     row.names = F, col.names = F)
### merging using python
t<-read.csv("all.aliase.id.networkx.full", header=F, col.names=c('als', 'id'))
idmp<-as.character(t[,2])
names(idmp)<-t[,1]
lg$cid<-idmp[tolower(lg$ce)]
tsel<-which(is.na(lg$cid))
#### see nothing in tsel
lg$aid<-idmp[tolower(lg$ae)]
tsel<-which(is.na(lg$aid))
	# > lg[tsel, 'ae']
	# [1] ""                                   ""
	# [3] ""                                   ""
	# [5] "Signed-off-by@vergenet.net\":Simon" ""
	# > tolower(lg[tsel, 'an'])
	# [1] "craig markwardt"                     "jiayingz@google.com (jiaying zhang)"
	# [3] "jiayingz@google.com (jiaying zhang)" "solofo.ramangalahy@bull.net"
	# [5] "signed-off-by@vergenet.net\":simon"  ""
lg$aid[tsel[1]]<-idmp["craig markwardt"]
lg$aid[tsel[2]]<-idmp['jiayingz@google.com']
lg$aid[tsel[3]]<-idmp['jiayingz@google.com']
lg$aid[tsel[4]]<-idmp['solofo.ramangalahy@bull.net']
lg$aid[tsel[5]]<-"signed-off-by@vergenet.net\":simon"
lg$aid[tsel[6]]<-''
#### drop delta that has no author
lg <- lg[lg$aid != '', ]


## get LOC of add, del
lg$add <- sub(":.*$","",lg$line,perl=T,useBytes=T);
lg$del <- sub("^.*:","",lg$line,perl=T,useBytes=T);
lg$add <- as.integer(lg$add);
lg$del <- as.integer(lg$del);

## remove useless column
lg$line <- NULL

## time
### author
lg$y <- floor(lg$at/3600/24/365.25)+1970;
lg$q <- floor(lg$at/3600/24/365.25*4)/4+1970;
lg$m <- floor(lg$at/3600/24/365.25*12)/12+1970;
lg$ty<-lg$at/3600/24/365.25+1970;
tmin <- tapply(lg$ty, lg$aid, min, na.rm=T);
lg$fr <- tmin[lg$aid]
tmax <- tapply(lg$ty, lg$aid, max, na.rm=T);
lg$to <- tmax[lg$aid]
lg$tenure <- lg$ty-lg$fr;
lg$tt <- ceiling((lg$tenure+.000001)*12); # tenure months, .000001 is used to spare, e.g., one delta people
#### round month
lg$m <- round(lg$m, digits=3)
### cmtr
lg$cy <- floor(lg$ct/3600/24/365.25)+1970;
lg$cq <- floor(lg$ct/3600/24/365.25*4)/4+1970;
lg$cm <- floor(lg$ct/3600/24/365.25*12)/12+1970;
lg$cty<-lg$ct/3600/24/365.25+1970;
tmin <- tapply(lg$cty, lg$cid, min, na.rm=T);
lg$cfr <- tmin[lg$cid]
tmax <- tapply(lg$cty, lg$cid, max, na.rm=T);
lg$cto <- tmax[lg$cid]
lg$ctenure <- lg$cty-lg$cfr;
lg$ctt <- ceiling((lg$ctenure+.000001)*12); # tenure months, .000001 is used to spare, e.g., one delta people
#### round month
lg$cm <- round(lg$cm, digits=3)
#### author is cmtr?
t <- rep(NA, nrow(lg))
names(t) <- lg$aid
t[names(tmin)] <- tmin
lg$a1cmt<-t[lg$aid]
lg$afr1cmt<-lg$ty-lg$a1cmt

### LTC
lg$contr3y <- (lg$to-lg$ty>=3) # still contrbuting 3 years later
lg$contr3y[lg$ty > (enddate - 3)] <- NA

## file's extension and modules
lg$ff<-sub(".*/","",lg$f,perl=T,useBytes=T);
lg$ext<-tolower(sub(".*\\.","",lg$ff,perl=T,useBytes = T));
lg$mod <- sub("/.*", "",lg$f,perl=T,useBytes=T); # first module
lg$mmod<-sub("^([^/]*/[^/]*)/.*","\\1", lg$f, perl=T,useBytes=T); # second module
lg$smod<-sub("^([^/]*/[^/]*/[^/]*)/.*","\\1", lg$f, perl=T,useBytes=T); # 3rd module
lg$fm<-sub("/[^/]*$","", lg$f, perl=T,useBytes=T);

get1stModIdx<-function(idx) { # idx is in lg
	todr <- order(lg$ty[idx])
	mods<- lg$mod[idx[todr]]
	return(idx[todr][which(c('#$', mods) != c(mods, NA))[1]])
}
get1stCmtrModIdx<-function(idx) { # idx is in lg
	todr <- order(lg$cty[idx])
	mods<- lg$mod[idx[todr]]
	return(idx[todr][which(c('#$', mods) != c(mods, NA))[1]])
}
get2ndModIdx<-function(idx) { # idx is in lg
	todr <- order(lg$ty[idx])
	mods<- lg$mod[idx[todr]]
	return(idx[todr][which(c('#$', mods) != c(mods, NA))[1:2]])
}
getFst2ModAndDTime <- function(idx) {
	if(is.na(idx[2])) return(data.frame(mod1=character(0), mod2=character(0), 
		dtime = numeric(0)))
	return(data.frame(mod1=lg$mod[idx[1]], mod2=lg$mod[idx[2]], 
		dtime = lg$ty[idx[2]] - lg$ty[idx[1]]))
}
### first module of author
fstAthrModIdx <- tapply(1:nrow(lg), lg$aid, get1stModIdx)
lg$fstAMod <- lg$mod[fstAthrModIdx[lg$aid]]
### first module of committer
fstCmtrModIdx <- tapply(1:nrow(lg), lg$cid, get1stCmtrModIdx)
lg$fstCMod <- lg$mod[fstCmtrModIdx[lg$cid]]

## select deltas that we care
delta <- lg[lg$m>=startdate & lg$m<=enddate & lg$ext=="c",];

### first 2 module touched by author
fst2ModIdx <- tapply(1:nrow(lg), lg$aid, get2ndModIdx)
transMod <- Reduce(rbind, lapply(fst2ModIdx, getFst2ModAndDTime))
library('igraph', lib='/home/pkuas/R/x86_64-redhat-linux-gnu-library/3.1/')
transel <- transMod$dtime != 0
### how many modules committed to by one dvpr before being a committer
tsel <- lg$mod != lg$f
dateBecmCmtr.cmtr.mod <- t2apply(lg$cty[tsel], lg$cid[tsel], lg$mod[tsel], min)
numCModsBefCmtr.cmtr.mod <- list()
for (mod in names(dateBecmCmtr.cmtr.mod)){
	t <- c()
	for (cmtr in names(dateBecmCmtr.cmtr.mod[[mod]])){
		tsel <- lg$cid == cmtr & lg$cty < dateBecmCmtr.cmtr.mod[[mod]][cmtr]
		t[cmtr] <- numOfUnique(lg$mod[tsel])
	}
	numCModsBefCmtr.cmtr.mod[[mod]] <- t
}
lapply(numCModsBefCmtr.cmtr.mod, mySummary)
#### correlation 
t <- lapply(numCModsBefCmtr.cmtr.mod, mySummary)
m <- unlist(lapply(t, function(x) return(x['Median'])))
n <- unlist(lapply(t, function(x) return(x['Num'])))
stats::cor.test(m, n, method='spearman')
stats::cor.test(m, n, method='pearson')
#### plot
tdf <- convtArrOfListToDF(numCModsBefCmtr.cmtr.mod)
colnames(tdf) <- c('cid', 'mod', 'numMods')
png('numCModsBefCmtr.cmtr.mod.png', width=800, height=600)
boxplot(numMods ~ mod, data=tdf, las=2, ylab='# of modules',
	main='# of modules per committer committed to before he was a committer of one module')
dev.off()
### how many modules committed to by one dvpr before being a committer
numModsBefCmtr.cmtr.mod <- list()
for (mod in names(dateBecmCmtr.cmtr.mod)){
	t <- c()
	for (cmtr in names(dateBecmCmtr.cmtr.mod[[mod]])){
		tsel <- lg$aid == cmtr & lg$cty < dateBecmCmtr.cmtr.mod[[mod]][cmtr]
		t[cmtr] <- numOfUnique(lg$mod[tsel])
	}
	numModsBefCmtr.cmtr.mod[[mod]] <- t
}
lapply(numModsBefCmtr.cmtr.mod, mySummary)
#### correlation 
t <- lapply(numModsBefCmtr.cmtr.mod, mySummary)
m <- unlist(lapply(t, function(x) return(x['Median'])))
n <- unlist(lapply(t, function(x) return(x['Num'])))
stats::cor.test(m, n, method='spearman')
stats::cor.test(m, n, method='pearson')
#### plot
tdf <- convtArrOfListToDF(numModsBefCmtr.cmtr.mod)
colnames(tdf) <- c('cid', 'mod', 'numMods')
png('numModsBefCmtr.cmtr.mod.png', width=800, height=600)
boxplot(numMods ~ mod, data=tdf, las=2, ylab='# of modules',
	main='# of modules per committer contributed to before he was a committer of one module')
dev.off()
