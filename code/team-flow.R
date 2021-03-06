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
getExpected <- function(x, k = 0, tint = 1) {
    rates <- c(1)
    ex <- x[1:tint]
    td <- as.Date(names(x))
    for (idx in (1+tint):length(x)){
        tn <- idx - tint
        tdelta <- as.numeric((as.Date(names(x[idx])) - td)[1:tn] / 365)
        ex <- c(ex, sum((x[1:tn] + tdelta) * rates) / sum(rates))
        rates <- c(rates * k, 1)
    }
    names(ex) <- names(x)
    return(ex)
}
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

# gini
gn <- tapply(delta$aid[sel], delta$cvsn[sel], function(x) ineq(table(x)))
lines(gn * mx / max(gn) / 2, col='yellow', type='b')


## ages of changes
#for (m in xmods) {
#m <- 'mm'
sel <- getSel(m)
ages <- tapply(delta$ftenure[sel], delta$cvsn[sel], mean)
eages <- getExpected(ages)
dc <- eages - ages
#}
# cmn[[m]][['ages']] <- ages
# cmn[[m]][['dc']] <- dc
#for(m in xmods) {
#sel <- getSel(m)
#devon <- F
ages <- cmn[[m]][['ages']]
eages <- ages + cmn[[m]][['dc']]
nf <- cmn[[m]][['nf']]
if (devon) pdf(paste('t/', sub('/','-', m), '.pdf', sep=''), width=8,height=6, onefile=FALSE, paper = "special")
plot(as.Date(names(eages)), eages, type='l', lwd=2, lty=3,
     xlab='Dates of versions', ylab='Age(years)', col='red',
     main=paste("Changes' mean age of each version on", m))
lines(as.Date(names(ages)), ages, type='l', lwd=2, lty=1, col='red')
lines(as.Date(names(ages)), eages - ages, type='l', lwd=2, lty=1, col='blue')
lines(as.Date(names(nf)), nf * max(eages)/max(nf)/2, type='l', lwd=2, lty=1)
legend('topleft', legend = c('E mean', 'mean', '#new file'),
       col = c('red', 'red', 'black'),
       lty=c(3, 1, 1), cex=1, seg.len=2, lwd=2)
if (devon) dev.off()

y<-cmn[[m]][['y']];plot(y, ylim=c(0, max(y)), type='b')
lines(eages * max(y) / max(eages), col='blue', type='b')
lines(ages * max(y) / max(eages), col='red', type='b')
#cor.test(eages - ages, cmn[[m]][['x']][1, ])
#cor.test(eages - ages, cmn[[m]][['x']][2, ])
m

# age of athrs
#for (m in xmods){
#sel <- getSel(m)
#devon <- F
modmin <- tapply(delta$ty[sel], delta$aid[sel], min)
waage <- tapply(delta$ty[sel] - modmin[delta$aid[sel]], delta$cvsn[sel], mean)
aage <- unlist(lapply(
    t2apply(delta$ty[sel] - modmin[delta$aid[sel]], delta$aid[sel], delta$cvsn[sel], mean),
    mean))
