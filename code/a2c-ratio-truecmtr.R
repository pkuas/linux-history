# detect those cmtrs committing code only for himself, because there are two ways of getting
#: code in master repo: email patch and pull request
t <- tapply(delta$aid, delta$cid, unique)
truecmtr <- names(t)
tsel <- rep(TRUE, length(t))
for (i in 1:length(t)) {
    if (length(t[[i]]) == 1 & t[[i]][1] == truecmtr[i]) tsel[i] <- FALSE
}
truecmtr <- truecmtr[tsel]


# (core) ratio of a2c & ratio
mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
trt <- list() # ratio
tnc <- list() # num of cmtrs
tcrt <- list() # core ratio
tcnc <- list() # num of core cmtrs
tert <- list() # entropy ratio
tenc <- list() # entropy

for (i in 1:length(mods)) {
	mod <- mods[i]
	st <- 2005
	ed <- st + 3
	x <- y <- c()
    cx <- cy <- c()
    ex <- ey <- c()
	while(ed <= 2015.917) {
		tsel <- delta$mod == mod & delta$m >= st & delta$m < ed
        m <- as.character(st)
		t1 <- sort(table(delta$cid[tsel]), decreasing=T)
        t1 <- t1[names(t1) %in% truecmtr]
		t2 <- sort(table(delta$aid[tsel]), decreasing=T)
        y[m] <- length(t1)
        x[m] <- length(t2) / y[m]
        ey[m] <- 2 ** entropy(t1, method='ML', unit='log2')
        ex[m] <- 2 ** entropy(t2, method='ML', unit='log2') / ey[m]
		t1 <- sum(c(TRUE, cumsum(t1[-length(t1)]) / sum(t1) <= 0.8))
		t2 <- sum(c(TRUE, cumsum(t2[-length(t2)]) / sum(t2) <= 0.8))
		cx[m] <- t2 / t1
		cy[m] <- t1
		st <- st + 1/12
		ed <- st + 3
	}
	trt[[mod]] <- x
	tnc[[mod]] <- y
    tcrt[[mod]] <- cx
    tcnc[[mod]] <- cy
    tert[[mod]] <- ex
    tenc[[mod]] <- ey

}
# #A to # e C
ta2ec <- list()
for (i in 1:length(mods)) {
    mod <- mods[i]
    ta2ec[[mod]] <- tnc[[mod]] * trt[[mod]] / tenc[[mod]]
}

#png('a2c-mod')
png('./ratio-in-mod.png', width=800, height=600)
pdf('./a2c-in-mod.pdf', width=8,height=6, onefile=FALSE, paper = "special")
col <- 1:length(mods)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, max(trt$drivers)),
    main='Ratio of # authors to # committers (in 3-year period) over time',
    xlab='Moving from Jan 2005 by month', ylab='Ratio')
for (i in 1:length(col)) lines(as.numeric(names(trt[[i]])), trt[[i]], col=col[i], type='l', lwd=2, lty=i)
legend(2010, 28, legend=mods,cex=1,lwd=2,lty=1:length(col),
    col=col ,bg="white");
# for (i in 1:length(col)) lines(as.numeric(names(rt[[i]])), rt[[i]], col=col[i], type='l', lty=2)
# legend(2007, 27, legend=mods,cex=1,lwd=1, lty=2,
#     col=col ,bg="white",title='keep fake cmtrs');
dev.off()

plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 40),
    main='Ratio of # core authors to # core committers (in 3-year period)',
    xlab='natural month', ylab='ratio')
