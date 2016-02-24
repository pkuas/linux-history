
first <- function(x){sort(x)[1];}; 
spread <- function(x){ length(table(as.character(x))); };
tab <- function(x){ (table(as.character(x))); };
lennonzero <- function(x){ length(x[x!=0]); };

x <- read.table("linux.l2", sep=";",comment.char="", quote="",col.names=c("v","an","cn","ae","ce","line","at","ct","f","cmt"),fileEncoding="latin1");

#x$an <- sub("\xdf","ss",x$an,perl=T,useBytes=T);  #Albrecht Dre\xdf
x$add <- sub(":.*$","",x$line,perl=T,useBytes=T);
x$del <- sub("^.*:","",x$line,perl=T,useBytes=T);
x$add <- as.integer(x$add);
x$del <- as.integer(x$del);

x$y <- floor(x$at/3600/24/365.25)+1970;
x$q <- floor(x$at/3600/24/365.25*4)/4+1970;
x$m <- floor(x$at/3600/24/365.25*12)/12+1970;
x$ty<-x$at/3600/24/365.25+1970;

tmin <- tapply(x$ty, x$an, min, na.rm=T);
x$fr <- tmin[match(x$an,names(tmin))];
tmax <- tapply(x$ty, x$an, max, na.rm=T);
x$to <- tmax[match(x$an,names(tmax))];
x$tenure <- x$ty-x$fr;
x$tt <- ceiling((x$tenure+.000001)*12); # tenure months, .000001 is used to spare, e.g., one delta people

x$ff<-sub(".*/","",x$f,perl=T,useBytes=T);
x$ext<-tolower(sub(".*\\.","",x$ff,perl=T,useBytes = T)); 

x$mod <- sub("/.*", "",x$f,perl=T,useBytes=T);

x$mmod<-sub("^([^/]*/[^/]*)/.*","\\1", x$f, perl=T,useBytes=T);
x$smod<-sub("^([^/]*/[^/]*/[^/]*)/.*","\\1", x$f, perl=T,useBytes=T);
x$fm<-sub("/[^/]*$","", x$f, perl=T,useBytes=T);

tot <- tapply(x$tt, x$an,length);
ten <- tapply(x$tt, x$an,max);
x$tot <- tot[match(x$an,names(tot))]; # number of commits overall
x$ten <- ten[match(x$an,names(ten))]; # number of months overall
x$prod <- (tot/ten)[match(x$an,names(tot/ten))];

for (i in c("mod","smod","ff")){
  tbl <- table (x[,i]);
  x[,paste(i,"Chg",sep="")] <- tbl[x[,i]];
  tbl <- tapply(as.character(x$an), x[,i], spread);
  tbl[is.na(tbl)] <- 0;
  x[,paste(i,"Nlogin",sep="")] <- tbl[x[,i]]; 
}

fr <- tapply(x$m, x$an, min, na.rm=T);
x$fr1 <- fr[match(x$an,names(fr))]; #standardize the fr into one of the 12 months

#######below start calculation by rolling 3-year window month by month
delta <- x[x$fr1>1970 & x$to<2015.963 & x$tt<=131 & x$m<2015.9 & x$m>=2005 & x$ext=="c",];

allmod <- table(delta$mod);
dd1 <- data.frame();
dd1 <- rbind(dd1,allmod);
dimnames(dd1)[[2]] <- names(allmod);

dd2 <- data.frame();
dd2 <- rbind(dd2,allmod);
dimnames(dd2)[[2]] <- names(allmod);

cmtr <- data.frame();
cmtr <- rbind(cmtr,allmod);
dimnames(cmtr)[[2]] <- names(allmod);

atr <- data.frame();
atr <- rbind(atr,allmod);
dimnames(atr)[[2]] <- names(allmod);

core <- data.frame();
core <- rbind(core,allmod);
dimnames(core)[[2]] <- names(allmod);

modchg <- data.frame();
modchg <- rbind(modchg,allmod);
dimnames(modchg)[[2]] <- names(allmod);

