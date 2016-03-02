# yearly
mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
tsel <- delta$mod %in% mods #& delta$y >= 2010
res <- t2apply((1:numofdeltas)[tsel], delta$y[tsel], delta$mod[tsel], function(x) {
	# t <- c(length(x), numOfUnique(delta$aid[x]), numOfUnique(delta$cid[x]), 
	# 	numOfUnique(delta$ae[x]), numOfUnique(delta$ce[x]), 
	# 	length(grep('gmail.com', delta$ae[x], ignore.case=T)), 
	# 	length(grep('gmail.com', delta$ce[x], ignore.case=T))
	# 	)
	# names(t) <- c('nchgs', 'na', 'nc', 'nae', 'nce', 'nga', 'ngc')
	# return(t)
	return(length(grep('gmail.com', unique(delta$ae[x]), ignore.case=T)) / numOfUnique(delta$ae[x]))
	})
#
aes <- tapply(delta$ae[tsel], delta$mod[tsel], numOfUnique)
volnaes <- tapply(delta$ae[tsel], delta$mod[tsel], function(x) {
	x <- unique(x)
	return(length(grep('gmail.com', x, ignore.case=T)))

	})
 
# 3 - year period
mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
gart <- list() # gmail athr
acnt <- list()
for ( i in 1:length(mods)) {
	x <- y <- c()
	st <- 2005
	ed <- st + 3
	while (ed < 2015.917) {
		m <- as.character(st)
		tsel <- delta$m >= st & delta$m < ed  & delta$mod == mods[i]
		x[m] <- length(grep('gmail.com', unique(delta$ae[tsel]), ignore.case = T))
		y[m] <- numOfUnique(delta$ae[tsel])
		st <- st + 1/12
		ed <- st + 3
	}	
	gart[[mods[i]]] <- x / y
	acnt[[mods[i]]] <- y
}
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 0.4),
    main='Ratio of adjusted # authors to adjusted # committers (in 3-year period)',
    xlab='Natural month', ylab='Ratio')
col <- 1:length(mods)
for (i in 1:length(col)) {
	x <- gart[[mods[i]]]
    lines(as.numeric(names(x)), x, col=col[i], type='l')
}
legend(2007, 0.4, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");
