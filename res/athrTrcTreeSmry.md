#### author's first module
```
> t1 <- unlist(athrTrcTree[smodsInRoot])
> t1
  dr   mm   fs   ar   ne   ke   li   so   cr   bl   to   se   vi   Do   ip   sc
7667  164  665 1579  917  314   51  549   33   34   81   52   16   18   12   40
  sa   in   fi   us
   1   17    1    2
> prop.table(t1)*100
          dr           mm           fs           ar           ne           ke
62.777368378  1.342831409  5.445017604 12.928846311  7.508392696  2.571030869
          li           so           cr           bl           to           se
 0.417587816  4.495210022  0.270203881  0.278391878  0.663227708  0.425775813
          vi           Do           ip           sc           sa           in
 0.131007942  0.147383935  0.098255957  0.327519856  0.008187996  0.139195939
          fi           us
 0.008187996  0.016375993
```

在多长时间后，author会做模块的转变，单位为年。

> athrTrcTreeSmry <- athrTrcTreeSmry[which(unlist(lapply(athrTrcTree, length)) >= 20)]

```
$`ar dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
  0.0000   0.0852   0.4125   0.9181   1.1820   8.7040 634.0000 

$`ar dr ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
  0.0000   0.0208   0.1148   0.4101   0.3970   4.9440 357.0000 

$`ar dr ar dr`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.01658   0.10220   0.45700   0.47960   6.70100 256.00000 

$`ar dr ar dr ar`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.00932   0.08000   0.26210   0.27740   4.90800 189.00000 

$`ar dr so`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000000  0.007391  0.052100  0.818200  0.742600  4.713000 23.000000 

$`ar fs`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.07755  0.48910  0.88810  1.14900  4.77200 41.00000 

$`ar ke`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.04628  0.30900  0.56030  0.70790  3.61600 60.00000 

$`ar ke ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00000  0.05524  0.12270  0.11860  1.22700 33.00000 

$`ar mm`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.1277  0.3143  0.8100  1.1860  4.9240 34.0000 

$`ar ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.1107  0.5878  1.2820  1.3290  6.9890 23.0000 

$`ar so`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.06823  0.27450  0.78300  1.46300  3.66100 41.00000 

$`ar so ar`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.001264  0.063120  0.106400  0.211000  0.278300  0.840400 21.000000 

$`dr ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
  0.0000   0.1115   0.4669   1.0020   1.3170   9.6540 735.0000 

$`dr ar dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
  0.0000   0.0108   0.0754   0.3533   0.2660   8.1280 523.0000 

$`dr ar dr ar`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.01679   0.12110   0.32530   0.36630   4.96500 296.00000 

$`dr ar dr ar dr`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.01318   0.07377   0.26630   0.28730   4.15100 258.00000 

$`dr ar dr ne`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000001  0.013920  0.468800  0.794600  0.965400  3.268000 21.000000 

$`dr ar so`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000003  0.002843  0.082490  0.622900  0.240300  9.645000 21.000000 

$`dr bl`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.01197  0.23120  0.93210  1.57800  1.86300  9.24500 34.00000 

$`dr bl dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.0216  0.1150  0.1757  0.1786  1.2410 23.0000 

$`dr fs`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.07657   0.41900   1.27100   1.62500   9.90900 178.00000 

$`dr fs dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.01389  0.08342  0.46530  0.44080  6.08300 91.00000 

$`dr fs dr fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.0268  0.1084  0.2053  0.2378  1.3490 26.0000 

$`dr fs dr fs dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00882  0.04458  0.16590  0.08449  1.51500 21.00000 

$`dr ke`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.07464   0.39060   1.01700   1.26600   8.92600 110.00000 

$`dr ke dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.01077  0.05197  0.53930  0.32020  5.56400 54.00000 

$`dr li`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.1778  0.5366  1.0440  1.4510  4.3230 36.0000 

$`dr li dr`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000000  0.002259  0.008934  0.340100  0.169300  4.581000 20.000000 

$`dr mm`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.2091  0.5527  1.4220  1.3540  8.4880 41.0000 

$`dr ne`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
  0.0000   0.2091   0.6704   1.2770   1.6500   9.4640 317.0000 

$`dr ne dr`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.00419   0.04143   0.31130   0.25670   4.76500 225.00000 

$`dr ne dr ne`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.01993   0.10530   0.52270   0.56460   5.60300 118.00000 

$`dr ne dr ne dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00259  0.02268  0.14330  0.07010  1.62900 98.00000 

$`dr so`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00001   0.09104   0.48960   1.16600   1.29500   8.82100 142.00000 

$`dr so dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.00827  0.07926  0.44700  0.38450  7.09600 87.00000 

$`dr so dr so`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000002  0.007016  0.113800  0.514300  0.517800  5.864000 30.000000 

$`dr so dr so dr`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000008  0.003233  0.036540  0.178200  0.165700  1.945000 26.000000 

$`dr to`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00001  0.18710  0.45040  1.38400  1.30400  9.47600 27.00000 

$`fs ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.05021  0.18620  0.83610  1.08400  9.66100 38.00000 

$`fs dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
  0.0000   0.1889   0.8162   1.6870   1.9800   9.9940 109.0000 

$`fs dr fs`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00041  0.02512  0.08670  0.35180  0.25660  3.28600 34.00000 

$`fs ke`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.02959  0.22890  0.53750  0.84880  0.98580  3.33800 21.00000 

$`fs mm`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.1584  0.2675  0.8179  1.4260  3.9160 27.0000 

$`fs ne`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.09476  0.27180  0.91440  1.01700  5.06400 45.00000 

$`fs ne fs`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000000  0.000025  0.050090  0.193200  0.166200  1.322000 25.000000 

$`ke ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.01382  0.09614  0.78580  0.58380  6.05200 34.00000 

$`ke dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.0556  0.1819  0.7552  0.9178  7.7000 67.0000 

$`ke fs`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
 0.000000  0.000002  0.072140  0.541400  0.406400  2.902000 21.000000 

$`mm ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.0158  0.1396  0.4067  0.4914  2.5630 22.0000 

$`mm dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.1185  0.3861  0.7360  0.7772  5.1370 27.0000 

$`mm fs`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.03579  0.50180  0.70850  1.29500  2.89800 23.00000 

$`ne ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00003  0.22890  0.54820  1.28700  1.13300  7.24700 24.00000 

$`ne dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
  0.0000   0.0832   0.4953   0.9813   1.2400   6.7650 230.0000 

$`ne dr ne`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00000   0.03249   0.12610   0.41910   0.46850   3.44600 125.00000 

$`ne dr ne dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.02524  0.09353  0.38170  0.36130  4.83300 79.00000 

$`ne dr ne dr ne`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.02248  0.06353  0.19910  0.19620  2.34600 58.00000 

$`ne fs`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.06838  0.42730  0.68470  1.22600  3.18300 41.00000 

$`ne ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num 
 0.0000  0.1359  0.4966  0.9924  1.5130  5.2630 21.0000 

$`so ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00133  0.11500  0.24640  0.65630  0.63370  6.91000 39.00000 

$`so dr`
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.       Num 
  0.00055   0.13010   0.42280   1.17700   1.43700   9.86100 145.00000 

$`so dr ar`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.01596  0.18910  0.54530  1.01200  1.99500 20.00000 

$`so dr so`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.01279  0.06425  0.42750  0.48700  3.55000 45.00000 

$`so dr so dr`
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      Num 
 0.00000  0.04683  0.11880  0.36280  0.28430  2.78300 29.00000 

```