#max is the maxium month, min is the minimum month in the rolling window
min <- min(delta$m);
max <- min+3;
coreteam <- c();
while (max<2015.91) {
	p <- delta[delta$m<max & delta$m>=min,]; #& delta$ext=="c",];

	aemod <- table(p$an,p$mod);
	cemod <- table(p$cn,p$mod);

	mod <- names(table(p$mod));
	dvprmod <- data.frame(mod);
	dvprmod$nchg <-tapply(p$v,p$mod,length);
	dvprmod$nce <- tapply(p$cn,p$mod,spread);
	dvprmod$nae <- tapply(p$an,p$mod,spread);

	
	for (j in dvprmod$mod) {
		topdvp <- sort(-cemod[,j]);
		sum80 <- topdvp[1];
		#prop <- -topdvp[1];
		dvpr <- names(topdvp[1]);
		for (i in 2:length(topdvp)) {
			if (sum80/sum(topdvp) >= 0.8) break;		
			sum80 <- sum80+topdvp[i];
			dvpr <- paste(dvpr,names(topdvp[i]),sep=";");
			#prop <- paste(prop,-topdvp[i],sep=";");			
		}
		dvprmod$dvpr[dvprmod$mod==j] <- dvpr;
		#dvprmod$prop[dvprmod$mod==j] <- prop;
	}

	dvprlist <- c();
	for (i in 1:length(dvprmod$dvpr)) {
		tmp <- strsplit(dvprmod$dvpr[i], ';');
		dvprmod$len[i] <- length(tmp[[1]]);
		dvprlist <- c(dvprlist,tmp[[1]]);
	}	
	
	r1 <- dvprmod$nce/dvprmod$len;
	r2 <- dvprmod$nae/dvprmod$nce;
	cmtr <- rbind(cmtr,dvprmod$nce[match(names(cmtr),names(dvprmod$nce))]);
	atr <- rbind(atr,dvprmod$nae[match(names(atr),names(dvprmod$nae))]);  
	core <- rbind(core,dvprmod$len[match(names(core),dvprmod$mod)]);
	dd1 <- rbind(dd1,r1[match(names(allmod),names(r1))]);	
	dd2 <- rbind(dd2,r2[match(names(allmod),names(r2))]);	
	pair <- c(length(dvprlist),length(table(dvprlist)));
	coreteam <- c(coreteam,pair);
	modchg <- rbind(modchg,dvprmod$nchg[match(names(allmod),dvprmod$mod)]);

	min <- min+1/12;
	max <- min+3;
}
#   arch drivers  fs    kernel   mm  net  sound 
# 151416 461572  73017  23117 11640 74154 33550 
dd11 <- dd1[2:96,]; #remove the first item
dd21 <- dd2[2:96,];
cmtr1 <- cmtr[2:96,];
atr1 <- atr[2:96,];
core1 <- core[2:96,];
modchg1 <- modchg[2:96,];

