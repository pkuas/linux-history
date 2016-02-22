## 方法
以月份为时间单位，把每个author在一个月内的changes取出来，按照在每个模块的增删行数对模块排序，确定累计增删行数占比80%的模块，作为这个作者在这个月的主贡献模块。这样，我们就能得到每个作者的月份贡献轨迹。然后，对于每个作者，再对轨迹进行简化，方法是，去掉与其前一个月份相同的贡献模块，例如，'a b b c c b'被简化为'a b c b'。

## 结果
- 具体参见[这里](athrmtrcTreeSmry.md)
- 那些向核心模块做贡献的author，其初始贡献模块
其中，很大一部分author的初始贡献模块是这个核心模块本身。
```
> t <- athrmtrcTree
> x <- src(t, 'mm')
> x
      mm       dr       ar       fs       ne       ke       so    ar-dr
     151       86       52       28       11       10        8        4
   fs-dr    dr-ne    ke-ar dr-ar-fs dr-fs-ar    fs-ke    ke-dr    ke-fs
       4        2        2        1        1        1        1        1
   ne-dr    so-dr
       1        1
> round(prop.table(x) * 100, 2)
      mm       dr       ar       fs       ne       ke       so    ar-dr
   41.37    23.56    14.25     7.67     3.01     2.74     2.19     1.10
   fs-dr    dr-ne    ke-ar dr-ar-fs dr-fs-ar    fs-ke    ke-dr    ke-fs
    1.10     0.55     0.55     0.27     0.27     0.27     0.27     0.27
   ne-dr    so-dr
    0.27     0.27

> x <- src(t, 'ke')
> x
      ke       dr       ar       fs       ne       mm       so    ar-dr
     304      145       96       48       35       26       12        7
   dr-ar    ne-dr    fs-dr    dr-fs    mm-fs    ar-fs    ar-mm    dr-mm
       5        4        3        2        2        1        1        1
   dr-ne    fs-mm    mm-ar    ne-ar    so-dr so-dr-ar
       1        1        1        1        1        1
> round(prop.table(x) * 100, 2)
      ke       dr       ar       fs       ne       mm       so    ar-dr
   43.55    20.77    13.75     6.88     5.01     3.72     1.72     1.00
   dr-ar    ne-dr    fs-dr    dr-fs    mm-fs    ar-fs    ar-mm    dr-mm
    0.72     0.57     0.43     0.29     0.29     0.14     0.14     0.14
   dr-ne    fs-mm    mm-ar    ne-ar    so-dr so-dr-ar
    0.14     0.14     0.14     0.14     0.14     0.14
>
```

- 初始模块为核心模块的author的去向
```
mm -> dr : 12.58%
mm -> ar : 9.27%
mm -> fs : 7.95%
mm -> ke : 6.62%

ke -> dr : 17.76%
ke -> ar : 9.87%
ke -> fs : 4.28%
```
```
> prt(t, dp=3, th=5, lg='^mm')
$mm
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2007.00 2012.00 2011.00 2014.00 2016.00  151.00  100.00    1.25

$`mm ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.17    0.40    0.75    1.29    1.69    4.25   10.00    6.62    0.08

$`mm dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.58    0.94    1.04    5.08   19.00   12.58    0.16

$`mm ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.58    1.67    2.04    2.50    7.00    9.00    5.96    0.07

$`mm ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.19    0.29    0.57    0.50    2.58   14.00    9.27    0.12

$`mm fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.56    0.88    1.17    1.77    2.92   12.00    7.95    0.10

$`mm-ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2005.00 2006.00 2007.00 2008.00 2009.00    6.00  100.00    0.05

$`mm-fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2006.00 2009.00 2009.00 2010.00 2012.00    7.00  100.00    0.06

$`mm dr mm`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.08    0.08    0.12    0.08    0.25    5.00   26.32    0.04

> prt(t, dp=3, th=5, lg='^ke')
$ke
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2010.00 2010.00 2013.00 2016.00  304.00  100.00    2.53

$`ke dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.54    1.08    1.31    7.75   54.00   17.76    0.45

$`ke ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.67    1.31    2.15    6.08   30.00    9.87    0.25

$`ke-dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2008.00 2013.00 2011.00 2014.00 2016.00   11.00  100.00    0.09

$`ke-ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2005.00 2006.00 2008.00 2009.00 2010.00 2016.00   14.00  100.00    0.12

$`ke ne`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.25    0.33    0.68    1.17    1.58    5.00    1.64    0.04

$`ke fs`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.17    0.33    0.50    1.01    1.50    2.92   13.00    4.28    0.11

$`ke-mm`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
2006.00 2007.00 2008.00 2009.00 2010.00 2014.00    6.00  100.00    0.05

$`ke dr ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.13    0.83    1.08    1.38    3.67    7.00   12.96    0.06

$`ke-ar ar`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.08    0.08    0.75    1.33    2.17    5.00   35.71    0.04

$`ke ar ke`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.17    0.25    1.21    0.40    7.75   10.00   33.33    0.08

$`ke ar dr`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     Num     acc    tacc
   0.08    0.27    1.04    1.50    1.81    4.75    6.00   20.00    0.05

```

- 初始模块为外围模块的author的去向
```
dr -> ar : 6.44%
dr -> ne : 2.71%
dr -> fs : 1.67%
dr -> so : 1.30%
dr -> ke : 0.83%
dr -> mm : 0.47%

ar -> dr : 31.35%
ar -> dr-ar : 2.94%
ar -> ke : 2.55%
ar -> fs : 2.16%
ar -> so : 2.09%
ar -> ne : 1.24%
ar -> mm : 1.18%
```


- 对于每个初始贡献模块的author，有的始终在一个模块上的。 查看一下没有始终在一个模块上的比例。
```
> sum(unlist(lapply(prt(t, dp=2, th=0, lg='^dr '), function(x) return(x['acc']))))
[1] 18.19
> sum(unlist(lapply(prt(t, dp=2, th=0, lg='^so '), function(x) return(x['acc']))))
[1] 33
> sum(unlist(lapply(prt(t, dp=2, th=0, lg='^ne '), function(x) return(x['acc']))))
[1] 33.9
> sum(unlist(lapply(prt(t, dp=2, th=0, lg='^fs '), function(x) return(x['acc']))))
[1] 35.98
> sum(unlist(lapply(prt(t, dp=2, th=0, lg='^ke '), function(x) return(x['acc']))))
[1] 44.11
> sum(unlist(lapply(prt(t, dp=2, th=0, lg='^ar '), function(x) return(x['acc'])))) # 很大一部分是dr，30+
[1] 50.19
> sum(unlist(lapply(prt(t, dp=2, th=0, lg='^mm '), function(x) return(x['acc']))))
[1] 56.25
```