col <- 1:length(mods)
for (i in 1:length(col)) lines(as.numeric(names(tcrt[[i]])), tcrt[[i]], col=col[i], type='l')
legend(2009, 40, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");

png('./eratio-in-mod.png', width=800, height=600)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 35),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
for (i in 1:length(col)) lines(as.numeric(names(tert[[i]])), tert[[i]], col=col[i], type='l')
legend(2009, 35, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");
for (i in 1:length(col)) lines(as.numeric(names(tert[[i]])), tert[[i]], col=col[i], type='l', lty=2)
legend(2007, 27, legend=mods,cex=1,lwd=1, lty=2,
    col=col ,bg="white",title='keep fake cmtrs');
dev.off()

## inflastion of athr
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 16),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
col <- 1:length(mods)
for (i in 1:length(col)) {
    mod <- mods[i]
    x <- rt[[mod]] * nc[[mod]] / (ert[[mod]] * enc[[mod]])
    lines(as.numeric(names(x)), x, col=col[i], type='l')
}
legend(2009, 16, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");

## inflastion of cmtr
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 22),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
col <- 1:length(mods)
for (i in 1:length(col)) {
    mod <- mods[i]
    x <-  nc[[mod]] / ( enc[[mod]])
    lines(as.numeric(names(x)), x, col=col[i], type='l')
}
legend(2007, 22, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");



# year as window
yrt <- list() # ratio
ync <- list() # num of cmtrs
#ycrt <- list() # core ratio
#ycnc <- list() # num of core cmtrs
yert <- list() # entropy ratio
yenc <- list() # entropy

for (i in 1:length(mods)) {
    mod <- mods[i]
    tsel <- delta$mod == mod
    ync[[mod]] <- tapply(delta$cid[tsel], delta$y[tsel], numOfUnique)
    yrt[[mod]] <- tapply(delta$aid[tsel], delta$y[tsel], numOfUnique) / ync[[mod]]
    tf <- function(x) {exp(entropy(table(x)))}
    yenc[[mod]] <- tapply(delta$cid[tsel], delta$y[tsel], tf)
    yert[[mod]] <- tapply(delta$aid[tsel], delta$y[tsel], tf) / yenc[[mod]]

}
plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, 35),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
col <- 1:length(mods)
for (i in 1:length(col)) lines(as.numeric(names(yrt[[i]])), yrt[[i]], col=col[i], type='l')
legend(2009, 35, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");

plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, 35),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
col <- 1:length(mods)
for (i in 1:length(col)) lines(as.numeric(names(yert[[i]])), yert[[i]], col=col[i], type='l')
legend(2009, 35, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");

# arch

fsmods <- c("fs/xfs", "fs/btrfs", "fs/nfs", "fs/cifs", "fs/ext4", "fs/ocfs2", "fs/gfs2",
    "fs/nfsd", "fs/f2fs", "fs/ceph", "fs/proc", "fs/reiserfs")

mrt <- list() # ratio
mnc <- list() # num of cmtrs
mcrt <- list() # core ratio
mcnc <- list() # num of core cmtrs
mert <- list() # entropy ratio
menc <- list() # entropy

for (i in 1:length(fsmods)) {
    mod <- fsmods[i]
    st <- 2005
    ed <- st + 3
    x <- y <- c()
    cx <- cy <- c()
    ex <- ey <- c()
    while(ed <= 2015.917) {
        tsel <- delta$mmod == mod & delta$m >= st & delta$m < ed
        m <- as.character(st)
        t1 <- sort(table(delta$cid[tsel]), decreasing=T)
        t2 <- sort(table(delta$aid[tsel]), decreasing=T)
        y[m] <- length(t1)
        x[m] <- length(t2) / y[m]
        ey[m] <- 2 ** entropy(t1, method='ML', unit='log2')
        ex[m] <- 2 ** entropy(t2, method='ML', unit='log2') / ey[m]
        t1 <- sum(c(TRUE, cumsum(t1[-length(t1)]) / sum(t1) <= 0.8))
        t2 <- sum(c(TRUE, cumsum(t2[-length(t2)]) / sum(t2) <= 0.8))
        cx[m] <- t2 / t1
        cy[m] <- t1
        st <- st + 1/12
        ed <- st + 3
    }
    mrt[[mod]] <- x
    mnc[[mod]] <- y
    mcrt[[mod]] <- cx
    mcnc[[mod]] <- cy
    mert[[mod]] <- ex
    menc[[mod]] <- ey

}
#png('a2c-mod')
png('./ratio-in-fs.png', width=800, height=600)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 15),
    main='Ratio of # authors to # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
tplt <- 1:5
col <- 1:length(fsmods)
for (i in tplt) lines(as.numeric(names(mrt[[i]])), mrt[[i]], col=col[i], type='l')
legend(2009, 15, legend=fsmods[tplt],cex=1,lwd=1,
    col=col ,bg="white");
dev.off()

plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 40),
    main='Ratio of # core authors to # core committers (in 3-year period)',
    xlab='Natural month', ylab='ratio')
for (i in 1:length(col)) lines(as.numeric(names(crt[[i]])), crt[[i]], col=col[i], type='l')
legend(2009, 40, legend=fsmods,cex=1,lwd=1,
    col=col ,bg="white");

png('./eratio-in-fs.png', width=800, height=600)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 25),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period) in fs',
    xlab='Natural month', ylab='Ratio')
