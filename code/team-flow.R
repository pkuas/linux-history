# team's flow/stable
stb <- list()
step <- 1
window <- 1
mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
for (i in 1:length(mods)) {
    mod <- mods[i]
    st <- 2005
    ed <- st + window
    tsel <- delta$m >= st & delta$m < ed & delta$mod == mod
    pa <- table(delta$aid[tsel])
    st <- st + step
    ed <- st + window
    x <- c()
    while (ed < 2015.917) {
        tsel <- delta$m >= st & delta$m < ed & delta$mod == mod
        a <- table(delta$aid[tsel])
        t1 <- names(a)
        t2 <- names(pa)
        n <- numOfUnique(c(t1, t2))
        sn <- sum(t1 %in% t2)	# num of stable dvpr
        x[as.character(st)] <- sn / n
    	st <- st + step
    	ed <- st + window
    	pa <- a
    }
    stb[[mod]] <- x
}
boxplot(stb)

plot(1, type='n', xlim=c(2005, 2016), ylim=c(0, 35),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
col <- 1:length(mods)
for (i in 1:length(col)) lines(as.numeric(names(yert[[i]])), yert[[i]], col=col[i], type='l')
legend(2009, 35, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");

#
t <- list()
for (m in mods) {
    sel <- delta$mod==m;
    x <- table(delta$aid[sel], delta$cvsn[sel]);
    res <- c()
    h <- x[, 1] / 2
    for (i in 2:ncol(x)){res <- c(res, (cosine(h, x[,i]))); h <-  (h + x[, i]) / 2; }
    names(res)<-colnames(x)[-1]
    t[[m]] <- res
}
m <- 'mm'; plot(as.Date(names(t[[m]])), t[[m]], type='b', ylim=c(0, 1))
m <- 'kernel'; lines(as.Date(names(t[[m]])), t[[m]], type='b', col=2)

m <- mods[1]; plot(as.Date(names(t[[m]])), t[[m]], type='b', ylim=c(0, 1))
for (i in 2:length(mods)){#m in mods[-1]) {
    m <- mods[i]
    lines(as.Date(names(t[[m]])), t[[m]], type='b', col=i, lty=i)
}
legend(as.Date('2009', '%Y'), 0.4, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");

plot(as.Date(names(res)), res, type='b', ylim=c(0, 1))
lines(as.Date(names(res)), res, type='b', col=2)

sel <- delta$mod == 'mm'
st <- 2005
ed <- st + 0.25
tsel <- sel & delta$m >= st & delta$m < ed
t <- table
while (ed < 2015.917) {

}
