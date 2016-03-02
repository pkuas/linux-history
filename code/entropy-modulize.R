mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
modentropy <- list()
rmodentropy <- list() # recursive
for (i in 1:length(mods)) {
	st <- 2005
	ed <- st + 3
	mod <- mods[i]
	x <- rx <- c()
	while (ed < 2015.917){
		tsel <- delta$m >= st & delta$m < ed & delta$mod == mod
		rootsel <- delta$mmod == delta$f
		#x[as.character(st)] <- entropy(c(sum(tsel & rootsel), table(delta$mmod[tsel & !rootsel])), method='ML', unit='log2')
		rx[as.character(st)] <- entropy(c(sum(tsel & rootsel), table(delta$fm[tsel & !rootsel])), method='ML', unit='log2')
		st <- st + 1/12
		ed <- st + 3
	}
	#modentropy[[mod]] <- x
	rmodentropy[[mod]] <- rx
}

plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 10),
    main='Degree of coupling of each module (in 3-year period)',
    xlab='Natural month', ylab='Degree of coupling')
col <- 1:length(mods)
for (i in 1:length(col)) {
	x <- rmodentropy[[mods[i]]]
    lines(as.numeric(names(x)), x, col=col[i], type='l')
}
legend(2007, 10, legend=mods,cex=1,lwd=1,
    col=col ,bg="white");