tplt <- 1:5
col <- 1:length(fsmods)
for (i in tplt) lines(as.numeric(names(mert[[i]])), mert[[i]], col=col[i], type='l')
legend(2007, 26, legend=fsmods[tplt],cex=1,lwd=1,
    col=col ,bg="white");
dev.off()

# fs

fsmods <- c("fs/xfs", "fs/btrfs", "fs/nfs", "fs/cifs", "fs/ext4", "fs/ocfs2", "fs/gfs2",
    "fs/nfsd", "fs/f2fs", "fs/ceph", "fs/proc", "fs/reiserfs")

mrt <- list() # ratio
mnc <- list() # num of cmtrs
mcrt <- list() # core ratio
mcnc <- list() # num of core cmtrs
mert <- list() # entropy ratio
menc <- list() # entropy

for (i in 1:length(fsmods)) {
    mod <- fsmods[i]
    st <- 2005
    ed <- st + 3
    x <- y <- c()
    cx <- cy <- c()
    ex <- ey <- c()
    while(ed <= 2015.917) {
        tsel <- delta$mmod == mod & delta$m >= st & delta$m < ed
        m <- as.character(st)
        t1 <- sort(table(delta$cid[tsel]), decreasing=T)
        t2 <- sort(table(delta$aid[tsel]), decreasing=T)
        y[m] <- length(t1)
        x[m] <- length(t2) / y[m]
        ey[m] <- 2 ** entropy(t1, method='ML', unit='log2')
        ex[m] <- 2 ** entropy(t2, method='ML', unit='log2') / ey[m]
        t1 <- sum(c(TRUE, cumsum(t1[-length(t1)]) / sum(t1) <= 0.8))
        t2 <- sum(c(TRUE, cumsum(t2[-length(t2)]) / sum(t2) <= 0.8))
        cx[m] <- t2 / t1
        cy[m] <- t1
        st <- st + 1/12
        ed <- st + 3
    }
    mrt[[mod]] <- x
    mnc[[mod]] <- y
    mcrt[[mod]] <- cx
    mcnc[[mod]] <- cy
    mert[[mod]] <- ex
    menc[[mod]] <- ey

}
#png('a2c-mod')
png('./ratio-in-fs.png', width=800, height=600)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 15),
    main='Ratio of # authors to # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
tplt <- 1:5
col <- 1:length(fsmods)
for (i in tplt) lines(as.numeric(names(mrt[[i]])), mrt[[i]], col=col[i], type='l')
legend(2009, 15, legend=fsmods[tplt],cex=1,lwd=1,
    col=col ,bg="white");
dev.off()

plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 40),
    main='Ratio of # core authors to # core committers (in 3-year period)',
    xlab='Natural month', ylab='ratio')
for (i in 1:length(col)) lines(as.numeric(names(crt[[i]])), crt[[i]], col=col[i], type='l')
legend(2009, 40, legend=fsmods,cex=1,lwd=1,
    col=col ,bg="white");

png('./eratio-in-fs.png', width=800, height=600)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 25),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period) in fs',
    xlab='Natural month', ylab='Ratio')
tplt <- 1:5
col <- 1:length(fsmods)
for (i in tplt) lines(as.numeric(names(mert[[i]])), mert[[i]], col=col[i], type='l')
legend(2007, 26, legend=fsmods[tplt],cex=1,lwd=1,
    col=col ,bg="white");
dev.off()


# drivers
# (core) ratio of a2c & ratio
drtrt <- list() # ratio
drtnc <- list() # num of cmtrs
drtert <- list() # entropy ratio
drtenc <- list() # entropy
for (i in 1:length(drmods)) {
    mod <- drmods[i]
    st <- 2005
    ed <- st + 3
    x <- y <- c()
    cx <- cy <- c()
    ex <- ey <- c()
    while(ed <= 2015.917) {
        tsel <- delta$mmod == mod & delta$m >= st & delta$m < ed
        m <- as.character(st)
        t1 <- sort(table(delta$cid[tsel]), decreasing=T)
        t1 <- t1[names(t1) %in% truecmtr]
        t2 <- sort(table(delta$aid[tsel]), decreasing=T)
        y[m] <- length(t1)
        x[m] <- length(t2) / y[m]
        ey[m] <- 2 ** entropy(t1, method='ML', unit='log2')
        ex[m] <- 2 ** entropy(t2, method='ML', unit='log2') / ey[m]
        t1 <- sum(c(TRUE, cumsum(t1[-length(t1)]) / sum(t1) <= 0.8))
        t2 <- sum(c(TRUE, cumsum(t2[-length(t2)]) / sum(t2) <= 0.8))
        cx[m] <- t2 / t1
        cy[m] <- t1
        st <- st + 1/12
        ed <- st + 3
    }
    drtrt[[mod]] <- x
    drtnc[[mod]] <- y
    drtert[[mod]] <- ex
    drtenc[[mod]] <- ey

}
#png('a2c-mod')
pdf('./a2c-dr.pdf', width=8,height=6, onefile=FALSE, paper = "special")
col <- 1:length(drmods)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 28),
     main='Ratio of # authors to # committers (in 3-year period)',
     xlab='Moving from Jan 2005 by month', ylab='Ratio')
