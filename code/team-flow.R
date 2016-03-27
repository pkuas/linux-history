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
    rate <- 1/2
    res <- c()
    h <- x[, 1] * rate
    for (i in 2:ncol(x)){res <- c(res, (cosine(h, x[,i]))); h <-  (h + x[, i]) * rate; }
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

#
cmn <- list() # community
for (m in xmods) {
t <- list()
#m <- 'arch/arm'
sel <- getSel(m)
x <- tapply(delta$aid[sel], delta$cvsn[sel], function(x) {
    t1 <- sort(table(x), decreasing=T)
    cs <- cumsum(t1)
    tsel <- cs / sum(t1) < 0.8
    cnt <- length(tsel)
    tsel <- c(TRUE, tsel[-cnt])
    core <- sum(tsel)
    return(c(core, cnt - core))
    })
x <- matrix(unlist(x), nrow=2)
t[['x']] <- x
mx <- max(colSums(x))
t[['mx']] <- mx

y <- tapply(delta$aid[sel], delta$cvsn[sel], length)
my <- max(y)
t[['y']] <- y
t[['my']] <- my

# code ownership
nchg <- t2apply(delta$v[sel], delta$f[sel], delta$cvsn[sel], length)
na <- t2apply(delta$aid[sel], delta$f[sel], delta$cvsn[sel], numOfUnique)
own <- c()
for (v in names(na)) {
    t1 <- nchg[[v]]
    own[v] <- sum(na[[v]] * t1) / sum(t1)
}
mo <- max(own)
t[['own']] <- own
t[['mo']] <- mo

## average add
nadd <- tapply(delta$add[sel], delta$cvsn[sel], mean)

## number of new file
#for (m in xmods) {
#sel <- getSel(m)
nf <- tapply(delta$ftenure[sel], delta$cvsn[sel], numOfZero)
t[['nf']] <- nf
#cmn[[m]][['nf']] <- nf
#}

cmn[[m]] <- t

for ( m in xmods) {
devon <- T
if (devon) pdf(paste('t/', sub('/','-', m), '.pdf', sep=''), width=8,height=6, onefile=FALSE, paper = "special")
opar <- par(no.readonly=TRUE)
par(mar=c(5, 4, 4, 8) + 0.1)
t <- cmn[[m]]; x <- t[['x']]; mx <- t[['mx']]; y <- t[['y']]; my <- t[['my']]; own <- t[['own']]; mo <- t[['mo']];
nf <- t[['nf']]
p <- barplot(x, main=paste('Community of', m), xlab='Releases', ylab='# of authors',
    #col=c('red', 'yellow'),
    ylim=c(0, mx),
    legend=c('#core', '#prph'),
    args.legend = list(x = "topleft", cex=0.7))
legend('topright', legend = c('#chgs', 'owner'), col = c('red', 'blue'),
    lty=1, cex=0.7, seg.len=1)
lines(p, y / my * mx, col='red', lty=2, lwd=2)
z <- seq(0, my, ifelse(my > 200, ceil(my / 500) * 100, 50))
axis(4, at=z / my * mx, labels=z, col.axis="red", cex.axis=1)
#mtext("# of changes", side=4, line=3, cex.lab=1, las=2, col="red")
lines(p, own / mo * mx, col='blue', lty=2, lwd=2)
z <- seq(0,floor(mo), ifelse(mo > 5, 2, 1))
axis(4, at=z / mo * mx, labels=z, col.axis="blue", cex.axis=1, pos=tail(p, 1) + 7)
#mtext(paste('ownership:', round(mo,2), round(median(own), 2)), col='blue')
lines(p, nf / max(nf) * mx, col='green', lty=2, lwd=2,type='l')
if(devon) dev.off()
par(opar)
}
cor.test(y, x[1, ])
cor.test(y, x[2, ])
cor.test(x[1, ], x[2, ])
cor.test(own, y)
cor.test(own, x[1, ])
cor.test(own, x[2, ])

round(c(
    stats::cor(y, x[1, ]),
    stats::cor(y, x[2, ]),
    stats::cor(x[1, ], x[2, ]),
    stats::cor(own, y),
    stats::cor(own, x[1, ]),
    stats::cor(own, x[2, ])
), 2)

}
# u <- tapply(delta$aid[sel], delta$cvsn[sel], function(x) {
#     t1 <- ineq(table(x))
#     return(t1)
#     })
# lines(p, u * mx, col='blue', lty=2, lwd=2)

# w <- table(delta$aid[sel], delta$cvsn[sel]);
# rate <- 1/2
# res <- c()
# h <- w[, 1] * rate
# for (i in 2:ncol(w)){res <- c(res, (cosine(h, w[,i]))); h <-  (h + w[, i]) * rate; }
# names(res)<-colnames(w)[-1]
# mr <- max(res)
# lines(p[-1], res * mx, col='blue', lty=3, lwd=2)

p <- barplot(x, main=paste('# of authors on', m), xlab='Releases', ylab='# of authors',
    #col=c('red', 'yellow'),
    ylim=c(0, mx * 1.1),
    legend=c('Core', 'Peripheral'),
    args.legend = list(x = "topleft"))
