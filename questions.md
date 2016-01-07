### email was used, not login
### performance
```
x$tot <- tot[match(x$ae,names(tot))];
x$tot <- tot[x$ae]
```
### tot <- tapply(x$tt, x$ae,length); 
this is not number of commits, but # of deltas