for (i in 1:length(col)) lines(as.numeric(names(drtrt[[i]])), drtrt[[i]], col=col[i], type='l', lwd=2, lty=i)
legend(2009, 28, legend=drmods,cex=1,lwd=2,lty=1:length(col),
       col=col ,bg="white");

dev.off()

# arch
artrt <- list() # ratio
artnc <- list() # num of cmtrs
artert <- list() # entropy ratio
artenc <- list() # entropy

for (i in 1:length(armods)) {
    mod <- armods[i]
    st <- 2005
    ed <- st + 3
    x <- y <- c()
    cx <- cy <- c()
    ex <- ey <- c()
    while(ed <= 2015.917) {
        tsel <- delta$mmod == mod & delta$m >= st & delta$m < ed
        m <- as.character(st)
        t1 <- sort(table(delta$cid[tsel]), decreasing=T)
        t1 <- t1[names(t1) %in% truecmtr]
        t2 <- sort(table(delta$aid[tsel]), decreasing=T)
        y[m] <- length(t1)
        x[m] <- length(t2) / y[m]
        ey[m] <- 2 ** entropy(t1, method='ML', unit='log2')
        ex[m] <- 2 ** entropy(t2, method='ML', unit='log2') / ey[m]
        t1 <- sum(c(TRUE, cumsum(t1[-length(t1)]) / sum(t1) <= 0.8))
        t2 <- sum(c(TRUE, cumsum(t2[-length(t2)]) / sum(t2) <= 0.8))
        cx[m] <- t2 / t1
        cy[m] <- t1
        st <- st + 1/12
        ed <- st + 3
    }
    artrt[[mod]] <- x
    artnc[[mod]] <- y
    artert[[mod]] <- ex
    artenc[[mod]] <- ey

}
#png('a2c-mod')
pdf('./a2c-ar.pdf', width=8,height=6, onefile=FALSE, paper = "special")
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 15),
    main='Ratio of # authors to # committers (in 3-year period)',
    xlab='Moving from Jan 2005 by month', ylab='Ratio')
col <- 1:length(armods)
for (i in 1:length(col)) lines(as.numeric(names(artrt[[i]])), artrt[[i]], col=col[i], type='l', lwd=2, lty=i)
legend(2010, 15, legend=armods,cex=1,lwd=2,lty=1:length(col),
    col=col ,bg="white");
# for (i in 1:length(col)) lines(as.numeric(names(rt[[i]])), rt[[i]], col=col[i], type='l', lty=2)
# legend(2007, 27, legend=mods,cex=1,lwd=1, lty=2,
#     col=col ,bg="white",title='keep fake cmtrs');
dev.off()

# net
netrt <- list() # ratio
netnc <- list() # num of cmtrs
netert <- list() # entropy ratio
netenc <- list() # entropy

for (i in 1:length(nemods)) {
    mod <- nemods[i]
    st <- 2005
    ed <- st + 3
    x <- y <- c()
    cx <- cy <- c()
    ex <- ey <- c()
    while(ed <= 2015.917) {
        tsel <- delta$mmod == mod & delta$m >= st & delta$m < ed
        m <- as.character(st)
        t1 <- sort(table(delta$cid[tsel]), decreasing=T)
        t1 <- t1[names(t1) %in% truecmtr]
        t2 <- sort(table(delta$aid[tsel]), decreasing=T)
        y[m] <- length(t1)
        x[m] <- length(t2) / y[m]
        ey[m] <- 2 ** entropy(t1, method='ML', unit='log2')
        ex[m] <- 2 ** entropy(t2, method='ML', unit='log2') / ey[m]
        t1 <- sum(c(TRUE, cumsum(t1[-length(t1)]) / sum(t1) <= 0.8))
        t2 <- sum(c(TRUE, cumsum(t2[-length(t2)]) / sum(t2) <= 0.8))
        cx[m] <- t2 / t1
        cy[m] <- t1
        st <- st + 1/12
        ed <- st + 3
    }
    netrt[[mod]] <- x
    netnc[[mod]] <- y
    netert[[mod]] <- ex
    netenc[[mod]] <- ey

}
#png('a2c-mod')
pdf('./a2c-ne.pdf', width=8,height=6, onefile=FALSE, paper = "special")
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 28),
    main='Ratio of # authors to # committers (in 3-year period)',
    xlab='Moving from Jan 2005 by month', ylab='Ratio')
