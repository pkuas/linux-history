# 为什么drivers的author to committer的比率要比其他模块都高很多
drivers的author to committer的比率要比其他模块都高很多。从趋势来看，大部分模块的作者/提交者比率在减小。
![x](./pics/author2committer-in-mod.png)


> ### 是不是drivers的author多，但是delta少，即driver模块的committer任务不是太多？

这一点并不是。
See below 
![deltas-in-mod-month.png](./pics/deltas-in-mod-month.png)

> ### 在drivers中，再往下看一层

关于drivers的介绍，请看[drivers的介绍](./docs/drivers-mod.md)
![a2c-in-mod-in-drivers.png](./pics/a2c-in-mod-in-drivers.png)

> ### 从作者、提交者的邮箱域名看其所属公司、组织

基于邮箱域名的推断能否反映实际情况？从delta记录来看，***gmail.com***是使用最多的邮箱域名，占比为9.8%.


> ### How to contribute new device driver to Linux kernel?

* Documentation/development-process/*
* Documentation/SubmittingDrivers
* Documentation/SubmittingPatches
* Documentation/SubmitChecklist

# Merge Aliases
一个开发者可能有多个name、email，使用简单的并查集算法得到每个开发者使用多少个alias。下表的第一行表示alias数量，第二行表示使用这么多数量alias的开发者数量，第三行表示占比。
```
      [,1]    [,2]    [,3]   [,4]   [,5]  [,6] [,7]  [,8]  [,9] [,10] [,11]
[1,]  1.00    2.00    3.00   4.00   5.00  6.00  7.0  8.00  9.00 10.00 11.00
[2,] 91.00 9220.00 1804.00 639.00 256.00 93.00 49.0 29.00 18.00  9.00  5.00
[3,]  0.74   75.41   14.75   5.23   2.09  0.76  0.4  0.24  0.15  0.07  0.04
     [,12] [,13] [,14] [,15] [,16] [,17]
[1,] 12.00 13.00 14.00 15.00 17.00 29.00
[2,]  4.00  1.00  4.00  1.00  3.00  1.00
[3,]  0.03  0.01  0.03  0.01  0.02  0.01
```

# Core Author/Committer Definition
如果按照贡献delta数量来定义，即把delta数量从大到小排序，取累计80%delta对应的作者为core Author/Committer，可能会有这样的问题：一个模块（如drivers）集中了大量的delta，那么这种定义方式就会把其他模块的Author/Committer过滤掉。

还是先搞清楚structure

# structure
要分析structure，可以分析
- 每个author/committer为几个模块做贡献，如何分布
- author/committer如何对应起来，每个author的代码由几个committer提交，每个committer提交几个人的代码，这些量是如何分布的

![x](pics/CFG.dvpr-numMods.png)
![x](pics/CFG.dvprs-numMods.indrivers.png)
![x](pics/CFG.dvprs-numMods.instaging.png)
![x](pics/CFG.coreDvprs-numMods.png)

![开发者相关模块数量](./pics/box.dvprs-adjNumMods.png)
![x](./pics/box.dvprs-adjNumMods.indrivers.png)
![x](./pics/box.dvprs-adjNumMods.instaging.png)


### 我们注意到两个问题
- 只要开发者和某个模块有一次接触，就为这个开发者的模块数加一，这是不合理的。一种修正方法是：对一个开发者而言，确定其贡献最多的模块（根据delta数量,maxdelta），为该开发者模块数加一，对于其他的模块，加上delta数量/maxdelta。
- 把所有的author或者committer混为一谈，是不合适的。由于贡献多的开发者数量少，其涉及的模块较多，故而当把所有的author放一起画boxplot时，boxplot显示的“正常”数据点是贡献少的开发者，而贡献多得开发者成了outlier。
