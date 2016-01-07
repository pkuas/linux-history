picdir <- "../SyncDirectory/research/linux/pics/"
mod.month <- table(delta$mod,delta$m);

sel.mod <- names(sort(-table(delta$mod))[1:7]);
x.axis <- as.numeric(names(mod.month[1,]))

png(paste(picdir,"deltas-in-mod.png",sep="") , width=800,height=600);
plot(x.axis, mod.month[sel.mod[1],], type='l', col=1, main="Number of deltas on each module each month", xlab = "natural month", ylab = "# of deltas")
for(i in 2:7){lines(x.axis, mod.month[sel.mod[i],],col=i,lty=1)}
legend(2006,7500,legend=sel.mod,cex=1,lwd=2,col=rep(1:7),bg="white"); 
dev.off();

png("dvponmod.png", width=800,height=600);
 matplot(as.numeric(names(dvponmod[1,])),t(dvponmod[mod,]),main="number of developers on each module each month",type="o",col=1:8,xlab="natural month",ylab="# of developers");
 legend(2002,max(dvponmod[mod,]),legend=mod,cex=1,lwd=2,col=rep(1:8),bg="white"); 
dev.off();

###########
x$acompany <- sub(".*@(.*)", "\\1", as.character(x$ae),perl=TRUE)
delta$acompany <- sub(".*@(.*)", "\\1", as.character(delta$ae),perl=TRUE)
mod.company<- table(delta$mod, delta$acompany)
