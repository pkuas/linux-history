```
> prt(athrmtrcTree, dp=1)
$dr
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2011.00 2011.00 2014.00 2016.00 7605.00  100.00   63.19

$ar
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2010.00 2010.00 2012.00 2016.00 1531.00  100.00   12.72

$ne
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2011.00 2011.00 2013.00 2016.00  887.00  100.00    7.37

$so
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
 2005.0  2007.0  2010.0  2010.0  2013.0  2016.0   542.0   100.0     4.5

$fs
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2010.00 2010.00 2013.00 2016.00  658.00  100.00    5.47

$`dr-ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
 2005.0  2007.0  2010.0  2010.0  2012.0  2015.0    24.0   100.0     0.2

$mm
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2012.00 2011.00 2014.00 2016.00  151.00  100.00    1.25

$`dr-ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2011.00 2010.00 2012.00 2016.00   61.00  100.00    0.51

$ke
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2010.00 2010.00 2013.00 2016.00  304.00  100.00    2.53

$`ne-dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2012.00 2011.00 2014.00 2016.00   25.00  100.00    0.21

$`ar-dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2006.00 2009.00 2009.00 2012.00 2016.00   53.00  100.00    0.44

```

```
> prt(athrmtrcTree, dp=2)
$dr
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2011.00 2011.00 2014.00 2016.00 7605.00  100.00   63.19

$`dr dr-ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.19    0.58    1.32    1.56    8.00   58.00    0.76    0.48

$`dr fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.92    1.66    2.25    9.92  127.00    1.67    1.06

$ar
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2010.00 2010.00 2012.00 2016.00 1531.00  100.00   12.72

$ne
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2011.00 2011.00 2013.00 2016.00  887.00  100.00    7.37

$`ar ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.58    0.83    0.83    3.33   39.00    2.55    0.32

$`dr so`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.42    0.83    1.64    2.17    8.83   99.00    1.30    0.82

$`ar dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.67    1.25    1.58    8.75  480.00   31.35    3.99

$`dr ar-dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.58    1.24    1.46    8.25   67.00    0.88    0.56

$`dr ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.83    1.26    1.67    9.67  490.00    6.44    4.07

$so
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
 2005.0  2007.0  2010.0  2010.0  2013.0  2016.0   542.0   100.0     4.5

$`so dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.67    1.42    1.75    9.83  120.00   22.14    1.00

$`so ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.25    0.80    0.60    6.92   20.00    3.69    0.17

$fs
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2010.00 2010.00 2013.00 2016.00  658.00  100.00    5.47

$`fs dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.42    1.25    2.12    3.04   10.00   91.00   13.83    0.76

$`dr dr-ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.79    1.29    1.50    8.42   90.00    1.18    0.75

$`dr-ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
 2005.0  2007.0  2010.0  2010.0  2012.0  2015.0    24.0   100.0     0.2

$`ar dr-ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.42    0.65    0.92    3.17   45.00    2.94    0.37

$`ar so`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.08    0.42    1.03    1.69    4.83   32.00    2.09    0.27

$`dr dr-fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.42    0.88    1.17    4.67   21.00    0.28    0.17

$`fs ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.58    1.22    1.88    4.58   27.00    4.10    0.22

$`ne dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.67    1.26    1.52    9.08  172.00   19.39    1.43

$mm
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2012.00 2011.00 2014.00 2016.00  151.00  100.00    1.25

$`dr-ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2011.00 2010.00 2012.00 2016.00   61.00  100.00    0.51

$`dr ne-dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.83    1.72    2.00    7.92   29.00    0.38    0.24

$`dr-ar dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.08    0.17    0.45    0.33    2.67   26.00   42.62    0.22

$`dr ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.42    1.00    1.61    2.17    9.50  206.00    2.71    1.71

$ke
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2010.00 2010.00 2013.00 2016.00  304.00  100.00    2.53

$`ne-dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2012.00 2011.00 2014.00 2016.00   25.00  100.00    0.21

$`ar fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.33    0.67    1.20    1.50    4.83   33.00    2.16    0.27

$`fs ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.92    1.36    1.50    9.58   25.00    3.80    0.21

$`ar-dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2006.00 2009.00 2009.00 2012.00 2016.00   53.00  100.00    0.44

$`ne fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.50    0.79    1.25    3.25   29.00    3.27    0.24

$`ke dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.54    1.08    1.31    7.75   54.00   17.76    0.45

$`dr ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.33    0.58    1.32    1.75    8.92   63.00    0.83    0.52

$`ne ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.17    0.46    0.67    1.77    1.75    8.58   23.00    2.59    0.19

$`ke ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.67    1.31    2.15    6.08   30.00    9.87    0.25

$`ar-dr dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.08    0.17    0.75    0.58    4.25   21.00   39.62    0.17

$`dr mm`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.40    0.58    1.43    1.38    8.50   36.00    0.47    0.30

$`ar ar-dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.42    0.59    0.83    3.00   54.00    3.53    0.45
```
