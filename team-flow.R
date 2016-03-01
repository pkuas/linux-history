# team's flow
window <- 3
mods <- c('drivers', 'arch', 'net', 'sound', 'fs', 'kernel', 'mm')
for (i in 1:length(mods)) {
    mod <- mods[i]
    st <- 2005
    ed <- st + window
    tsel <- delta$m >= st & delta$m < ed & delta$m == mod
    pa <- table(delta$aid[tsel])
    st <- st + 1/12
    ed <- st + window
    while (ed < 2015.917) {
        tsel <- delta$m >= st & delta$m < ed & delta$m == mod
        a <- table(delta$aid[tsel])
        

    	st <- st + 1/12
    	ed <- st + window
    }

}
