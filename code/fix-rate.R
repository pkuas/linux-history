mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
fixrt <- list()
fixcnt <- list()
revcnt <- list()
for ( i in 1:length(mods)) {
	sel <- delta$mod == mods[i] & (c('$%#$', delta$v[-numofdeltas]) != delta$v)
	sum(tsel)
	x <- y <- c()
	st <- 2005
	ed <- st + 1
	while (ed < 2015.917) {
		m <- as.character(st)
		tsel <- sel & delta$m >= st & delta$m < ed
		x[m] <- length(grep('fix', delta$cmt[tsel], ignore.case = T))
		y[m] <- sum(tsel)
		st <- st + 1/12
		ed <- st + 1
	}
	fixcnt[[mods[i]]] <- x
	revcnt[[mods[i]]] <- y
	fixrt[[mods[i]]] <- x / y
}

col <- 1:length(mods)
plot(1, type='n', xlim=c(2005, 2015), ylim=c(0, 0.35),
    main='fix rt',
    xlab='Natural y', ylab='Ratio')
for (i in 1:length(col)) lines(as.numeric(names(fixrt[[i]])), fixrt[[i]], col=col[i], type='l')
legend(2006, 0.15, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");

drfixrt <- list()
drfixcnt <- list()
drrevcnt <- list()
for ( i in 1:length(mods)) {
	mod <- drmods[i]
	sel <- delta$mmod == mod & (c('$%#$', delta$v[-numofdeltas]) != delta$v)
	x <- y <- c()
	st <- 2005
	ed <- st + 1
	while (ed < 2015.917) {
		m <- as.character(st)
		tsel <- sel & delta$m >= st & delta$m < ed
		x[m] <- length(grep('fix', delta$cmt[tsel], ignore.case = T))
		y[m] <- sum(tsel)
		st <- st + 1/12
		ed <- st + 1
	}
	drfixcnt[[mod]] <- x
	drrevcnt[[mod]] <- y
	drfixrt[[mod]] <- x / y
}