lines(p, y / my * mx, col='red', lty=2, lwd=2)
z <- seq(0, my, ceil(my / 500) * 100)
axis(4, at=z / my * mx, labels=z,
    col.axis="red", cex.axis=0.7)
mtext("# of changes", side=4, line=3, cex.lab=1, las=2, col="red")
lines(p, own / mo * mx, col='blue', lty=2, lwd=2)
mtext(paste('ownership:', round(mo,2)), col='blue')

# lines(p[-1], res * mx, col='blue', lty=3, lwd=2)


# cosine sim
sel <- getSel(m)
t <- tapply(delta$aid[sel], delta$cvsn[sel], function(x) {
    t1 <- sort(table(x), decreasing=T)
    t2 <- as.vector(t1)
    names(t2) <- names(t1)
    t1 <- t2
    cs <- cumsum(t1)
    tsel <- cs / sum(t1) < 0.8
    cnt <- length(tsel)
    tsel <- c(TRUE, tsel[-cnt]);
    return(t1[tsel])
})

mcos <- function(u, v, tp='v') {
ns <- unique(c(names(u), names(v)));
u[ns[!ns %in% names(u)]] <-0;
v[ns[!ns %in% names(v)]] <-0;
u <- u[ns];
v <- v[ns];
if (tp=='v') return(cosine(u, v))
return(cosine(as.integer(u > 0), as.integer(v > 0)))
}

# long term
lcmn <- list()
for (m in xmods) {
    sel <- getSel(m)
    st <- 2005
    ed <- st + 3
    tx <- ty <- town <- c()
    while (ed < 2015.835) {
        tsel <- sel & delta$cty >= st & delta$cty < ed
        t1 <- sort(table(delta$aid[tsel]), decreasing=T)
        cs <- cumsum(t1)
        ts <- cs / sum(t1) < 0.8
        cnt <- length(ts)
        ts <- c(TRUE, ts[-cnt])
        core <- sum(ts)
        tx <- c(tx, core, cnt - core)
        ty <- c(ty, sum(t1))

        fchgs <- tapply(delta$aid[tsel], delta$f[tsel], length)
        faids <- tapply(delta$aid[tsel], delta$f[tsel], numOfUnique)
        town <- c(town, sum(fchgs * faids) / sum(fchgs))

        st <- st + 1/12
        ed <- st + 3
    }
    tx <- matrix(tx, nrow=2)
    tmod <- list(x=tx, mx=max(colSums(tx)), y=ty, my=max(ty), own=town, mo=max(town))
    lcmn[[m]] <- tmod
}

for ( m in xmods) {
    devon <- T
    if (devon) pdf(paste('t/', sub('/','-', m), '-l.pdf', sep=''), width=8,height=6, onefile=FALSE, paper = "special")
    opar <- par(no.readonly=TRUE)
    par(mar=c(5, 4, 4, 8) + 0.1)
    t <- lcmn[[m]]; x <- t[['x']]; mx <- t[['mx']]; y <- t[['y']]; my <- t[['my']]; own <- t[['own']]; mo <- t[['mo']];
    #nf <- t[['nf']]
    p <- barplot(x, main=paste('Community of', m), xlab='Months', ylab='# of authors',
        #col=c('red', 'yellow'),
        ylim=c(0, mx),
        legend=c('#core', '#prph'),
        args.legend = list(x = "topleft", cex=0.7))
    legend('topright', legend = c('#chgs', 'owner'), col = c('red', 'blue'),
        lty=1, cex=0.7, seg.len=1)
    lines(p, y / my * mx, col='red', lty=2, lwd=2)
    z <- seq(0, my, ifelse(my > 200, ceil(my / 500) * 100, 50))
    axis(4, at=z / my * mx, labels=z, col.axis="red", cex.axis=1)
    #mtext("# of changes", side=4, line=3, cex.lab=1, las=2, col="red")
    lines(p, own / mo * mx, col='blue', lty=2, lwd=2)
    z <- seq(0,floor(mo), ifelse(mo > 5, 2, 1))
    axis(4, at=z / mo * mx, labels=z, col.axis="blue", cex.axis=1, pos=tail(p, 1) + 7)
    #mtext(paste('ownership:', round(mo,2), round(median(own), 2)), col='blue')
    #lines(p, nf / max(nf) * mx, col='green', lty=2, lwd=2,type='l')
    if(devon) dev.off()
    par(opar)
    cor.test(y, x[1, ])
    cor.test(y, x[2, ])
    cor.test(x[1, ], x[2, ])
    cor.test(own, y)
    cor.test(own, x[1, ])
    cor.test(own, x[2, ])
    round(c(
        stats::cor(y, x[1, ]),
        stats::cor(y, x[2, ]),
        stats::cor(x[1, ], x[2, ]),
        stats::cor(own, y),
        stats::cor(own, x[1, ]),
        stats::cor(own, x[2, ])
    ), 2)
}
