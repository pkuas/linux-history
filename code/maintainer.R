maintainer <- read.table('/store1/chenqy/linuxhistory/file-maintainers',
    sep=",",comment.char="", quote="",
    col.names=c("file","mn","me"),
    colClasses=c(rep("character", 3)));

maintainer$mid <- idmp[tolower(maintainer$me)] 
tsel <- which(is.na(maintainer$mid))	# there are some NAs
maintainer$mid[tsel] <- idmp[tolower(maintainer$mn[tsel])]
tsel <- which(is.na(maintainer$mid))
maintainer$mid[tsel] <- tolower(maintainer$mn[tsel])


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

# 不区分maintainer为哪个模块的maintainer，而把其当作整个系统的maintainer
mt <- unique(maintainer$mid)
for (m in mods) {
	t <- tc[[m]]
	t <- t[t %in% truecmtr]
	t <- t[!t %in% mt]
	t <- t[t != 'linus torvalds']
	#t1 <- getIdNameOrEmail(t, 'email')
	#names(t1) <- getIdNameOrEmail(t, 'name')
	print(m)
	print(t)
}
t <- unique(unlist(tc))
t <- t[t %in% truecmtr]
t <- t[!t %in% mt]
t <- t[t != 'linus torvalds']
print(t)