ewaage <- getExpected(waage)
eaage <- getExpected(aage)
dwa <- ewaage - waage
da <- eaage - aage
#cmn[[m]][['waage']] <- waage
#cmn[[m]][['aage']] <- aage
#cmn[[m]][['dwa']] <- dwa
#cmn[[m]][['da']] <- da
#}
for (m in xmods){
sel <- getSel(m)
devon <- F
t <- cmn[[m]];
waage <- cmn[[m]][['waage']];
aage <- cmn[[m]][['aage']];
ewaage <- waage + cmn[[m]][['dwa']]
eaage <- aage + cmn[[m]][['da']]
na <- cmn[[m]][['na']] # new athr/ new comer
if (devon) pdf(paste('t/', sub('/','-', m), '.pdf', sep=''), width=8,height=6, onefile=FALSE, paper = "special")
plot(as.Date(names(ewaage)), ewaage, type='l', lwd=2, lty=3,
     xlab='Dates of versions', ylab='Age(years)', col='red',
     main=paste("Authors' mean age of each version on", m))
lines(as.Date(names(waage)), waage, type='l', lwd=2, lty=1, col='red')
lines(as.Date(names(eaage)), eaage, type='l', lwd=2, lty=3, col='green')
lines(as.Date(names(aage)), aage, type='l', lwd=2, lty=1, col='green')
lines(as.Date(names(na)), na * max(ewaage)/max(na)/2, type='l', lwd=2, lty=1)
legend('topleft', legend = c('EW mean', 'W mean', 'E mean', 'mean'),
       col = c('red', 'red', 'green', 'green'),
       lty=c(3, 1, 3, 1), cex=1, seg.len=2, lwd=2)
if (devon) dev.off()
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
z <- seq(0, my, ifelse(my > 200, ceiling(my / 500) * 100, 50))
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
z <- seq(0, my, ceiling(my / 500) * 100)
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
    z <- seq(0, my, ifelse(my > 200, ceiling(my / 500) * 100, 50))
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


#
t <- tapply(delta$cmt[sel], delta$cvsn[sel], function(x) {
    return(length(grep('add ', x, ignore.case=T)))
    })


# file changes cos sim
getpcos <- function(x) {
    r <- nrow(x)
    idx <- seq(0, (r - 2) * r, r) + seq(2, r, 1)
    return(x[idx])
}
sel <- getSel(m)
t <- table(delta$f[sel], delta$cvsn[sel])
x <- cosine(t)
y <- t; y[which(t>0)] <- 1
y <- cosine(y)
sp <- stats::cor(t, method='spearman')
i <- nrow(x)
plot(x[, i], type='b')
lines(y[, i], type='b', col='red')
lines(sp[, i], type='b', col='blue')
abline(a=0.5, b=0)
i <- i - 1
m <- xmods[i]
sel <- getSel(m)
t <- cmn[[m]]
y <- t[['y']]
plot(y, type='b', ylim=c(0, max(y)))
ages <- t[['ages']]
dc <- getExpected(ages, k=0.5) - ages
z <- dc - min(dc)
plot(y, type='b', ylim=c(0, max(y)))
lines(z/max(z)*max(y) / 2, type='b', col='blue'); abline(a=-min(dc)/max(z)*max(y) / 2, b=0)
i <- i+ 1

# #chgs, #new, #new12, #old ---> structure
fvsn <- tapply((1:nrow(delta)), delta$f, function(x) {
    return(delta$cvsn[x[which.min(delta$ftenure[x])]])
    })
versions$d <- as.Date(versions$rd, '%d %b %Y')
vsns <- as.character(sort(versions$d, decreasing=F))
getPvsn <- function(now) {
    return(vsns[which(vsns == now) - 1])
}
for (m in xmods) {
    sel <- getSel(m)
#    fvcnt <- tapply(delta$f[sel], delta$cvsn[sel], table)
    vvcnt <- tapply(delta$f[sel], delta$cvsn[sel], function(x){
        return(table(fvsn[x]))
        })
    n0 <- n1 <- n2 <- nold <- c()

    for (v in names(vvcnt)[-1:-4]) {
        tv <- vvcnt[[v]]
        tn <- length(tv)
        tn0 <- ifelse(is.na(tv[v]), 0, tv[v])
        n0 <- c(n0, tn0)
        p1v <- getPvsn(v)
        tn1 <- ifelse(is.na(tv[p1v]), 0, tv[p1v])
        n1 <- c(n1, tn1)
        p2v <- getPvsn(p1v)
        tn2 <- ifelse(is.na(tv[p2v]), 0, tv[p2v])
        n2 <- c(n2, tn2)
        nold <- c(nold, sum(tv) - tn0 - tn1 - tn2)
    }
    # n0 <- ifelse(is.na(n0), 0, n0)
    # n1 <- ifelse(is.na(n1), 0, n1)
    # n2 <- ifelse(is.na(n2), 0, n2)
    # nold <- ifelse(is.na(nold), 0, nold)
    names(n1) <- names(n2) <- names(nold) <- names(vvcnt)[-1:-4]
    cmn[[m]][['n0']] <- n0
    cmn[[m]][['n1']] <- n1
    cmn[[m]][['n2']] <- n2
    cmn[[m]][['nold']] <- nold

}

# team in and out : flow
for (m in xmods) {
    sel <- getSel(m)
    ta <- tapply(delta$aid[sel], delta$cvsn[sel], unique)
    ain <- c(length(ta[[1]]))
    aout <- c(0)
    for (v in names(ta)[-1]){
        p1v <- getPvsn(v)
        aprev <- ta[[p1v]]
        #aprev <- c(ta[[p1v]], ta[[getPvsn(p1v)]]) # last one may be null
        ain <- c(ain, sum(!ta[[v]] %in% aprev))
        aout <- c(aout, sum(!aprev %in% ta[[v]]))
    }
    names(ain) <- names(aout) <- names(ta)
    cmn[[m]][['ain']] <- ain
    cmn[[m]][['aout']] <- aout
    #cmn[[m]][['ain2']] <- ain
    #cmn[[m]][['aout2']] <- aout
}
# core and peri in and out
for (m in xmods) {
    sel <- getSel(m)
    ta <- tapply(delta$aid[sel], delta$cvsn[sel], function  (x) {
        tb <- sort(table(x), decreasing=T)
        cs <- tb / sum(tb) >= 0.02
        tsel <- cs#c(TRUE, cs[-length(cs)])
        return(list(ca=names(tb[tsel]), pa=names(tb[!tsel])))
        })
    ain <- c(length(ta[[1]]))
    aout <- c(0)
    for (v in names(ta)[-1]){
        p1v <- getPvsn(v)
        #aprev <- ta[[p1v]]
        aprev <- c(ta[[p1v]], ta[[getPvsn(p1v)]]) # last one may be null
        ain <- c(ain, sum(!ta[[v]] %in% aprev))
        aout <- c(aout, sum(!aprev %in% ta[[v]]))
    }
    names(ain) <- names(aout) <- names(ta)
    # cmn[[m]][['ain']] <- ain
    # cmn[[m]][['aout']] <- aout
    cmn[[m]][['ain2']] <- ain
    cmn[[m]][['aout2']] <- aout
}

# structure in terms of LTC and freshman
for (m in xmods) {
    sel <- getSel(m)
    modmin <- tapply(delta$ty[sel], delta$aid[sel], min)
    res <- t2apply(delta$ty[sel] - modmin[delta$aid[sel]], delta$aid[sel], delta$cvsn[sel], function(x) return(min(x, na.rm=T)))
    thresh <- 3/12
    ltc <- unlist(lapply(res, function(x) {return(sum(x >= thresh))}))
    fresh <- unlist(lapply(res, function(x) {return(sum(x < thresh))}))
    names(ltc) <- names(fresh) <- names(res)
    cmn[[m]][['ltc']] <- ltc
    cmn[[m]][['fresh']] <- fresh
}

t <- cmn[[m]]
drp <- -1:-4
n12 <- t[['n1']] + t[['n0']] + t[['n2']]
nold <- t[['nold']]
ns <- n12 + nold
n12 <- n12 / ns
nold <- nold / ns
ain <- t[['ain']][drp]
aout <- t[['aout']][drp]
xa <- as.Date(names(n12))
plot(xa, n12, type='b', ylim=c(0, 0.6))
lines(xa, ns / max(ns) * 0.5, col='red')
lines(xa, ain / max(aout) * 0.5, col='blue')
lines(xa, aout / max(aout) * 0.5, col='green')
abline(a=median(ain)/max(aout)*0.5, b=0)
cor.test(ain, aout)
cor.test(ain[-length(ain)], aout[-1]) # strong correlation
cor.test(ain, n12)

t <- cmn[[m]]
drp <- -1:-4
y <- t[['y']][drp]
n12 <- t[['n1']] + t[['n0']] + t[['n2']]
nold <- t[['nold']]
ns <- n12 + nold
n12 <- n12 / ns
ltc <- t[['ltc']][drp]
fresh <- t[['fresh']][drp]
ltcr <- ltc / (ltc + fresh)
xa <- as.Date(names(y))
my <- max(y)
plot(xa, y, type='b', ylim=c(0, my))
lines(xa, n12 * my, type='l', col='red')
lines(xa, ltcr / max(ltcr) * 0.5 * my, type='l', col='blue')


#md <- lm(x[2, ][drp] ~ y[drp] + nf[drp] + n1 + n2 + nold, data=t)
md <- lm(t[['x']][1, ][drp] ~ ns + n12 + nold)
summary(md)



res<-scatterplot3d(n12,nold,t[['x']][1,][drp],colors='red', col.axis="blue", col.grid="lightblue",pch=16, zlim=c(0,12),xlab='x1',ylab='x2',zlab='x3', angle=55)
res$plane3d(-nb, -nw[1,1],-nw[2,1], "solid", col="grey")
title("Fisher")
legend("topright", "",legend = as.expression(c(bquote(w==.(theta2.ml)), bquote(sigma^2==.(sigma2.square.ml)))))


for (m in xmods){
sel <- getSel(m)
devon <- F
t <- cmn[[m]];
waage <- cmn[[m]][['waage']];
aage <- cmn[[m]][['aage']];
ewaage <- waage + cmn[[m]][['dwa']]
eaage <- aage + cmn[[m]][['da']]
na <- cmn[[m]][['na']] # new athr/ new comer
if (devon) pdf(paste('t/', sub('/','-', m), '.pdf', sep=''), width=8,height=6, onefile=FALSE, paper = "special")
plot(as.Date(names(ewaage)), ewaage, type='l', lwd=2, lty=3,
     xlab='Dates of versions', ylab='Age(years)', col='red',
     main=paste("Authors' mean age of each version on", m))
lines(as.Date(names(waage)), waage, type='l', lwd=2, lty=1, col='red')
lines(as.Date(names(eaage)), eaage, type='l', lwd=2, lty=3, col='green')
lines(as.Date(names(aage)), aage, type='l', lwd=2, lty=1, col='green')
lines(as.Date(names(na)), na * max(ewaage)/max(na)/2, type='l', lwd=2, lty=1)
legend('topleft', legend = c('EW mean', 'W mean', 'E mean', 'mean'),
       col = c('red', 'red', 'green', 'green'),
       lty=c(3, 1, 3, 1), cex=1, seg.len=2, lwd=2)
if (devon) dev.off()
#}

cmn[[m]] <- t

for ( m in xmods) {
devon <- T
drp<- -1:-10
ndrp <- -1:-6
if (devon) pdf(paste('t/', sub('/','-', m), '.pdf', sep=''), width=8,height=6, onefile=FALSE, paper = "special")
opar <- par(no.readonly=TRUE)
par(mar=c(5, 4, 4, 8) + 0.1)
t <- cmn[[m]]; x <- t[['x']]; mx <- t[['mx']]; y <- t[['y']]; my <- t[['my']]; own <- t[['own']]; mo <- t[['mo']];
nf <- t[['nf']]
n12 <- t[['n0']] + t[['n1']] + t[['n2']]
nold <- t[['nold']]
st <- matrix(c(t[['ltc']], t[['fresh']]), nrow=2, byrow=T)
mst <- max(colSums(st))
p <- barplot(st, main=paste('Community of', m), xlab='Releases', ylab='# of authors',
    #col=c('red', 'yellow'),
    ylim=c(0, mst),
    legend=c('#core', '#prph'),
    args.legend = list(x = "topleft", cex=0.7))
legend('topright', legend = c('#chgs', 'owner'), col = c('red', 'blue'),
    lty=1, cex=0.7, seg.len=1)
lines(p, y / my * mst, col='red', lty=2, lwd=2)
lines(p[-1:-4], n12 / my * mst, col='yellow', lty=2, lwd=2)
z <- seq(0, my, ifelse(my > 200, ceiling(my / 500) * 100, 50))
axis(4, at=z / my * mst, labels=z, col.axis="red", cex.axis=1)
#mtext("# of changes", side=4, line=3, cex.lab=1, las=2, col="red")
#lines(p, own / mo * mst, col='blue', lty=2, lwd=2)
#z <- seq(0,floor(mo), ifelse(mo > 5, 2, 1))
#axis(4, at=z / mo * mst, labels=z, col.axis="blue", cex.axis=1, pos=tail(p, 1) + 7)
#mtext(paste('ownership:', round(mo,2), round(median(own), 2)), col='blue')
lines(p, nf / max(nf) * mst, col='green', lty=2, lwd=2,type='l')

if(devon) dev.off()
par(opar)

cor.test(y[drp], st[1, ][drp])
cor.test(y[drp], st[2, ][drp])
cor.test(st[1, ][drp], st[2, ][drp])
# cor.test(own[drp], y[drp])
# cor.test(own[drp], st[1, ][drp])
# cor.test(own[drp], st[2, ][drp])

round(c(
    stats::cor(y[drp], st[1, ][drp]),
    stats::cor(y[drp], st[2, ][drp]),
    stats::cor(st[1, ][drp], st[2, ][drp]),
    stats::cor(n12[ndrp], st[1, ][drp]),
    stats::cor(nold[ndrp], st[1, ][drp]),
    stats::cor(n12[ndrp], st[2, ][drp]),
    stats::cor(nold[ndrp], st[2, ][drp])

#    stats::cor(own[drp], y[drp]),
#    stats::cor(own[drp], st[1, ][drp]),
#    stats::cor(own[drp], st[2, ][drp])
), 2)
}
