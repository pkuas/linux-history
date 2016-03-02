# (core) ratio of a2c & ratio 
mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
rt <- list() # ratio
nc <- list() # num of cmtrs
crt <- list() # core ratio
cnc <- list() # num of core cmtrs
ert <- list() # entropy ratio
enc <- list() # entropy

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
	rt[[mod]] <- x
	nc[[mod]] <- y
    crt[[mod]] <- cx
    cnc[[mod]] <- cy
    ert[[mod]] <- ex
    enc[[mod]] <- ey

}
col <- 1:length(mods)
#png('a2c-mod')
png('./ratio-in-mod.png', width=800, height=600)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, max(rt$drivers)),
    main='Ratio of # authors to # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
for (i in 1:length(col)) lines(as.numeric(names(rt[[i]])), rt[[i]], col=col[i], type='l')
legend(2010, 27, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");
dev.off()

plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 40),
    main='Ratio of # core authors to # core committers (in 3-year period)',
    xlab='natural month', ylab='ratio')
for (i in 1:length(col)) lines(as.numeric(names(crt[[i]])), crt[[i]], col=col[i], type='l')
legend(2009, 40, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");

png('./eratio-in-mod.png', width=800, height=600)
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 35),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
for (i in 1:length(col)) lines(as.numeric(names(ert[[i]])), ert[[i]], col=col[i], type='l')
legend(2009, 35, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");
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
