
delta <- x[x$fr1>1970 & x$to<2015.963 & x$tt<=131 & x$m<2015.9 & x$m>=2005 & x$ext=="c" &x$mod=="net",];

allmod <- table(as.character(delta$mmod));

dd2 <- data.frame();
dd2 <- rbind(dd2,allmod);
dimnames(dd2)[[2]] <- names(allmod);

cmtr <- data.frame();
cmtr <- rbind(cmtr,allmod);
dimnames(cmtr)[[2]] <- names(allmod);

atr <- data.frame();
atr <- rbind(atr,allmod);
dimnames(atr)[[2]] <- names(allmod);

modchg <- data.frame();
modchg <- rbind(modchg,allmod);
dimnames(modchg)[[2]] <- names(allmod);

#max is the maxium month, min is the minimum month in the rolling window
min <- min(delta$m);
max <- min+3;

while (max<2015.91) {
	p <- delta[delta$m<max & delta$m>=min,]; #& delta$ext=="c",];

	aemod <- table(p$an,p$mmod);
	cemod <- table(p$cn,p$mmod);

	mod <- names(table(p$mmod));
	dvprmod <- data.frame(mod);
	dvprmod$nchg <-tapply(p$v,p$mmod,length);
	dvprmod$nce <- tapply(p$cn,p$mmod,spread);
	dvprmod$nae <- tapply(p$an,p$mmod,spread);
	
	for (j in dvprmod$mod) {
		topdvp <- sort(-cemod[,j]);
		sum80 <- topdvp[1];
		#prop <- -topdvp[1];
		dvpr <- names(topdvp[1]);
	}

	r2 <- dvprmod$nae/dvprmod$nce;
	cmtr <- rbind(cmtr,dvprmod$nce[match(names(cmtr),names(dvprmod$nce))]);
	atr <- rbind(atr,dvprmod$nae[match(names(atr),names(dvprmod$nae))]);  

	dd2 <- rbind(dd2,r2[match(names(allmod),names(r2))]);	
	modchg <- rbind(modchg,dvprmod$nchg[match(names(allmod),dvprmod$mod)]);

	min <- min+1/12;
	max <- min+3;
}

dd21 <- dd2[2:96,]; #remove the first item
cmtr1 <- cmtr[2:96,];
atr1 <- atr[2:96,];
modchg1 <- modchg[2:96,];

