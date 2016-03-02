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
