
first <- function(x){sort(x)[1];}; 
spread <- function(x){ length(table(as.character(x))); };
lennonzero <- function(x){ length(x[x!=0]); };

#x <- read.table("bsd.l2", sep=";",comment.char="", quote="",col.names=c("v","an","cn","ae","ce","line","at","ct","f","cmt"));

x <- read.table("linux.l2", sep=";",comment.char="", quote="",col.names=c("v","an","cn","ae","ce","line","at","ct","f","cmt"));

x$add <- sub(":.*$","",x$line,perl=T,useBytes=T);
x$del <- sub("^.*:","",x$line,perl=T,useBytes=T);
x$add <- as.integer(x$add);
x$del <- as.integer(x$del);

#x$t <- as.integer(x$t);
x$y <- floor(x$at/3600/24/365.25)+1970;
x$q <- floor(x$at/3600/24/365.25*4)/4+1970;
x$m <- floor(x$at/3600/24/365.25*12)/12+1970;
x$ty<-x$at/3600/24/365.25+1970;

tmin <- tapply(x$ty, x$ae, min, na.rm=T);
#x$fr <- tmin[match(x$ae,names(tmin))];
x$fr <- tmin[x$ae]
tmax <- tapply(x$ty, x$ae, max, na.rm=T);
#x$to <- tmax[match(x$ae,names(tmax))];
x$to <- tmax[x$ae]
x$tenure <- x$ty-x$fr;
x$tt <- ceiling((x$tenure+.000001)*12); # tenure months, .000001 is used to spare, e.g., one delta people

x$ff<-sub(".*/","",x$f,perl=T,useBytes=T);
x$ext<-tolower(sub(".*\\.","",x$ff,perl=T,useBytes = T)); 

x$mod <- sub("/.*", "",x$f,perl=T,useBytes=T);

x$mmod<-sub("^([^/]*/[^/]*)/.*","\\1", x$f, perl=T,useBytes=T);
x$smod<-sub("^([^/]*/[^/]*/[^/]*)/.*","\\1", x$f, perl=T,useBytes=T);
x$fm<-sub("/[^/]*$","", x$f, perl=T,useBytes=T);

tot <- tapply(x$tt, x$ae,length);
ten <- tapply(x$tt, x$ae,max);
#x$tot <- tot[match(x$ae,names(tot))]; # number of commits overall
#x$ten <- ten[match(x$ae,names(ten))]; # number of months overall
#x$prod <- (tot/ten)[match(x$ae,names(tot/ten))];
x$tot <- tot[x$ae]
x$ten <- ten[x$ae]
x$prod <- (tot/ten)[x$ae]

# number of Changes/Logins in each module/smod/file
for (i in c("mod","smod","ff")){
  tbl <- table (x[,i]);
  x[,paste(i,"Chg",sep="")] <- tbl[x[,i]];
  tbl <- tapply(as.character(x$ae), x[,i], spread);
  tbl[is.na(tbl)] <- 0;
  x[,paste(i,"Nlogin",sep="")] <- tbl[x[,i]]; 
}

fr <- tapply(x$m, x$ae, min, na.rm=T);
x$fr1 <- fr[match(x$ae,names(fr))]; #standardize the fr into one of the 12 months

#######below start calculation by rolling 3-year window month by month
delta <- x[x$fr1>1970 & x$to<2015.963 & x$tt<=131 & x$m<2015.9 & x$m>=2005 & x$ext=="c",];
#delta$m1 <- as.factor(delta$m);
#delta$ae<- as.character(delta$ae);

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
	dvprmod$nchg
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
dd11 <- dd1[2:96,];
dd21 <- dd2[2:96,];
cmtr1 <- cmtr[2:96,];
core1 <- core[2:96,];
modchg1 <- modchg[2:96];

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


