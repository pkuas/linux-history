### 把committer作为author和committer的轨迹结合起来分析

smodsCared <- c('dr', 'ar', 'ne', 'ke', 'mm', 'fs', 'so')

##### 这些committer，作为athr的第一个module
```
> tc
 dr  ar  fs  ne  ke  so  mm
223 108  59  36  21  21  11
> round(prop.table(tc), 4) *100
   dr    ar    fs    ne    ke    so    mm
46.56 22.55 12.32  7.52  4.38  4.38  2.30
>
```

#### 对于mm/ke的cmtr，在成为这个模块的cmtr之前的轨迹如何
分别看：
- 在成为mm/ke的cmtr，首次贡献的模块是什么（tmm, tke)
- 自为linux kernel开始做贡献，到成为mm/ke的cmtr，时间长度（t1, t2），单位年
- 自为linux kernel开始做贡献，到成为mm/ke的cmtr，在呢些模块做过贡献，如何分布（modsbefmm， modsbefke）
```
> tmm 
dr ar ne ke mm fs so
31 17  5  6  5 13  1
> summary(t1)
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
 0.000003  1.747000  3.134000  3.631000  4.877000 10.530000
> table(modsbefmm)
modsbefmm
ar dr fs ke mm ne so
61 69 60 61 55 47 31
>
> tke
dr ar ne ke mm fs so
48 27 11 13  5 14  1
> summary(t2)
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
 0.000006  1.483000  3.250000  3.685000  5.538000 10.250000
> table(modsbefke)
modsbefke
 ar  dr  fs  ke  mm  ne  so
106 111  85  95  65  72  45
```
