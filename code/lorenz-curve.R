library(ineq)


mmods <- c('drivers/usb', 'drivers/scsi', 'drivers/bluetooth', 'drivers/staging', 
	'arch/ia64', 'arch/mips', 'arch/arm', 'fs/ntfs')
mmods <- c(mmods, "fs/xfs", "fs/btrfs", "fs/nfs", "fs/cifs", "fs/ext4")
submods <- c('mm', 'net')
sel <- (delta$mmod %in% mmods)
tsel <-sel & delta$y == 2014
x <- tapply(delta$aid[tsel], delta$mmod[tsel], table)
tsel <- delta$mod %in% submods & delta$y == 2014
y <- tapply(delta$aid[tsel], delta$mod[tsel], table)
for (i in submods) x[[i]] <- y[[i]]
y <- unlist(lapply(x, sum))
y <- x[which(y >= 800 & y <= 1500)]

plotLC <- function(x, fn) {
	pdf(fn, width=8, height=8, onefile=FALSE, paper = "special")
	col <- 1:length(x)
	plot(1, type='n', xlim=c(0, 1), ylim=c(0, 1),
	     main='Lorenz curve',
	     xlab='percentage of authors', ylab='percentage of changes')
	for (i in 1:length(col)) lines(Lc(x[[i]]), col=col[i], type='l', lwd=2, lty=i)
	legend(0, 1, legend=names(x),cex=1,lwd=2,lty=1:length(col),
	       col=col ,bg="white");
	dev.off();

}

plotLC(y, 'lc.pdf')
