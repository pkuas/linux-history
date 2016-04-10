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

