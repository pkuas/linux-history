mtnr <- read.table('/store1/chenqy/linuxhistory/maintainers-df',
    sep=";",comment.char="", quote="",
    col.names=c("name","area","me",'mn','status','filelist','doclist','numWordDoc','loc'),
    colClasses=c(rep("character", 7), rep('integer', 2)));
t1 <- strsplit(mtnr$me, ', ')
t2 <- lapply(t1, function(x){
    return(numOfUnique(idmp[x]))
    })
mntr$numMtnr <- unlist(t2)
write.table(mtnr, file='/store1/chenqy/linuxhistory/maintainers-df.csv',
    row.names = FALSE, col.names = TRUE, sep=';', quote=FALSE)

mtnr <- read.table('/store1/chenqy/linuxhistory/maintainers-df.csv',
    sep=";",comment.char="", quote="", header=TRUE,
    #col.names=c("name","area","me",'mn','status','filelist','doclist','numWordDoc','loc','numMtnr'),
    colClasses=c(rep("character", 7), rep('integer', 3)));