col <- 1:length(nemods)
for (i in 1:length(col)) lines(as.numeric(names(netrt[[i]])), netrt[[i]], col=col[i], type='l', lwd=2, lty=i)
legend(2008, 28, legend=nemods,cex=1,lwd=2,lty=1:length(col),
    col=col ,bg="white");
# for (i in 1:length(col)) lines(as.numeric(names(rt[[i]])), rt[[i]], col=col[i], type='l', lty=2)
# legend(2007, 27, legend=mods,cex=1,lwd=1, lty=2,
#     col=col ,bg="white",title='keep fake cmtrs');
dev.off()



# explore foreign cmtrs
ysel <- delta$y >= 2014
df <- list()
for (m in mods) {
    msel <- delta$mod == m
    tsel <- ysel & msel
    x <- sort(table(delta$cid[tsel]), decreasing=T)
    tdf <- data.frame(cid=names(x), chgs=x, row.names=NULL, stringsAsFactors =F)
    tdf$chgs1 <- tdf$tchgs <- 0
    tdf$mod1 <- 'x'
    for (i in 1:length(x)) {
        cid <- tdf$cid[i]
        t <- table(delta$md2[ysel & delta$cid == cid])
        tdf$tchgs[i] <- sum(t)
        idx <- which.max(t)
        tdf$chgs1[i] <- t[idx]
        tdf$mod1[i] <- names(t)[idx]
    }
    df[[m]] <- tdf
}



# gabbage
tmods <- c('drivers/net', 'drivers/staging', 'drivers/media', 'net/ipv4', 'net/mac80211', 'drivers/gpu',
    'drivers/usb',  'drivers/scsi', 'net/ipv6', 'net/netfilter', 'net/core', 'net/sched', 'net/wireless',
    'sound/soc', 'sound/usb', 'sound/pci', 'drivers/video', 'drivers/acpi', 'net/bluetooth', 'net/sunrpc',
    'sound/core', 'sound/oss', 'sound/isa')
library('xtable')
mrt <- list() # ratio
mnc <- list() # num of cmtrs
mna <- list()

