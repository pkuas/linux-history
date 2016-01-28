
#### committer's first module
```
> t1 <- unlist(cmtrTrcTree[smodsInRoot])
> t1
 dr  mm  fs  ar  ne  ke  li  so  to  se  Do  ip  sc
201   4  61 156  36  16   6   5   4   9   1   1   3
> prop.table(t1) * 100
        dr         mm         fs         ar         ne         ke         li
39.9602386  0.7952286 12.1272366 31.0139165  7.1570577  3.1809145  1.1928429
        so         to         se         Do         ip         sc
 0.9940358  0.7952286  1.7892644  0.1988072  0.1988072  0.5964215
```

> cmtrTrcTreeSmry <- cmtrTrcTreeSmry[which(unlist(lapply(cmtrTrcTree, length)) >= 5)]

```
$`ar dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.0000  0.0586  0.4360  0.3152  7.4550 91.0000 

$`ar dr ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00000  0.00000  0.15950  0.02434  3.43500 77.00000 

$`ar dr ar dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00000  0.00011  0.14350  0.13760  1.56100 57.00000 

$`ar dr ar dr ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00000  0.00002  0.08157  0.05046  1.60700 54.00000 

$`ar ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
0.00000 0.02165 0.65140 1.16500 2.02100 3.39500 6.00000 

$`ar ke ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.000000 0.000000 0.004507 0.000038 0.026990 6.000000 

$`ar vi`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.007935 0.084350 0.219600 0.421600 0.584300 5.000000 

$`ar vi ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.000000 0.000000 0.000032 0.000000 0.000161 5.000000 

$`dr ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00000  0.02501  0.29730  0.29060  2.89500 60.00000 

$`dr ar dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00000  0.00000  0.10820  0.00031  2.02900 53.00000 

$`dr ar dr ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00000  0.01341  0.14560  0.22910  1.91500 40.00000 

$`dr ar dr ar dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00000  0.00000  0.06075  0.01996  1.11200 35.00000 

$`dr fs`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000000  0.000142  0.009745  0.657400  0.465800  5.074000 14.000000 

$`dr fs dr`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000000  0.000000  0.000001  0.078470  0.001461  0.831900 11.000000 

$`dr ke`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000009 0.091750 0.388500 0.396400 0.428800 1.166000 6.000000 

$`dr ke dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
  0e+00   0e+00   0e+00   0e+00   0e+00   2e-06   6e+00 

$`dr li`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
0.01838 0.27590 0.64330 1.03400 1.94100 2.29000 5.00000 

$`dr ne`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00089  0.09009  0.82740  0.39840  7.13100 13.00000 

$`dr ne dr`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000000  0.000000  0.000000  0.001005  0.000050  0.005600 13.000000 

$`dr ne dr ne`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.000096 0.000616 0.041820 0.015630 0.257500 9.000000 

$`dr ne dr ne dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.000005 0.000012 0.015560 0.004562 0.102800 9.000000 

$`fs ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
0.00000 0.05169 0.64310 0.54250 0.89040 1.12700 5.00000 

$`fs mm`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000000  0.001309  0.509600  1.470000  1.599000  6.480000 10.000000 

$`fs mm fs`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.000000 0.000000 0.002425 0.000001 0.013690 9.000000 

$`fs ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
0.00000 0.01939 0.40020 0.79530 1.28800 2.55100 7.00000 

$`fs ne fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
      0       0       0       0       0       0       6 

$`ke fs`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.000000 0.000000 0.247200 0.000008 1.483000 6.000000 

$`ne dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.003635 0.027640 0.343100 0.098030 2.487000 8.000000 

$`ne dr ne`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
0.000000 0.000000 0.000000 0.007741 0.000373 0.038330 5.000000 
```
