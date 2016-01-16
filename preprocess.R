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
startdate <- 2005
enddate <- 2015.917

## read data
x <- read.table("linux.l2", sep=";",comment.char="", quote="",
	col.names=c("v","an","cn","ae","ce","line","at","ct","f","cmt"),
	colClasses=c(rep("character", 6), rep("integer", 2), rep('character', 2)));

## merge aliases with full dataset using Python
write.table(data.frame(e=c(x$ae, x$ce), n=c(x$an, x$cn)), file="./e.n.full", 
    row.names = F, col.names = F)
### merging using python
t<-read.csv("all.aliase.id.networkx.full", header=F, col.names=c('als', 'id'))
idmp<-as.character(t[,2])
names(idmp)<-t[,1]
x$cid<-idmp[tolower(x$ce)]
tsel<-which(is.na(x$cid))
#### see nothing in tsel
x$aid<-idmp[tolower(x$ae)]
tsel<-which(is.na(x$aid))
	# > x[tsel, 'ae']
	# [1] ""                                   ""
	# [3] ""                                   ""
	# [5] "Signed-off-by@vergenet.net\":Simon" ""
	# > tolower(x[tsel, 'an'])
	# [1] "craig markwardt"                     "jiayingz@google.com (jiaying zhang)"
	# [3] "jiayingz@google.com (jiaying zhang)" "solofo.ramangalahy@bull.net"
	# [5] "signed-off-by@vergenet.net\":simon"  ""
x$aid[tsel[1]]<-idmp["craig markwardt"]
x$aid[tsel[2]]<-idmp['jiayingz@google.com']
x$aid[tsel[3]]<-idmp['jiayingz@google.com']
x$aid[tsel[4]]<-idmp['solofo.ramangalahy@bull.net']
x$aid[tsel[5]]<-"signed-off-by@vergenet.net\":simon"
x$aid[tsel[6]]<-''
#### drop delta that has no author
x <- x[x$aid != '', ]


## get LOC of add, del
x$add <- sub(":.*$","",x$line,perl=T,useBytes=T);
x$del <- sub("^.*:","",x$line,perl=T,useBytes=T);
x$add <- as.integer(x$add);
x$del <- as.integer(x$del);

## remove useless column
x$line <- NULL

## time
x$y <- floor(x$at/3600/24/365.25)+1970;
x$q <- floor(x$at/3600/24/365.25*4)/4+1970;
x$m <- floor(x$at/3600/24/365.25*12)/12+1970;
x$ty<-x$at/3600/24/365.25+1970;
tmin <- tapply(x$ty, x$aid, min, na.rm=T);
x$fr <- tmin[x$aid]
tmax <- tapply(x$ty, x$aid, max, na.rm=T);
x$to <- tmax[x$aid]
x$tenure <- x$ty-x$fr;
x$tt <- ceiling((x$tenure+.000001)*12); # tenure months, .000001 is used to spare, e.g., one delta people
### round month
x$m <- round(x$m, digits=3)

### LTC
x$contr3y <- (x$to-x$ty>=3) # still contrbuting 3 years later
x$contr3y[x$ty > (enddate - 3)] <- NA

## file's extension and modules
x$ff<-sub(".*/","",x$f,perl=T,useBytes=T);
x$ext<-tolower(sub(".*\\.","",x$ff,perl=T,useBytes = T)); 
x$mod <- sub("/.*", "",x$f,perl=T,useBytes=T); # first module
x$mmod<-sub("^([^/]*/[^/]*)/.*","\\1", x$f, perl=T,useBytes=T); # second module
x$smod<-sub("^([^/]*/[^/]*/[^/]*)/.*","\\1", x$f, perl=T,useBytes=T); # 3rd module
x$fm<-sub("/[^/]*$","", x$f, perl=T,useBytes=T);

## select deltas that we care
delta <- x[x$m>=startdate & x$m<=enddate & x$ext=="c",];
