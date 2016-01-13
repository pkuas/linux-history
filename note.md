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
一个开发者可能有多个name、email，使用简单的并查集算法得到每个开发者使用多少个alias。下表的第一行表示alias数量，第二行表示使用这么多数量alias的开发者数量。

|# aliases|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|17|29|
|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
|# dvprs|91|9220|1804|639|256|93|49|29|18|9|5|4|1|4|1|3|1|
|%|0.74|75.41|14.75|5.23|2.09|0.76|0.40|0.24|0.15|0.07|0.04|0.03|0.01|0.03|0.01|0.02|0.01|
