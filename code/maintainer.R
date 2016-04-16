maintainer <- read.table('/store1/chenqy/linuxhistory/file-maintainers',
    sep=",",comment.char="", quote="",
    col.names=c("file","mn","me"),
    colClasses=c(rep("character", 3)));

maintainer$mid <- idmp[tolower(maintainer$me)]

maintainer$mod <- sub("/.*", "", maintainer$file,perl=T,useBytes=T); # first module
maintainer$mod[maintainer$file == '*/*/*/vexpress*'] <- '*vexpress*'
maintainer$mod[maintainer$file == '*/*/vexpress*'] <- '*vexpress*'

tsel <- delta$m >= 2014.916

tc <- tapply(delta$cid[tsel], delta$mod[tsel], unique)
tm <- tapply(maintainer$mid, maintainer$mod, unique)

for (m in mods) {
    t <- tc[[m]]
    t <- t[t %in% truecmtr]
    t <- t[!t %in% tm[[m]]]
    t <- t[t != 'linus torvalds']
    print(m)
    print(t)
}
