gnpath <- '/store1/code/gnome20160407/log/'
gnpath <- '/store1/chenqy/linuxhistory/gnome/'
datapath <- gnpath
gnprojects <- c('epiphany', 'evolution', 'gedit', 'gimp', 'gtk+', 'nautilus')

# 291125:fceee99ec164;
# idx <- 1
# idx <- idx + 1
# p <- gnprojects[idx]
# t <- read.table(paste(gnpath,p,sep=''), sep=";",quote='\"',
#     col.names=c("v","an","ae",'at',"cn","ce",'ct'), fill=F,
#     stringsAsFactors=F,
#     colClasses=c(rep("character", 3),'integer',rep("character", 2),'integer'));
# t$prj <- p
# #gn <- t
# gn <- rbind.data.frame(gn, t)

gn <- data.frame(v=character(0))
for (p in gnprojects){
	t <- read.table(paste(gnpath,p,'.l1',sep=''), sep=";",quote='',
	    col.names=c("v","an","ae",'at',"cn","ce",'ct','add','del','f'), fill=F,
	    stringsAsFactors=F,
	    colClasses=c(rep("character", 3),'integer',rep("character", 2),'integer'));
	t$prj <- p
	if (nrow(gn) == 0) gn <- t
	else gn <- rbind.data.frame(gn, t)
}

gn$ff<-sub(".*/","",gn$f,perl=T,useBytes=T);
gn$ext<-tolower(sub(".*\\.","",gn$ff,perl=T,useBytes = T));
gn$mod <- sub("/.*", "",gn$f,perl=T,useBytes=T); # first module
gn$mmod<-sub("^([^/]*/[^/]*)/.*","\\1", gn$f, perl=T,useBytes=T); # second module
gn$smod<-sub("^([^/]*/[^/]*/[^/]*)/.*","\\1", gn$f, perl=T,useBytes=T); # 3rd module
gn$fm<-sub("/[^/]*$","", gn$f, perl=T,useBytes=T);

#write.table(data.frame(n=c(gn$an, gn$cn), e=c(gn$ae, gn$ce)),
#    file="gn.name.email", row.names=F, col.names=F)

t<-read.csv("./gnome.all.aliase.id.networkx.full", header=F, col.names=c('als', 'id'))
gnidmp<-as.character(t[,2])
names(gnidmp)<-t[,1]
gnidmp[which(gnidmp=='al')] <- 'al viro'

gn$aid <- gnidmp[tolower(gn$ae)]
tsel <- which(is.na(gn$aid))
gn$aid[tsel] <- gnidmp[tolower(gn$an[tsel])]
tsel <- which(is.na(gn$aid))
gn$aid[tsel] <- tolower(gn$ae[tsel])

gn$cid <- gnidmp[tolower(gn$ce)]
tsel <- which(is.na(gn$cid))
gn$cid[tsel] <- gnidmp[tolower(gn$cn[tsel])]
tsel <- which(is.na(gn$cid))
gn$cid[tsel] <- tolower(gn$ce[tsel])

gn$y <- floor(gn$at/3600/24/365.25)+1970;
gn$q <- floor(gn$at/3600/24/365.25*4)/4+1970;
gn$m <- floor(gn$at/3600/24/365.25*12)/12+1970;
gn$ty<-gn$at/3600/24/365.25+1970;
tmin <- tapply(gn$ty, gn$aid, min, na.rm=T);
gn$fr <- tmin[gn$aid]
tmax <- tapply(gn$ty, gn$aid, max, na.rm=T);
gn$to <- tmax[gn$aid]
gn$tenure <- gn$ty-gn$fr;
gn$tt <- ceiling((gn$tenure+.000001)*12); # tenure months, .000001 is used to spare, e.

### LTC
gn$contr3y <- (gn$to-gn$ty>=3) # still contrbuting 3 years later
gn$contr3y[gn$ty > (max(gn$cty) - 3)] <- NA

delta <- gn[gn$ext %in% c('c','cpp'), ]

gnrtc <- list() # ratio
gnncc <- list() # num of cmtrs

for (i in 1:length(gnprojects)) {
	prj <- gnprojects[i]
	st <- 2005
	ed <- st + 3
	x <- y <- c()
	while(ed <= 2015.92) {
		tsel <- delta$prj == prj & delta$m >= st & delta$m < ed
        m <- as.character(st)
        y[m] <- numOfUnique(delta$cid[tsel])
        x[m] <- numOfUnique(delta$aid[tsel]) / y[m]
        st <- st + 1/12
        ed <- st + 3
	}
	gnrtc[[prj]] <- x
	gnncc[[prj]] <- y
}
pdf('./a2c-in-gnome.pdf', width=8,height=6, onefile=FALSE, paper = "special")
col <- 1:length(gnprojects)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(1, 5),
     main='Ratio of # authors to # committers (in 3-year period) over time',
     xlab='Moving from Jan 2005 by month', ylab='Ratio')
for (i in 1:length(col)) lines(as.numeric(names(gnrtc[[i]])), gnrtc[[i]], col=col[i], type='l', lwd=2, lty=i)
legend(2006, 5, legend=gnprojects,cex=1,lwd=2,lty=1:length(col),
       col=col ,bg="white");
# for (i in 1:length(col)) lines(as.numeric(names(rt[[i]])), rt[[i]], col=col[i], type='l', lty=2)
# legend(2007, 27, legend=gnprojects,cex=1,lwd=1, lty=2,
#     col=col ,bg="white",title='keep fake cmtrs');
dev.off()


for (i in 1:len(gnprojects)) {
	p=gnprojects[i];
	sel <- gn$prj == p;

	na <- tapply(gn$aid[sel], gn$y[sel], nu);
	nc <- tapply(gn$cid[sel], gn$y[sel], nu);

	if(i==0) {
    	plot(as.numeric(names(na)), na/nc, col=i,ylim=c(0, 2)) ;
    } else {
    	lines(as.numeric(names(na)), na/nc, col=i);
    }
}