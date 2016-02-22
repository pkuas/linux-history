library(stringr)
fath <- function(pathes){
    return(sub('^(.*) [a-z-]*', '\\1', pathes, perl=T, useBytes=T))
}

# t is a trie
## tire, depth, threshold of number, lg: given parts of path, unq: must occur once exactly
prt <- function(t, dp=1, th=20, lg='^', unq='^') {
    ps <- names(t) # pathes
    pslen <- str_count(ps, ' ')
    num <- unlist(lapply(t, length))
    numDvpr <- sum(num[pslen==0])
    tsel <- rep(FALSE, length(ps))
    tsel[grep(lg, ps)] <- TRUE
    tsel <- tsel & pslen < dp & num >= th & str_count(ps, unq) == 1
    x <- t[tsel]
    res <- lapply(seq_along(x), function(i) {
        smry <- mySummary(x[[i]])
        p <- names(x)[i]
        fp <- fath(p)
        np <- length(t[[p]])
        smry['acc'] <- np / length(t[[fp]])  * 100
        smry['tacc'] <- np / numDvpr * 100
        return(smry)
    })
    names(res) <- names(x)
    res <- lapply(res, round, digits=2)
    res
}
# pathes of becoming lg
src <- function(t, lg) {
    unq <- lg
    lg <- paste('(^| )', lg, '$', sep='')
    res <- prt(t, dp=Inf, th=0, lg=lg, unq=unq)
    num <- unlist(lapply(res, function(x) return(x['Num'])))
    st <- sub('([a-z-]*).*', '\\1', names(res))
    return(sort(tapply(num, st, sum), decreasing=T))
}

# dst
dst <- function(t, )
