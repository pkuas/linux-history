# 为什么drivers的author to committer的比率要比其他模块都高很多
drivers的author to committer的比率要比其他模块都高很多。从趋势来看，大部分模块的作者/提交者比率在减小。
![x](./pics/author2committer-in-mod.png)


> ### 是不是drivers的author多，但是delta少，即driver模块的committer任务不是太多？

这一点并不是。
See below 
![deltas-in-mod-month.png](./pics/deltas-in-mod-month.png)
> ### 从作者、提交者的邮箱域名看其所属公司、组织

基于邮箱域名的推断能否反映实际情况？从delta记录来看，***gmail.com***是使用最多的邮箱域名，占比为9.8%.


> ### How to contribute new device driver to Linux kernel?

* Documentation/development-process/*
* Documentation/SubmittingDrivers
* Documentation/SubmittingPatches
* Documentation/SubmitChecklist

# Merge Alias
最初的ae-an列表转换为新的alias-name
一个的alias数量：
```
   1    2    3    4    5    6    7    8    9   10   11   12   13   14   16
 154 9195 1908  672  277  107   33   30   14   11    2    2    2    1    1
```
