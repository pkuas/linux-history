# check mapping between email and name
numOfUnique<-function(x) {return(length(unique(x)))}
numAnamePerAemail <- tapply(delta$an, delta$ae, numOfUnique)
numAemailPerAname <- tapply(delta$ae, delta$an, numOfUnique)

# map emails and namey to namex
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
delta$aid<-idname.mp[delta$an]
delta$cid<-idname.mp[delta$cn]