for (i in 1:length(tmods)) {
    mod <- tmods[i]
    st <- 2005
    ed <- st + 3
    x <- y <- z <- c()
    while(ed <= 2015.917) {
        tsel <- delta$mmod == mod & delta$m >= st & delta$m < ed
        m <- as.character(st)
        t1 <- unique(delta$cid[tsel])
        t1 <- t1[t1 %in% truecmtr]
        t2 <- unique(delta$aid[tsel])
        y[m] <- length(t1)
        z[m] <- length(t2)
        x[m] <- z[m] / y[m]
        st <- st + 1/12
        ed <- st + 3
    }
    mrt[[mod]] <- x
    mnc[[mod]] <- y
    mna[[mod]] <- z
}
# for i in drivers drivers/net drivers/staging drivers/media net/mac80211 net sound drivers/gpu drivers/usb drivers/scsi net/ipv4 net/ipv6 net/netfilter net/wireless sound/soc sound/usb sound/pci kernel mm fs drivers/video drivers/acpi net/core net/sched net/bluetooth net/sunrpc sound/core sound/oss sound/isa arch;
# do
# nf=`find $i | wc -l` ;
# loc=`find $i | xargs wc  -l  | tail -n 1` ;
# nd=`ll $i|grep "^d"|wc -l` ;
# echo $i, $nf, $loc, $nd ;
# done > cqy.tmp.ign
# cat cqy.tmp.ign
#drivers drivers/net drivers/staging drivers/media net/mac80211 net sound drivers/gpu drivers/usb drivers/scsi net/ipv4 net/ipv6 net/netfilter net/wireless sound/soc sound/usb sound/pci kernel mm fs drivers/video drivers/acpi net/core net/sched net/bluetooth net/sunrpc sound/core sound/oss sound/isa arch
tamods <- c('drivers', 'drivers/net', 'drivers/staging', 'drivers/media', 'net/mac80211', 'net', 'sound', 'drivers/gpu', 'drivers/usb', 'drivers/scsi', 'net/ipv4', 'net/ipv6', 'net/netfilter', 'net/wireless', 'sound/soc', 'sound/usb', 'sound/pci', 'kernel', 'mm', 'fs', 'drivers/video', 'drivers/acpi', 'net/core', 'net/sched', 'net/bluetooth', 'net/sunrpc', 'sound/core', 'sound/oss', 'sound/isa', 'arch')
tn  <- length(tamods)
td <- data.frame(mod=tamods)
td$na2 <- td$na1 <- td$na0 <- 0
td$nc2 <- td$nc1 <- td$nc0 <- 0
td$rt2 <- td$rt1 <- td$rt0 <- 0
#td$nsub <- td$loc <- td$nf <- 0
for (i in 1:length(tamods)){
    m <- tamods[i]
    if (str_count(m, '/') == 0){
        x <- trt[[m]] * tnc[[m]]
        td$na0[i] <- x[1]
        td$na1[i] <- median(x, na.rm=TRUE)
        td$na2[i] <- tail(x, 1)
        td$nc0[i] <- tnc[[m]][1]
        td$nc1[i] <- median(tnc[[m]], na.rm=TRUE)
        td$nc2[i] <- tail(tnc[[m]], 1)
        td$rt0[i] <- trt[[m]][1]
        td$rt1[i] <- median(trt[[m]], na.rm=TRUE)
        td$rt2[i] <- tail(trt[[m]], 1)
    } else {
        x <- mrt[[m]] * mnc[[m]]
        td$na0[i] <- x[1]
        td$na1[i] <- median(x, na.rm=TRUE)
        td$na2[i] <- tail(x, 1)
        td$nc0[i] <- mnc[[m]][1]
        td$nc1[i] <- median(mnc[[m]], na.rm=TRUE)
        td$nc2[i] <- tail(mnc[[m]], 1)
        td$rt0[i] <- mrt[[m]][1]
        td$rt1[i] <- median(mrt[[m]], na.rm=TRUE)
        td$rt2[i] <- tail(mrt[[m]], 1)
    }
}
x <- 'drivers, 20400, 1300782, 126
drivers/net, 3408, 130933, 27
drivers/staging, 2025, 947093, 44
drivers/media, 2139, 1053471, 13
net/mac80211, 78, 61080, 0
net, 1675, 912541, 58
sound, 1919, 916824, 21
drivers/gpu, 2323, 1311866, 4
drivers/usb, 726, 464484, 22
drivers/scsi, 825, 890998, 33
net/ipv4, 136, 90970, 1
net/ipv6, 104, 59551, 1
net/netfilter, 215, 90583, 2
net/wireless, 42, 36449, 0
sound/soc, 817, 385175, 32
sound/usb, 107, 37521, 7
sound/pci, 405, 274228, 25
kernel, 344, 250672, 14
mm, 107, 112484, 1
fs, 1858, 1162143, 71
drivers/video, 606, 355369, 4
drivers/acpi, 280, 140342, 3
net/core, 41, 43320, 0
net/sched, 67, 36894, 0
net/bluetooth, 57, 53903, 4
net/sunrpc, 63, 41543, 2
sound/core, 101, 44496, 2
sound/oss, 79, 41085, 1
sound/isa, 97, 40755, 11
arch, 17385, 484689, 31
'
con <- textConnection(x)
x <- read.csv(con, header=FALSE, col.names=c('mod', 'nf', 'loc', 'nd'))
td <- merge(td, x, by='mod')
td$a <- paste(td$na0, td$na1, td$na2, sep=', ')
td$c <- paste(td$nc0, td$nc1, td$nc2, sep=', ')
td$rt <- paste(round(td$rt0, 2), round(td$rt1, 2), round(td$rt2, 2), sep=', ')
td$code <- paste(td$nf, td$loc, round(td$loc / td$nc2, 2), sep=', ')
td$own <- ''
xshow <- c('mod', 'a', 'c', 'rt', 'code', 'nd', 'own')
rownames(td) <- td$mod
print(xtable(td[tamods, xshow], align='ll|r|r|r|r|r|l', caption='Classification of modules: beginning, median, ending'),
    hline.after=c(-1, 0, 1:nrow(td), which(tamods %in% c('net/mac80211', 'sound/pci'))),
    include.rownames=FALSE, include.colnames =TRUE,
    caption.placement='top')
