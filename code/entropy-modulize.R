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
pdf('./modularity.pdf', width=8,height=6, onefile=FALSE, paper = "special")

plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 10),
    main='Modularity of each module (in 3-year period)',
    xlab='Natural month', ylab='Modularity')
col <- 1:length(mods)
for (i in 1:length(col)) {
	x <- rmodentropy[[mods[i]]]
    lines(as.numeric(names(x)), x, col=col[i], type='l', lty=i, lwd=2)
}
legend(2007, 10, legend=mods,cex=1,lwd=2, lty=1:length(col),
    col=col ,bg="white");
dev.off()

# drivers
drmods <- c("drivers/net", "drivers/staging", "drivers/gpu", 
	"drivers/media", "drivers/usb", "drivers/scsi", "drivers/video","drivers/acpi" )
#modentropy <- list()
rdrmodentropy <- list() # recursive
for (i in 1:length(drmods)) {
	st <- 2005
	ed <- st + 3
	mmod <- drmods[i]
	x <- rx <- c()
	while (ed < 2015.917){
		tsel <- delta$m >= st & delta$m < ed & delta$mmod == mmod
		rootsel <- delta$smod == delta$f
		#x[as.character(st)] <- entropy(c(sum(tsel & rootsel), table(delta$smod[tsel & !rootsel])), method='ML', unit='log2')
		rx[as.character(st)] <- entropy(c(sum(tsel & rootsel), table(delta$fm[tsel & !rootsel])), method='ML', unit='log2')
		st <- st + 1/12
		ed <- st + 3
	}
	#modentropy[[mmod]] <- x
	rdrmodentropy[[mmod]] <- rx
}
pdf('./modularity-dr.pdf', width=8,height=6, onefile=FALSE, paper = "special")
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 8),
    main='Modularity of each module (in 3-year period)',
    xlab='Natural month', ylab='Modularity')
col <- 1:length(drmods)
for (i in 1:length(col)) {
	x <- rdrmodentropy[[drmods[i]]]
    lines(as.numeric(names(x)), x, col=col[i], type='l', lty=i, lwd=2)
}
legend(2005, 8, legend=drmods,cex=1,lwd=2,lty=1:length(col),
    col=col ,bg="white");
dev.off()

# arch
armods <- c( "arch/arm", "arch/x86", "arch/powerpc", "arch/mips", "arch/sh", 
	"arch/s390", "arch/i386", "arch/um", "arch/ia64", "arch/sparc"  )
#modentropy <- list()
rarmodentropy <- list() # recursive
for (i in 1:length(armods)) {
	st <- 2005
	ed <- st + 3
	mmod <- armods[i]
	x <- rx <- c()
	while (ed < 2015.917){
		tsel <- delta$m >= st & delta$m < ed & delta$mmod == mmod
		rootsel <- delta$smod == delta$f
		#x[as.character(st)] <- entropy(c(sum(tsel & rootsel), table(delta$smod[tsel & !rootsel])), method='ML', unit='log2')
		rx[as.character(st)] <- entropy(c(sum(tsel & rootsel), table(delta$fm[tsel & !rootsel])), method='ML', unit='log2')
		st <- st + 1/12
		ed <- st + 3
	}
	#modentropy[[mmod]] <- x
	rarmodentropy[[mmod]] <- rx
}
pdf('./modularity-ar.pdf', width=8,height=6, onefile=FALSE, paper = "special")
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 8),
    main='Modularity of each module (in 3-year period)',
    xlab='Natural month', ylab='Modularity')
col <- 1:length(armods)
for (i in 1:length(col)) {
	x <- rarmodentropy[[armods[i]]]
    lines(as.numeric(names(x)), x, col=col[i], type='l', lty=i, lwd=2)
}
legend(2005, 8, legend=armods,cex=1,lwd=2,lty=1:length(col),
    col=col ,bg="white");
dev.off()

# net
nemods <- c("net/ipv4", "net/ipv6", "net/mac80211", "net/netfilter", 
	"net/bluetooth", "net/core", "net/sunrpc", "net/sched", "net/wireless")
#modentropy <- list()
rnemodentropy <- list() # recursive
for (i in 1:length(nemods)) {
	st <- 2005
	ed <- st + 3
	mmod <- nemods[i]
	x <- rx <- c()
	while (ed < 2015.917){
		tsel <- delta$m >= st & delta$m < ed & delta$mmod == mmod
		rootsel <- delta$smod == delta$f
		#x[as.character(st)] <- entropy(c(sum(tsel & rootsel), table(delta$smod[tsel & !rootsel])), method='ML', unit='log2')
		rx[as.character(st)] <- entropy(c(sum(tsel & rootsel), table(delta$fm[tsel & !rootsel])), method='ML', unit='log2')
		st <- st + 1/12
		ed <- st + 3
	}
	#modentropy[[mmod]] <- x
	rnemodentropy[[mmod]] <- rx
}
pdf('./modularity-ne.pdf', width=8,height=6, onefile=FALSE, paper = "special")
plot(1, type='n', xlim=c(2005, 2013), ylim=c(0, 3),
    main='Modularity of each module (in 3-year period)',
    xlab='Natural month', ylab='Modularity')
col <- 1:length(nemods)
for (i in 1:length(col)) {
	x <- rnemodentropy[[nemods[i]]]
    lines(as.numeric(names(x)), x, col=col[i], type='l', lty=i, lwd=2)
}
legend(2008, 3, legend=nemods,cex=1,lwd=2,lty=1:length(col),
    col=col ,bg="white");
dev.off()