png("core.png", width=800,height=600);
 plot(core1[,1],type="l",ylim=c(0,43),main = "Number of core committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="number")
 lines(core1[,7],col=2,lty=1)
 lines(core1[,9],col=3,lty=1)
 lines(core1[,12],col=4,lty=1)
 lines(core1[,14],col=5,lty=1)
 lines(core1[,15],col=6,lty=1)
 lines(core1[,19],col=7,lty=1)
lines(c(2:96),rep(0,95),col=1,lty=2)
 legend(20,max(core1[,1]),legend=c("arch","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();


png("committers.png", width=800,height=600);
 plot(cmtr1[,1],type="l",ylim=c(0,250),main = "Number of committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="number")
 lines(cmtr1[,7],col=2,lty=1)
 lines(cmtr1[,9],col=3,lty=1)
 lines(cmtr1[,12],col=4,lty=1)
 lines(cmtr1[,14],col=5,lty=1)
 lines(cmtr1[,15],col=6,lty=1)
 lines(cmtr1[,19],col=7,lty=1)
lines(c(2:96),rep(0,95),col=1,lty=2)
 legend(20,250,legend=c("arch","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();

png("authors.png", width=800,height=600);
 plot(atr1[,1],type="l",ylim=c(0,5000),main = "Number of authors (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="number")
 lines(atr1[,7],col=2,lty=1)
 lines(atr1[,9],col=3,lty=1)
 lines(atr1[,12],col=4,lty=1)
 lines(atr1[,14],col=5,lty=1)
 lines(atr1[,15],col=6,lty=1)
 lines(atr1[,19],col=7,lty=1)
lines(c(2:96),rep(0,95),col=1,lty=2)
 legend(20,5000,legend=c("arch","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();


#png("author2committer.png", width=800,height=600);
postscript("author2committer.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
 plot(dd21[,1],type="l",ylim=c(1,28),main = "Ratio of authors to committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="ratio")
 lines(dd21[,7],col=2,lty=1)
 lines(dd21[,9],col=3,lty=1)
 lines(dd21[,12],col=4,lty=1)
 lines(dd21[,14],col=5,lty=1)
 lines(dd21[,15],col=6,lty=1)
 lines(dd21[,19],col=7,lty=1)
 legend(60,28,legend=c("arch","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();
postscript("author2committer2.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
 plot(dd21[,1],type="l",ylim=c(5,28),main = "Ratio of authors to committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="ratio")
 lines(dd21[,7],col=2,lty=2,lwd=2)
 lines(dd21[,9],col=3,lty=3,lwd=2)
 lines(dd21[,12],col=4,lty=4,lwd=2)
 lines(dd21[,14],col=5,lty=5,lwd=2.5)
 lines(dd21[,15],col=6,lty=6,lwd=2)
 legend(60,28,legend=c("arch","drivers","fs","kernel","mm","net"),cex=1,lwd=2,col=rep(1:6),lty=rep(1:6),bg="white"); 
dev.off();

png("committer2core.png", width=800,height=600);
 plot(dd11[,1],type="l",ylim=c(1,50),main = "Ratio of committers to core (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="ratio")
 lines(dd11[,7],col=2,lty=1)
 lines(dd11[,9],col=3,lty=1)
 lines(dd11[,12],col=4,lty=1)
 lines(dd11[,14],col=5,lty=1)
 lines(dd11[,15],col=6,lty=1)
 lines(dd11[,19],col=7,lty=1)
 legend(20,50,legend=c("arch","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();

coreteam1 <- c();coreteam2 <- c(); i <-1; while(i < 190){ coreteam1 <- c(coreteam1,coreteam[i]); coreteam2 <- c(coreteam2,coreteam[i+1]); i<-i+2;}

#len2*10=nce and nce*10=nae
#the top 80% changes for a particular file/module must be their owners
#sum80 <- function(x){sum(tail(x,2));}

######### deal with committers and authors

delta$cmtr <- match(delta$an,unique(delta$cn));
alpha <- delta[delta$cmtr>=1 & (!is.na(delta$cmtr)),];

cmtr <- data.frame(table(as.character(delta$cn)));
tmp <- tapply(alpha$ty,alpha$an,first); #first time as author
cmtr$fsta <- tmp[match(cmtr$Var1,names(tmp))]; 

tmp <- tapply(alpha$ty,alpha$cn,first); #first time as committer
cmtr$fstc <- tmp[match(cmtr$Var1,names(tmp))]; 

alpha$fstcmtr <- tmp[match(alpha$cn,names(tmp))];
tmp <- tapply(alpha$mod[alpha$fstcmtr==alpha$ty], alpha$cn[alpha$fstcmtr==alpha$ty], first); #first mod as committer
cmtr$fstcmod <- tmp[match(cmtr$Var1,names(tmp))];
tmp <- tapply(alpha$ext[alpha$fstcmtr==alpha$ty], alpha$cn[alpha$fstcmtr==alpha$ty], first); #first ext as committer
cmtr$fstcext <- tmp[match(cmtr$Var1,names(tmp))];

tmp <- tapply(alpha$mod[alpha$fr==alpha$ty], alpha$an[alpha$fr==alpha$ty], first); #first mod as author
cmtr$fstamod <- tmp[match(cmtr$Var1,names(tmp))];
tmp <- tapply(alpha$ext[alpha$fr==alpha$ty], alpha$an[alpha$fr==alpha$ty], first); #first ext as author
cmtr$fstaext <- tmp[match(cmtr$Var1,names(tmp))];

 tmp <- tapply(delta$mod, delta$cn, spread);
nmod <- as.numeric(tmp);
 cmtr2 <- data.frame(nmod)
 cmtr2$cn <- names(tmp);
cmtr2$ten <- delta$ten[match(cmtr2$cn,delta$cn)];

cmtrmod <- table(delta$mod,delta$cn);
cmtrmod2 <- data.frame(cmtrmod[1,]);
for (i in 1:37) {cmtrmod2[,i] <- cmtrmod[i,];}
cmtrmod2[cmtrmod2!=0] <- 1;

##### correlation between modules touched

atrmod <- table(delta$mod,delta$an);
atrmod2 <- data.frame(atrmod[1,]);
for (i in 1:22) {atrmod2[,i] <- atrmod[i,];}
atrmod2[atrmod2>0] <- 1;
atrmod2[,23] <- apply(atrmod2,1,sum);
dimnames(atrmod2)[[2]]<- c(dimnames(atrmod)[[1]],"sum");
tmp <- atrmod2[atrmod2$sum==1,];
sort(-apply(tmp,2,sum))/9571;
tmp <- atrmod2[atrmod2$sum!=1,];
cor(tmp[,c(1,6,7,9,12,14,15,19)],tmp[,c(1,6,7,9,12,14,15,19)]);

############### below is by-month calculation ####################
#delta <- x[x$fr1>1970 & x$to<2015.963 & x$tt<=131,];
delta$m1 <- as.factor(delta$m);
delta$fr1 <- as.factor(delta$fr1);

abym <- tapply(delta$an,delta$m1,spread);
cbym <- tapply(delta$cn,delta$m1,spread);
aloc <- tapply(delta$add,delta$m1,sum);
dloc <- tapply(delta$del,delta$m1,sum);
vbym <- tapply(delta$v,delta$m1,length);
mod8m <- tapply(delta$mod,delta$m1,spread);
f8m <- tapply(delta$ff,delta$m1,spread);
delta$flg <- (delta$to-delta$fr)>=3;
ltc8m <- tapply(delta$an[delta$flg==1],delta$fr1[delta$flg==1],spread); ## new joiners/LTCs
jbym <- tapply(delta$an,delta$fr1,spread); #new joiners
delta$cmtrflg <- match(delta$an,unique(sort(delta$cn)));
jcmtrbym <- tapply(delta$an[delta$cmtrflg>=1],delta$fr1[delta$cmtrflg>=1],spread); #new joining committers

practice <- data.frame(abym);
practice$m <- dimnames(practice)[[1]];
practice$cbym <- cbym;
practice$aloc <- aloc;
practice$dloc <- dloc;
practice$vbym <- vbym;
practice$mod8m <- mod8m;
practice$f8m <- f8m;
practice$ltc8m <- ltc8m;
practice$jbym <- jbym[8:138];
practice$jcmtrbym <- jcmtrbym[8:138];

practice$avgchg <- vbym/abym;

moddvp <- table(delta$mod,delta$an,delta$m);
dvponmod <- apply(moddvp,c(1,3),lennonzero);
modondvp <- apply(moddvp,c(2,3),lennonzero);

non0mean <- function(x){mean(x[x!=0]);}; 
tmp <- apply(dvponmod,2,non0mean); # number of dvprs per module each month
practice$avgdvpofm <- tmp;
tmp1 <- apply(modondvp,2,non0mean); # number of modules per dvpr each month
practice$avgmofdvp <- tmp1;
tmp <- data.frame(tmp1);
tmp$m <- as.numeric(dimnames(tmp)[[1]]);
tmp$y <- floor(tmp$m);
postscript("avgmoddvpr.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
boxplot(tmp$tmp1[tmp$y==2005],tmp$tmp1[tmp$y==2006],tmp$tmp1[tmp$y==2007],tmp$tmp1[tmp$y==2008],tmp$tmp1[tmp$y==2009],tmp$tmp1[tmp$y==2010],tmp$tmp1[tmp$y==2011],tmp$tmp1[tmp$y==2012],tmp$tmp1[tmp$y==2013],tmp$tmp1[tmp$y==2014],tmp$tmp1[tmp$y==2015],names=c(2005:2015))
dev.off();


locadvp <- c();
for(i in names(table(delta$an)))
{
	tmp <- tapply(delta$add[delta$an==i],delta$m1[delta$an==i],sum);
	locadvp <- rbind(locadvp,tmp);
}
avgadd <- apply(locadvp,2,mean,na.rm=T); # number of added lines per dvpr (who touched code) each month
practice$avgadd <- avgadd;

nfdvp <- c();
for(i in names(table(delta$an)))
{
	tmp <- tapply(delta$ff[delta$an==i],delta$m1[delta$an==i],spread);
	nfdvp <- rbind(nfdvp,tmp);
}
avgfdvp <- apply(nfdvp,2,mean,na.rm=T); # number of files per dvpr (who touched code) each month
postscript("avgfiledvpr.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
plot(names(avgfdvp), avgfdvp, type="b", main = "Average # of files per person per month",xlab="Natural Month",ylab="# of changers");
dev.off();
tmp <- data.frame(avgfdvp);
tmp$m <- as.numeric(dimnames(tmp)[[1]]);
tmp$y <- floor(tmp$m);
postscript("avgfiledvpr2.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
boxplot(tmp$avgfdvp[tmp$y==2005],tmp$avgfdvp[tmp$y==2006],tmp$avgfdvp[tmp$y==2007],tmp$avgfdvp[tmp$y==2008],tmp$avgfdvp[tmp$y==2009],tmp$avgfdvp[tmp$y==2010],tmp$avgfdvp[tmp$y==2011],tmp$avgfdvp[tmp$y==2012],tmp$avgfdvp[tmp$y==2013],tmp$avgfdvp[tmp$y==2014],tmp$avgfdvp[tmp$y==2015],names=c(2005:2015))
dev.off();

avgchg <- vbym/abym
tmp <- data.frame(avgchg);
tmp$m <- as.numeric(dimnames(tmp)[[1]]);
tmp$y <- floor(tmp$m);
boxplot(tmp$avgchg[tmp$y==2005],tmp$avgchg[tmp$y==2006],tmp$avgchg[tmp$y==2007],tmp$avgchg[tmp$y==2008],tmp$avgchg[tmp$y==2009],tmp$avgchg[tmp$y==2010],tmp$avgchg[tmp$y==2011],tmp$avgchg[tmp$y==2012],tmp$avgchg[tmp$y==2013],tmp$avgchg[tmp$y==2014],tmp$avgchg[tmp$y==2015],names=c(2005:2015))

ndvpf <- c();
for(i in names(table(delta$ff)))
{
	tmp <- tapply(delta$an[delta$ff==i],delta$m1[delta$ff==i],spread);
	ndvpf <- rbind(ndvpf,tmp);
}
avgdvpf <- apply(ndvpf,2,mean,na.rm=T); # number of dvprs per file each month
tmp <- data.frame(avgdvpf);
tmp$m <- as.numeric(dimnames(tmp)[[1]]);
tmp$y <- floor(tmp$m);
#practice$avgff <- avgff;
postscript("avgchgerfile2.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
boxplot(tmp$avgdvpf[tmp$y==2005],tmp$avgdvpf[tmp$y==2006],tmp$avgdvpf[tmp$y==2007],tmp$avgdvpf[tmp$y==2008],tmp$avgdvpf[tmp$y==2009],tmp$avgdvpf[tmp$y==2010],tmp$avgdvpf[tmp$y==2011],tmp$avgdvpf[tmp$y==2012],tmp$avgdvpf[tmp$y==2013],tmp$avgdvpf[tmp$y==2014],tmp$avgdvpf[tmp$y==2015],names=c(2005:2015))
dev.off();

avgdvpf <- c();
for(j in c("drivers","arch","kernel","mm","fs","net","sound")){
ndvpf <- c();
for(i in names(table(delta$ff[delta$mod==j])))
{
	tmp <- tapply(delta$an[delta$ff==i],delta$m1[delta$ff==i],spread);
	ndvpf <- rbind(ndvpf,tmp);
}
tmp1 <- apply(ndvpf,2,mean,na.rm=T);
avgdvpf <- rbind(avgdvpf,tmp1);
}
tmp <- data.frame(avgdvpf[4,][10:140]);
tmp$m <- as.numeric(dimnames(tmp)[[1]]);
tmp$y <- floor(tmp$m);
postscript("chgermm.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
boxplot(tmp$avgdvpf[tmp$y==2005],tmp$avgdvpf[tmp$y==2006],tmp$avgdvpf[tmp$y==2007],tmp$avgdvpf[tmp$y==2008],tmp$avgdvpf[tmp$y==2009],tmp$avgdvpf[tmp$y==2010],tmp$avgdvpf[tmp$y==2011],tmp$avgdvpf[tmp$y==2012],tmp$avgdvpf[tmp$y==2013],tmp$avgdvpf[tmp$y==2014],tmp$avgdvpf[tmp$y==2015],names=c(2005:2015))
dev.off()

time <- names(avgdvpf[1,][10:140]);
mod <- c("drivers","kernel","fs");
postscript("avgchgerfileonmod.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
plot(time,avgdvpf[1,][10:140],ylim=c(1,2.5),type="b", main = "Average # of changers per file per month",xlab="Natural Month",ylab="# of changers");
lines(time,avgdvpf[2,][10:140],col=2,lty=2)
#lines(time,avgdvpf[3,][10:140],col=3,lty=3)
#lines(time,avgdvpf[4,][10:140],col=4,lty=4)
lines(time,avgdvpf[5,][10:140],col=5,lty=5)
lines(time,avgdvpf[6,][10:140],col=6,lty=6)
#lines(time,avgdvpf[7,][10:140],col=7,type="b")
legend(2010,4.7,legend=mod,cex=1,lwd=2,col=rep(1:6),lty=rep(1:6),bg="white"); 
dev.off();

postscript("chgerkn2driver2fs.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
plot(time,avgdvpf[1,][10:140],ylim=c(1,4.8),type="b", main = "Average # of changers per file per month",xlab="Natural Month",ylab="# of changers");
lines(time,avgdvpf[3,][10:140],col=2,lty=2,lwd=2)
lines(time,avgdvpf[5,][10:140],col=3,lty=3,lwd=2)
legend(2010,4.7,legend=mod,cex=1,lwd=2,col=rep(1:3),lty=rep(1:3),bg="white"); 
dev.off()

#######################
ndvpf <- c();
for(i in names(table(delta$ff[delta$mod==j])))
{
	tmp <- tapply(delta$an[delta$ff==i],delta$m1[delta$ff==i],spread);
	ndvpf <- rbind(ndvpf,tmp);
}
avgdvpf <- apply(ndvpf,2,mean,na.rm=T); # number of dvprs each file each month
postscript("avgchgerfile.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
plot(names(avgdvpf), avgdvpf, type="b", main = "Average # of changers per file per month",xlab="Natural Month",ylab="# of changers");
dev.off();
########################

practice$avgdvpf <- avgdvpf;

#the proportion of changes made by the #1 person on that file
nchgf <- c();
delta$an <- as.factor(delta$an);
delta$ff <- as.factor(delta$ff);
for(i in names(table(delta$m1)))
{
	tmp <- table(delta$an[delta$m1==i],delta$ff[delta$m1==i]);
	r12 <- c();
	for(j in 1:length(names(table(delta$ff))))
	{
		tmp1 <- tail(sort(tmp[,j]),1); #the biggest # of changes by sb at month i on file j
		r12 <- c(r12,tmp1/sum(tmp[,j])); # the biggest proportion at month i on file j:  all files together
	}
	nchgf <- rbind(nchgf,r12); #each row is the biggest proportion of changes (made by sb) at month i on all files
}
tmp <- apply(nchgf,1,mean,na.rm=T);
practice$rchg <- tmp;

postscript("Chgproportion.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
plot(practice$m,practice$rchg,main = "biggest ratio of changes (average over all files) over time",type="l",xlab="Time (months)",ylab="ratio");
dev.off();

dvponf <- table(delta$an,delta$ff);
r1 <- c();
r2 <- c();
for(i in 1:length(names(table(delta$ff))))
{
	tmp <- tail(sort(dvponf[,i]),2);
	r1 <- c(r1,tmp[2]/sum(dvponf[,i]));
	r2 <- c(r2,tmp[1]/sum(dvponf[,i]));	
}

avgloc8f <- locadvp/nfdvp; #avg loc per file each person (who touched code) each month
practice$avgloc8f <- apply(avgloc8f,2,mean,na.rm=T);

minm4ff <- tapply(delta$m, delta$ff, min, na.rm=T);
tmp <- table(minm4ff);
practice$newf <- tmp[match(practice$m,names(tmp))];
practice$newf <- tmp[match(practice$m,names(tmp))];

minm4m <- tapply(delta$m, delta$mod, min, na.rm=T);
tmp <- table(minm4m);

png("codegrowth.png", width=800,height=600);
plot(practice$m, practice$newf,main = "code growth over time",type="l",xlab="Time (months)",ylab="# each month");
 lines(practice$m,practice$aloc/1000,col=2);
legend(2002, max(practice$newf),legend=c("# new files","LOC added/1000"),cex=1,lwd=2,col=rep(1:2),bg="white"); 
dev.off();

png("codeownership.png", width=800,height=600);
plot(practice$m, practice$avgdvpofm,main = "code ownership over time",type="l",xlab="Tenure (months)",ylab="# each month");
 lines(practice$m,practice$avgdvpf*50,col=2);
legend(2002, max(practice$avgdvpofm),legend=c("# dvpr per module","# dvpr per file*50"),cex=1,lwd=2,col=rep(1:2),bg="white"); 
dev.off();

png("productivity.png", width=800,height=600);
 plot(practice$m,practice$avgff,main = "Average productivity over time",type="l",xlab="Tenure (months)",ylab="ratio",ylim=c(0,16));
  lines(practice$m,practice$avgmofdvp*5,col=2);
legend(2002, 16,legend=c("# files per person","# modules per person*5"),cex=1,lwd=2,col=rep(1:2),bg="white"); 
dev.off()


png("avglocf.png", width=800,height=600);
 plot(practice$m,practice$avgloc8f,main = "Average prodctivity(LOC) over time",type="l",xlab="Tenure (months)",ylab="# each month");
  lines(practice$m,practice$avgadd/10,col=2);
  #lines(practice$m,practice$avgff,col=3);
  #lines(practice$m,practice$f8m/100,col=4);
legend(2004, max(practice$avgloc8f),legend=c("LOC per file per person","LOC per person/10"),cex=1,lwd=2,col=rep(1:3),bg="white"); 
dev.off();

mod <- names(sort(-table(delta$mod))[2:8]);
png("dvponmod.png", width=800,height=600);
 matplot(as.numeric(names(dvponmod[1,])),t(dvponmod[mod,]),main="number of developers on each module each month",type="o",col=1:8,xlab="natural month",ylab="# of developers");
 legend(2002,max(dvponmod[mod,]),legend=mod,cex=1,lwd=2,col=rep(1:8),bg="white"); 
dev.off();

png("avgmoddvpr.png", width=800,height=600);
 plot(practice$m,practice$avgdvpofm,main = "Average #dvpr each module over time",type="l",xlab="Tenure (months)",ylab="ratio");
 lines(practice$m,practice$avgmofdvp*10,col=2);
 lines(practice$m,practice$avgchg,col=3);
legend(2004,max(practice$avgdvpofm),legend=c("Avg #dvpr each module","Avg #module each dvpr*10","# changes per dvpr"),cex=1,lwd=2,col=rep(1:3),bg="white"); 
dev.off();

png("locovertime.png", width=800,height=600);
 plot(practice$m, aloc,ylim=c(1,1e6),main = "Lines of code over time",type="l",xlab="Tenure (months)",ylab="# each month");
 lines(practice$m,dloc,col=2);
 # lines(practice$m,vbym,col=3,lty=2); 
legend(2002, 1e6,legend=c("Lines of added code","Lines of deleted code"),cex=1,lwd=2,col=rep(1:2),bg="white"); 
dev.off();

postscript("dvprovertime.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
plot(practice$m, practice$abym,main = "# of developers over time",type="b",xlab="Natural Month",ylab="# of dvprs",lwd=2.5);
 lines(practice$m,practice$cbym,col=2,lty=2,lwd=3);
lines(practice$m,practice$jbym,col=3,lty=4,lwd=3);
legend(2010, max(practice$abym)/2,legend=c("# authors","# committers","# newcomers"),cex=1,lwd=2,col=rep(1:3),lty=c(1,2,4),bg="white"); 
dev.off();

delta$fryr <- floor(delta$fr1);
joiner <- tapply(delta$an,delta$fryr,spread);
jltc <- tapply(delta$an[delta$flg==1],delta$fryr[delta$flg==1],spread);
ratio <- jltc[5:12]/joiner[5:12];

jcmtr <- tapply(delta$an[delta$cmtrflg>=1],delta$fryr[delta$cmtrflg>=1],spread); #new joining committers

library(plotrix);
postscript("newltcs.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
twoord.plot(c(2005:2012),jltc[5:12],c(2005:2012),jcmtr[3:10],lylim=c(0,600),rylim=c(0,180),main = "Number of newcomers becoming LTCs/Committers", lcol=4,rcol=2,ylab="# new LTCs",rylab="# new committers",type=c("b","b")) 
legend(2009,500,legend=c("# new LTCs (dot)","# new committers (triangle)"),cex=1,lwd=2,col=c(4,2),lty=c(1:2),bg="white"); 
dev.off();

ratio2 <- jcmtr[3:10]/joiner[5:12];
postscript("ratioltc.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
twoord.plot(c(2005:2012),ratio,c(2005:2012),ratio2,lylim=c(0,0.5),rylim=c(0,0.15),main = "Ratio of newcomers becoming LTCs/Committers", lcol=4,rcol=2,ylab="Ratio of new LTCs",rylab="Ratio of new committers",type=c("b","b"));
legend(2009,.45,legend=c("ratio of new LTCs (dot)","ratio of new committers (triangle)"),cex=1,lwd=2,col=c(4,2),lty=c(1:2),bg="white"); 
dev.off();


postscript("joiners.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
plot(practice$m, practice$ltc8m,main = "# of developers over time",type="l",xlab="Natural Month",ylab="# of dvprs");
#lines(practice$m,practice$ltc8m,col=2,lty=2,lwd=2);
lines(practice$m,(practice$ltc8m/practice$jbym)*100,col=3,lty=1,lwd=2);
legend(2010,200,legend=c("# newcomers","# new LTCs"),cex=1,lwd=2,col=rep(1:3),lty=rep(1:2),bg="white"); 
dev.off();



png("teamproductivity.png", width=800,height=600);
 plot(practice$m,vbym,main = "# of modules overall over time",type="l",xlab="Tenure (months)",ylab="# each month");
  lines(practice$m,f8m,col=2);
  lines(practice$m,mod8m*100,col=3);
legend(2010, max(vbym),legend=c("# of changes","# of files touched","# of modules touched*100"),cex=1,lwd=2,col=rep(1:3),bg="white"); 
dev.off();

#### relationship between ratio and new joiners
delta <- x[x$fr1>1970 & x$to<2015.963 & x$tt<=131 & x$m<2015.9 & x$m>=2005 & x$ext=="c",];

delta$m1 <- as.factor(delta$m);
delta$fr2 <- as.factor(delta$fr1);

delta$flg <- (delta$to-delta$fr)>=3;

cwithj <- c();
cwithj2 <- c();
for (i in c("drivers","arch","fs","net","kernel","mm"))
{
	ncn <- tapply(delta$cn[delta$mod==i],delta$m1[delta$mod==i],spread);
	nan <- tapply(delta$an[delta$mod==i],delta$m1[delta$mod==i],spread);	
	nltc <- tapply(delta$an[delta$mod==i&delta$flg==1],delta$fr2[delta$mod==i&delta$flg==1],spread);
	
	#jbym <- tapply(delta$an[delta$mod==i],delta$fr1[delta$mod==i],spread); #new joiners
	#for (j in 1:10) { if (names(jbym[j])=="2005") {break;} }
	#jbym <- jbym[j:length(jbym)];	
	tmp <- 10*nan/ncn;
	#tmp1 <- cor(tmp,jbym,use="complete.obs");
	#cwithj <- c(cwithj,tmp1);	
	tmp2 <- cor(tmp,nltc[8:138],use="complete.obs");
	cwithj2 <- c(cwithj2,tmp2);	
}

for (i in c("drivers/gpu","drivers/media","drivers/usb","arch/arm","arch/x86","arch/powerpc","arch/mips","net/ipv4","net/ipv6","net/mac80211", "fs/xfs","fs/btrfs"))
{
	ncn <- tapply(delta$cn[delta$mmod==i],delta$m[delta$mmod==i],spread);
	nan <- tapply(delta$an[delta$mmod==i],delta$m[delta$mmod==i],spread);
	jbym <- tapply(delta$an[delta$mmod==i],delta$fr1[delta$mmod==i],spread); #new joiners
	for (j in 1:10) { if (names(jbym[j])=="2005") {break;} }
	jbym <- jbym[j:length(jbym)];	
	tmp <- 10*nan/ncn;
	tmp1 <- cor(tmp,jbym,use="complete.obs");
	cwithj <- c(cwithj,tmp1);	
}


"drivers/net/wireless","drivers/net/ethernet","drivers/staging/iio","drivers/staging/comedi"