#"drivers/net"     "drivers/staging" "drivers/gpu"     "drivers/media"  
# "drivers/usb"     "drivers/scsi"    "drivers/video"   "drivers/acpi"
#
#73 116  37  65 124 106 128   3
 png("committersNET.png", width=800,height=600);
  plot(cmtr1[,26],type="b",ylim=c(0,30),main = "Number of committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="number")
  lines(cmtr1[,27],col=2,lty=1)
  lines(cmtr1[,36],col=3,lty=1)
  lines(cmtr1[,39],col=4,lty=1)
  lines(cmtr1[,9],col=5,lty=1)
  lines(cmtr1[,15],col=6,lty=1)
  lines(cmtr1[,55],col=7,lty=1)
  lines(cmtr1[,52],col=8,lty=2)
  lines(cmtr1[,63],col=9,lty=2)
  legend(55,8,legend=c("ipv4","ipv6","mac80211","netfilter","bluetooth","core","sunrpc","sched","wireless"),cex=1,lwd=2,col=rep(1:9),bg="white");
 dev.off();

png("authors.png", width=800,height=600);
 plot(atr1[,73],type="l",ylim=c(0,5000),main = "Number of authors (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="number")
 lines(atr1[,116],col=2,lty=1)
 lines(atr1[,37],col=3,lty=1)
 lines(atr1[,65],col=4,lty=1)
 lines(atr1[,124],col=5,lty=1)
 lines(atr1[,106],col=6,lty=1)
 lines(atr1[,128],col=7,lty=1)
 legend(20,5000,legend=c("ipv4","ipv6","mac80211","netfilter","bluetooth","core","sunrpc","sched","wireless"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();

postscript("atr2cmtrNET.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
 plot(dd21[,26],type="l",ylim=c(1,28),main = "Ratio of authors to committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="ratio")
 lines(dd21[,27],col=2,lty=2,lwd=2)
 lines(dd21[,36],col=3,lty=3,lwd=2)
 lines(dd21[,39],col=4,lty=4,lwd=2)
 lines(dd21[,9],col=5,lty=5,lwd=2)
 lines(dd21[,15],col=6,lty=6,lwd=2)
 lines(dd21[,55],col=7,lty=7,lwd=2)
 lines(dd21[,52],col=8,lty=8,lwd=2)
 lines(dd21[,63],col=9,lty=9,lwd=2)
 legend(55,28,legend=c("ipv4","ipv6","mac80211","netfilter","bluetooth","core","sunrpc","sched","wireless"),cex=1,lwd=2,col=rep(1:9),lty=rep(1:9),bg="white"); 
dev.off();


#############deal with the first modules touched
#tmp <- tapply(delta$an[delta$fr==delta$ty], delta$mod[delta$fr==delta$ty], spread); #first mod as author

jbyyr <- c();
delta$mod <- as.factor(delta$mod);
for (i in c(2005:2014)) {
	tmp <- tapply(delta$an[delta$fr==delta$ty & delta$y==i], delta$mod[delta$fr==delta$ty& delta$y==i], spread); 
	jbyyr <- cbind(jbyyr,tmp);
}
fryr <- tapply(x$y, x$an, min, na.rm=T);
delta$fryr <- fryr[match(delta$an,names(fryr))]; #standardize the fr into years
tmp <- tapply(delta$an,delta$fryr,spread); #new joiners
tmp <- tmp[5:14];
jbyyr <- rbind(jbyyr,tmp);

tmp<- c(2005:2014)
png("joinerratiobymod.png", width=800,height=600);
plot(tmp,jbyyr[2,]/jbyyr[1,],type="l",ylim=c(0,.65),main = "Ratio of #newcomers over all newcomers over years",xlab="Natural Year",ylab="Ratio")
 lines(tmp,jbyyr[10,]/jbyyr[1,],col=2)
 lines(tmp,jbyyr[11,]/jbyyr[1,],col=3)
 lines(tmp,jbyyr[13,]/jbyyr[1,],col=4)
 lines(tmp,jbyyr[21,]/jbyyr[1,],col=5)
 lines(tmp,jbyyr[26,]/jbyyr[1,],col=6)
 lines(tmp,jbyyr[27,]/jbyyr[1,],col=7)
 lines(tmp,jbyyr[34,]/jbyyr[1,],col=8)
 legend(2006,.45,legend=c("arch","Documentation","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:8),bg="white"); 
dev.off();


delta$fryr <- floor(delta$fr);
delta$fryr <- as.factor(delta$fryr);
jbyyr <- tapply(delta$an,delta$fr1,spread); #new joiners
for (mod in c("drivers","arch","kernel","fs","mm","net","Documentation")) {tmp<-tapply(delta$an[delta$mod==mod],delta$fr1[delta$mod==mod],spread);jbyyr<-rbind(jbyyr,tmp)}; #people touched different modules at the same year/month

plot(c(2005:2015),jbyyr[2,][5:15]/jbyyr[1,][5:15],type="l",ylim=c(0,.8),main = "# newcomers over years",xlab="Natural Year",ylab="# of newcomers")
 lines(c(2005:2015),jbyyr[3,][5:15]/jbyyr[1,][5:15],col=2)
 lines(c(2005:2015),jbyyr[4,][5:15]/jbyyr[1,][5:15],col=3)
 lines(c(2005:2015),jbyyr[5,][5:15]/jbyyr[1,][5:15],col=4)
 lines(c(2005:2015),jbyyr[6,][5:15]/jbyyr[1,][5:15],col=5)
 lines(c(2005:2015),jbyyr[7,][5:15]/jbyyr[1,][5:15],col=6)
 lines(c(2005:2015),jbyyr[8,][5:15]/jbyyr[1,][5:15],col=7)
 legend(2006,.65,legend=c("drivers","arch","kernel","fs","mm","net","Documentation"),cex=1,lwd=2,col=rep(1:7),bg="white"); 



