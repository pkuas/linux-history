library(stringr)
fath <- function(pathes){
    return(sub('^(.*) [a-z-]*', '\\1', pathes, perl=T, useBytes=T))
}

# t is a trie
## tire, depth, threshold of number
prt <- function(t, dp=1, th=20, lg='^') {
    ps <- names(t) # pathes
    pslen <- str_count(ps, ' ')
    num <- unlist(lapply(t, length))
    numDvpr <- sum(num[pslen==0])
    tsel <- rep(FALSE, length(ps))
    tsel[grep(lg, ps)] <- TRUE
    tsel <- tsel & pslen < dp & num >= th
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
