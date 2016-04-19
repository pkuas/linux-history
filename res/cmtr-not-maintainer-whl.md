## 2015各个模块的非maintainer的committer
## 不区分maintainer为哪个模块的maintainer，而把其当作整个系统的maintainer.在区分maintainer所属模块的情况下，见[这里](./cmtr-not-maintainer.md).
### "drivers"
```
 [1] "ben skeggs"                     "thellstrom@vmware.com"         
 [3] "eric anholt"                    "rclark@redhat.com"             
 [5] "goldwyn rodrigues"              "coelho@ti.com"                 
 [7] "james liao"                     "frederic weisbecker"           
 [9] "u.kleine-koenig@pengutronix.de" "bryan wu"                      
[11] "p_gortmaker@yahoo.com"          "dominik brodowski"             
[13] "jsarha@ti.com"                  "rdreier@cisco.com"             
[15] "ricardo neri"                   "john linville"                 
```
### "arch"
```
[1] "p_gortmaker@yahoo.com" "marcelo tosatti"       "frederic weisbecker"  
[4] "markos chandras"       "jon medhurst"         
```
### "net"
```
[1] "p_gortmaker@yahoo.com"
```
### "sound"
```
```
### "fs"
```
[1] "fdmanana@gmail.com"     "p_gortmaker@yahoo.com"  "loghyr@primarydata.com"
[4] "ricardo neri"          
```
### "kernel"
```
[1] "frederic weisbecker"   "p_gortmaker@yahoo.com" "marcelo tosatti"      
[4] "jon medhurst"         
```
### "mm"
```
[1] "p_gortmaker@yahoo.com"
```
### 把以上结果并起来，得到整个系统的非maintainer的committer
```
 [1] "p_gortmaker@yahoo.com"          "marcelo tosatti"               
 [3] "frederic weisbecker"            "markos chandras"               
 [5] "jon medhurst"                   "ricardo neri"                  
 [7] "ben skeggs"                     "thellstrom@vmware.com"         
 [9] "eric anholt"                    "rclark@redhat.com"             
[11] "goldwyn rodrigues"              "coelho@ti.com"                 
[13] "james liao"                     "u.kleine-koenig@pengutronix.de"
[15] "bryan wu"                       "dominik brodowski"             
[17] "jsarha@ti.com"                  "rdreier@cisco.com"             
[19] "john linville"                  "fdmanana@gmail.com"            
[21] "loghyr@primarydata.com"                      
```