png("author2committer.png", width=800,height=600);
 plot(dd21[,1],type="l",ylim=c(1,28),main = "Ratio of authors to committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="ratio")
 lines(dd21[,7],col=2,lty=1)
 lines(dd21[,9],col=3,lty=1)
 lines(dd21[,12],col=4,lty=1)
 lines(dd21[,14],col=5,lty=1)
 lines(dd21[,15],col=6,lty=1)
 lines(dd21[,19],col=7,lty=1)
 legend(60,28,legend=c("arch","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
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


######################end #########################################
#len2*10=nce and nce*10=nae
#the top 80% changes for a particular file/module must be their owners
#sum80 <- function(x){sum(tail(x,2));}


############### below is by-month calculation ####################
delta <- x[x$fr1>1970 & x$to<2015.963 & x$tt<=131,];
delta$m1 <- as.factor(delta$m);
delta$ae<- as.character(delta$ae);

abym <- tapply(delta$ae,delta$m1,spread);
cbym <- tapply(delta$ce,delta$m1,spread);
aloc <- tapply(delta$add,delta$m1,sum);
dloc <- tapply(delta$del,delta$m1,sum);
vbym <- tapply(delta$v,delta$m1,length);
mod8m <- tapply(delta$mod,delta$m1,spread);
f8m <- tapply(delta$ff,delta$m1,spread);
delta$flg <- (delta$to-delta$fr)>=3;
ltc8m <- tapply(delta$ae[delta$tenure==0&delta$flg==1],delta$m1[delta$tenure==0&delta$flg==1],spread); ## new joiners/LTCs
jbym <- tapply(delta$ae,delta$fr1,spread); #new joiners

practice <- data.frame(abym);
practice$m <- dimnames(practice)[[1]];
practice$cbym <- cbym;
practice$aloc <- aloc;
practice$dloc <- dloc;
practice$vbym <- vbym;
practice$mod8m <- mod8m;
practice$f8m <- f8m;
practice$ltc8m <- ltc8m;
practice$jbym <- jbym;

practice$avgchg <- vbym/abym;

moddvp <- table(delta$mod,delta$ae,delta$m);
dvponmod <- apply(moddvp,c(1,3),lennonzero);
modondvp <- apply(moddvp,c(2,3),lennonzero);

non0mean <- function(x){mean(x[x!=0]);}; 
tmp <- apply(dvponmod,2,non0mean); # number of dvprs per module each month
practice$avgdvpofm <- tmp;
tmp <- apply(modondvp,2,non0mean); # number of modules per dvpr each month
practice$avgmofdvp <- tmp;

locadvp <- c();
for(i in names(table(delta$ae)))
{
	tmp <- tapply(delta$add[delta$ae==i],delta$m1[delta$ae==i],sum);
	locadvp <- rbind(locadvp,tmp);
}
avgadd <- apply(locadvp,2,mean,na.rm=T); # number of added lines per dvpr (who touched code) each month
practice$avgadd <- avgadd;

nfdvp <- c();
for(i in names(table(delta$ae)))
{
	tmp <- tapply(delta$ff[delta$ae==i],delta$m1[delta$ae==i],spread);
	nfdvp <- rbind(nfdvp,tmp);
}
avgff <- apply(nfdvp,2,mean,na.rm=T); # number of files per dvpr (who touched code) each month
practice$avgff <- avgff;

ndvpf <- c();
for(i in names(table(delta$ff)))
{
	tmp <- tapply(delta$ae[delta$ff==i],delta$m1[delta$ff==i],spread);
	ndvpf <- rbind(ndvpf,tmp);
}
avgdvpf <- apply(ndvpf,2,mean,na.rm=T); # number of dvprs each file each month
practice$avgdvpf <- avgdvpf;

#the proportion of changes made by the #1 person on that file
nchgf <- c();
delta$ae <- as.factor(delta$ae);
delta$ff <- as.factor(delta$ff);
for(i in names(table(delta$m1)))
{
	tmp <- table(delta$ae[delta$m1==i],delta$ff[delta$m1==i]);
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
png("Chgproportion.png", width=800,height=600);
plot(practice$m,practice$rchg,main = "biggest ratio of changes (average over all files) over time",type="l",xlab="Time (months)",ylab="ratio");
dev.off();


dvponf <- table(delta$ae,delta$ff);
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


png("ratio-linux.png", width=800,height=600);
plot(practice$m,ltc8m/jbym,main = "ratio of LTCs over time",type="l",xlab="Tenure (months)",ylab="ratio");
dev.off();

png("locovertime.png", width=800,height=600);
 plot(practice$m, aloc,ylim=c(1,1e6),main = "Lines of code over time",type="l",xlab="Tenure (months)",ylab="# each month");
 lines(practice$m,dloc,col=2);
 # lines(practice$m,vbym,col=3,lty=2); 
legend(2002, 1e6,legend=c("Lines of added code","Lines of deleted code"),cex=1,lwd=2,col=rep(1:2),bg="white"); 
dev.off();

png("dvprovertime.png", width=800,height=600);
plot(practice$m, practice$abym,main = "# of developers over time",type="l",xlab="Tenure (months)",ylab="# each month");
 lines(practice$m,practice$cbym,col=2);
lines(practice$m,practice$jbym,col=3);
lines(practice$m,practice$ltc8m,col=4);
legend(2010, max(practice$abym)/2,legend=c("# authors","#committers","# joiners","# LTCs"),cex=1,lwd=2,col=rep(1:4),bg="white"); 
dev.off();

png("teamproductivity.png", width=800,height=600);
 plot(practice$m,vbym,main = "# of modules overall over time",type="l",xlab="Tenure (months)",ylab="# each month");
  lines(practice$m,f8m,col=2);
  lines(practice$m,mod8m*100,col=3);
legend(2010, max(vbym),legend=c("# of changes","# of files touched","# of modules touched*100"),cex=1,lwd=2,col=rep(1:3),bg="white"); 
dev.off();


#delta$nmy <- ceiling(delta$tenure+.000001);
ll<-c();
for (i in names(table(delta$tt))) 
 for (j in names(table(as.character(delta$ae)))) 
  ll <- c(ll, paste(i, j)); 

vv <- paste(delta$tt, delta$ae);
vv <- factor(vv, levels=ll);
mnum <- table(vv);
mnum <- data.frame(mnum);
zza <- mnum;
zza$m <- sub(" .*", "", zza$vv);
zza$m1 <- as.double(zza$m);
zza$l <- sub("[^ ]* ", "", zza$vv);
pp<-table(delta$l);
zza$n <- rep(0, dim(zza)[1]);
zza$n <- pp[zza$l];
zza$tod <- ten[zza$l];

names(zza)[2] <- "ndelta"; 
zza <- zza[zza$l!="" & zza$l!="(no author)" & zza$l!="(none)",];
zza$tod <- zza$tod +1; #tenure
zza$ndelta[zza$m1>=zza$tod] <- NA; # set ndelta as NA once it's out of the developer's tenure

nd <- c();
ndd <- c();
for (i in min(zza$m1):max(zza$m1)) {
tmp1 <- length(table(zza$l[zza$m1==i & zza$tod>=(i+1)])); #y axis black - number of developers with tenure of at least m1
nd <- c(nd,tmp1);
tmp2 <- length(table(zza$l[zza$m1==i & zza$tod>=(i+1) & zza$ndelta>0])); # red - number of developers who made delta at tenure m1
ndd <- c(ndd,tmp2);
}

png(paste(pr,"growth.png",sep="."), width=800,height=600);
plot(min(zza$m1):max(zza$m1), nd,type="l",ylim=c(min(nd,ndd),max(nd,ndd)),xlab="Tenure (months)",ylab="# dvprs each month");
#plot(2:max(zza$m1), nd[3:198],type="l",xlab="Tenure (months)",ylab="# dvprs each month");
lines(ndd,col=2);
legend(15, max(nd,ndd)/2,legend=c("# dvprs with tenure of at least m","# dvprs who made delta at tenure m"),cex=1,lwd=2,col=rep(1:2),bg="white"); 
dev.off();




