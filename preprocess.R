# Copied from process.r
first <- function(x){sort(x)[1];}; 
spread <- function(x){ length(table(as.character(x))); };
lennonzero <- function(x){ length(x[x!=0]); };
numOfUnique<-function(x) {return(length(unique(x)))}

## read data
x <- read.table("linux.l2", sep=";",comment.char="", quote="",col.names=c("v","an","cn","ae","ce","line","at","ct","f","cmt"));

## get LOC of add, del
x$add <- sub(":.*$","",x$line,perl=T,useBytes=T);
x$del <- sub("^.*:","",x$line,perl=T,useBytes=T);
x$add <- as.integer(x$add);
x$del <- as.integer(x$del);

## time
x$y <- floor(x$at/3600/24/365.25)+1970;
x$q <- floor(x$at/3600/24/365.25*4)/4+1970;
x$m <- floor(x$at/3600/24/365.25*12)/12+1970;
x$ty<-x$at/3600/24/365.25+1970;
tmin <- tapply(x$ty, x$ae, min, na.rm=T);
x$fr <- tmin[x$ae]
tmax <- tapply(x$ty, x$ae, max, na.rm=T);
x$to <- tmax[x$ae]
x$tenure <- x$ty-x$fr;
x$tt <- ceiling((x$tenure+.000001)*12); # tenure months, .000001 is used to spare, e.g., one delta people

## file's extension and modules
x$ff<-sub(".*/","",x$f,perl=T,useBytes=T);
x$ext<-tolower(sub(".*\\.","",x$ff,perl=T,useBytes = T)); 
x$mod <- sub("/.*", "",x$f,perl=T,useBytes=T); # first module
x$mmod<-sub("^([^/]*/[^/]*)/.*","\\1", x$f, perl=T,useBytes=T); # second module
x$smod<-sub("^([^/]*/[^/]*/[^/]*)/.*","\\1", x$f, perl=T,useBytes=T); # 3rd module
x$fm<-sub("/[^/]*$","", x$f, perl=T,useBytes=T);

## use already-merged id, please see help.R
# delta$cid<-idmp[tolower(delta$ce)]
# tsel<-which(is.na(delta$cid))
# delta$aid<-idmp[tolower(delta$ae)]
# tsel<-which(is.na(delta$aid))


# number of Changes/Logins in each module/smod/file
for (i in c("mod","smod","ff")){
  tbl <- table (x[,i]);
  x[,paste(i,"Chg",sep="")] <- tbl[x[,i]];
  tbl <- tapply(as.character(x$ae), x[,i], spread);
  tbl[is.na(tbl)] <- 0;
  x[,paste(i,"Nlogin",sep="")] <- tbl[x[,i]]; 
}

fr <- tapply(x$m, x$ae, min, na.rm=T);
#x$fr1 <- fr[match(x$ae,names(fr))]; #standardize the fr into one of the 12 months
x$fr1 <- fr[x$ae]
#######below start calculation by rolling 3-year window month by month
delta <- x[x$fr1>1970 & x$to<2015.963 & x$tt<=131 & x$m<2015.9 & x$m>=2005 & x$ext=="c",];
#delta$m1 <- as.factor(delta$m);
#delta$ae<- as.character(delta$ae);
