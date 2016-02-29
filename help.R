setwd("/store1/chenqy/linuxhistory/")
load("./.RData")
save.image(file = "./.RData")

load("/store1/chenqy/linuxhistory/.RData")
library("entropy", lib.loc="~/R/x86_64-redhat-linux-gnu-library/3.1")
library("igraph", lib.loc="~/R/x86_64-redhat-linux-gnu-library/3.1")

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
    # > delta[tsel, 'ae']
    # [1] "" "" ""
    # >
    # > tolower(delta[tsel, 'an'])
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

