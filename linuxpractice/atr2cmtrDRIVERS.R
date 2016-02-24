

delta <- x[x$fr1>1970 & x$to<2015.963 & x$tt<=131 & x$m<2015.9 & x$m>=2005 & x$ext=="c" &x$mod=="drivers",];

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

png("committers.png", width=800,height=600);
 plot(cmtr1[,73],type="l",ylim=c(0,250),main = "Number of committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="number")
 lines(cmtr1[,116],col=2,lty=2,lwd=2)
 lines(cmtr1[,37],col=3,lty=3,lwd=2)
 lines(cmtr1[,65],col=4,lty=4,lwd=2)
 lines(cmtr1[,124],col=5,lty=5,lwd=2)
 lines(cmtr1[,106],col=6,lty=6,lwd=2)
 lines(cmtr1[,128],col=7,lty=7,lwd=2)
 lines(cmtr1[,3],col=8,lty=8,lwd=2)
 legend(20,250,legend=c("arch","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();

png("authors.png", width=800,height=600);
 plot(atr1[,73],type="l",ylim=c(0,5000),main = "Number of authors (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="number")
 lines(atr1[,116],col=2,lty=1)
 lines(atr1[,37],col=3,lty=1)
 lines(atr1[,65],col=4,lty=1)
 lines(atr1[,124],col=5,lty=1)
 lines(atr1[,106],col=6,lty=1)
 lines(atr1[,128],col=7,lty=1)

 legend(20,5000,legend=c("arch","drivers","fs","kernel","mm","net","sound"),cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();

postscript("atr2cmtrDRIVERS.eps", width=10,height=6,horizontal=FALSE, onefile=FALSE, paper = "special");
 plot(dd21[,73],type="l",ylim=c(1,28),main = "Ratio of authors to committers (in 3-year period) over time",xlab="Moving from Jan 2005 by month",ylab="ratio")
 lines(dd21[,116],col=2,lty=2,lwd=2)
 lines(dd21[,37],col=3,lty=3,lwd=2)
 lines(dd21[,65],col=4,lty=4,lwd=2)
 lines(dd21[,124],col=5,lty=5,lwd=2)
 lines(dd21[,106],col=6,lty=6,lwd=2)
 lines(dd21[,128],col=7,lty=7,lwd=2)
 lines(dd21[,3],col=8,lty=8,lwd=2)
 legend(60,28,legend=c("net","staging","gpu","media","usb","scsi","video","acpi"),cex=1,lwd=2,col=rep(1:8),lty=rep(1:8),bg="white"); 
dev.off();



#len2*10=nce and nce*10=nae
#the top 80% changes for a particular file/module must be their owners
#sum80 <- function(x){sum(tail(x,2));}

#############deal with the first modules touched

				drivers/char          drivers/acpi 
                 	               8567                  8797 
        drivers/video          drivers/scsi           drivers/usb 
                10489                 21025                 22839 
        drivers/media           drivers/gpu       drivers/staging 
                38783                 39502                 64754 
          drivers/net 
                93561 

"drivers/net"     "drivers/staging" "drivers/gpu"     "drivers/media"  
[5] "drivers/usb"     "drivers/scsi"    "drivers/video"   "drivers/acpi"
#drivercor <- rbind(drivercor,cor(tmp[,7],tmp[,c(1,6,7,9,12,14,15,19)]));
#	min <- min+1/12;
#	max <- min+3;
#}
[1] "arch"          "block"         "certs"         "crypto"       
 [5] "dir.c"         "Documentation" "drivers"       "firmware"     
 [9] "fs"            "init"          "ipc"           "kernel"       
[13] "lib"           "mm"            "net"           "samples"      
[17] "scripts"       "security"      "sound"         "tools"        
[21] "usr"           "virt"  


