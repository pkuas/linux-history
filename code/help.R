setwd("/store1/chenqy/linuxhistory/")
load("./.RData")
save.image(file = "./.RData")

load("/store1/chenqy/linuxhistory/.RData")
library("igraph", lib.loc="~/R/x86_64-redhat-linux-gnu-library/3.1")
library(Hmisc)
library(ineq)
library('lsa')
library(stringr)
library("entropy", lib.loc="~/R/x86_64-redhat-linux-gnu-library/3.1")
library(scatterplot3d)

t1 <- tapply(delta$tenure[sel], delta$cvsn[sel], numOfZero)
t2 <- tapply(delta$ftenure[sel], delta$cvsn[sel], numOfZero)

#/store1/chenqy/linuxhistory/linux
# check mapping between email and name
numOfUnique<-function(x) {return(length(unique(x)))}
numAnamePerAemail <- tapply(delta$an, delta$ae, numOfUnique)
numAemailPerAname <- tapply(delta$ae, delta$an, numOfUnique)

# map emails and namey to namex
tsel <- delta$ce!=""
cn2ce <- tapply(delta$cn[tsel], delta$ce[tsel], unique)



idname.mp<-c('^###$')
numdeltas<-dim(delta)[1]
for (i in 601787:numdeltas){
    if (!is.na(idname.mp[delta$ae[i]])){
        idname.mp[delta$an[i]]<-idname.mp[delta$ae[i]]
    } else {
        tname<-delta$an[i]
        if (is.na(idname.mp[tname])){
            idname.mp[delta$ae[i]] <- tname
            idname.mp[tname] <- tname
        } else {
            while(idname.mp[tname] != tname){
                tname <- idname.mp[tname]
            }
            idname.mp[delta$ae[i]] <- tname
            idname.mp[delta$an[i]] <- tname
        }
    }
}
t<-idname.mp[names(idname.mp)!=""]
tsel<-which(t=='')
t[tsel]<-names(tsel)
idname.mp<-t
returnfunc<-function(x) {return(x)}
aliasofname<-tapply(names(idname.mp), idname.mp, returnfunc)
numofaliasofname<-tapply(names(idname.mp), idname.mp, length)
write.table(data.frame(alias=names(idname.mp), id=idname.mp), file="alias.id", row.names=F, col.names=F)
delta$aid<-idname.mp[delta$ae]
# manually inspect, only 3 is na
tsel<-which(is.na(delta$aid))
delta$aid[tsel] <- delta$an[tsel]

delta$cid<-idname.mp[delta$ce]
tsel<-which(is.na(delta$cid))
delta$cid[tsel] <- delta$cn[tsel]
tsel<-which(is.na(delta$cid))

######################
# I have done this work using Python
t<-read.csv("/store1/chenqy/linuxhistory/all.aliase.id.networkx.full", header=F, col.names=c('als', 'id'))
idmp<-as.character(t[,2])
names(idmp)<-t[,1]

delta$cid<-idmp[tolower(delta$ce)]
tsel<-which(is.na(delta$cid))

delta$aid<-idmp[tolower(delta$ae)]
tsel<-which(is.na(delta$aid))
    # delta[tsel, 'ae']
    # [1] "" "" ""
    # >
    # tolower(delta[tsel, 'an'])
    # [1] "jiayingz@google.com (jiaying zhang)" "solofo.ramangalahy@bull.net"
    # [3] "
delta$aid[tsel[1]]<-idmp['jiayingz@google.com']
delta$aid[tsel[2]]<-idmp['solofo.ramangalahy@bull.net']
delta$aid[tsel[3]]<-''

# aliases usage
numofaliasofid <- tapply(names(idmp), idmp, length)
numofaliasofid.tb <- table(numofaliasofid)
numofaliasofid.tb / sum(numofaliasofid.tb)

# merge aliases with full dataset
t<-read.table("./linux.l2", sep=";",comment.char="", quote="",
    col.names=c("v","an","cn","ae","ce","line","at","ct","f","cmt"),
    colClasses= c("NULL", rep("character", 4), rep("NULL", 5)))
# t<-transform(t, an=tolower(an), ae=tolower(ae), cn=tolower(cn), ce=tolower(ce))
write.table(data.frame(e=c(t$ae, t$ce), n=c(t$an, t$cn)), file="./e.n.full",
    row.names = F, col.names = F)

# draw a directory tree



sel <- delta$mmod %in% c('drivers/android', 'drivers/bluetooth', 'drivers/cpufreq', 'arch/ia64', 'arch/powerpc', 'archk/m68k', 'arch/microblaze', 'arch/mips')
tsel <- sel & delta$ty >= 2014
tapply((1:numofdeltas)[tsel], delta$mmod[tsel], function(x) {a <- numOfUnique(delta$aid[x]); c <- numOfUnique(delta$cid[x]); aa <- exp(entropy(table(delta$aid[x]))); ac<-exp(entropy(table(delta$cid[x]))); return(round(c(a, c, aa, ac, a/aa, c/ac, a/c, aa/ac), 2))})

getIdNameOrEmail <- function(uid, type='email') {
    if (length(uid) > 1) return(unlist(Map(getIdNameOrEmail, uid, type)))
    sel <- idmp == uid
    nms <- names(idmp[sel])
    idx <- grep('@', nms)
    idx <- c(idx, grep(' at ', nms))
    if (type=='email' & length(idx) >= 1) {
        return(nms[idx[1]])
    }
    i <- 1:length(nms)
    i <- i[-idx]
    return(ifelse(length(i) >= 1, nms[i[1]], nms[1]))
}