﻿# 这个文件没有细心整理，有不少错误，慎看！
<br/>
<br/>
<br/>
<br/>
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

### 2016-1-15， openthos
1. 加入时间事件
2. 难
- 旧人在，新人很难入
- 本身对技术能力要求高，难

### 对drivers模块的贡献、提交机制，人员结构进行分析
### 网络上的资源，再多一些具体的分析

# Core Author/Committer Definition
如果按照贡献delta数量来定义，即把delta数量从大到小排序，取累计80%delta对应的作者为core Author/Committer，可能会有这样的问题：一个模块（如drivers）集中了大量的delta，那么这种定义方式就会把其他模块的Author/Committer过滤掉。

还是先搞清楚structure

# Structure
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

### Log 2016-1-18
- 先不急adjust
- 关于“把所有的author或者committer混为一谈”得到的boxploy：不要忘了目标，不是要得到更好看的图：）
- （drivers下，）哪些是author不是committer但又想成为committer的人？（要认识到有大量的写了代码但是没有被接受的人。）先不要adjust
- 从author变为committer的比率，时间：总的，各模块上. touch第二个模块的时间.(big topic:参与轨迹)
- LOC until given time / tenure till given time
- New comer, new committer：趋势，实事（如安卓）
- staging的变化：本身的变化，其子目录的变化，是否从staging移出来得到支持了
- touch的模块要考虑时间的长短，看一下是否变化
- 是否有做了很久author但是仍然不是committer（查阅一下成为committer的审核机制）
- 为什么会有提交数量极少的committer
- 时间跨度还是以月为宜

##### 参与体系
- 人员结构
- 参与轨迹：

##### 始终一点： 有什么难，为什么难

### 搞清楚贡献体系
- 组织结构，人员结构
    + 搞清楚各类角色：maintainer, committer(same as maintainer?), reviewer, author, etc.
    + 各类角色的变化：关于maintainer, 看MAINTAINER文件的各个版本；committer和author，看git log的格式化信息，这部分我们已经取出；reviewer，看每个提交的comment信息；Linux Kernel的诸如[Documentation/SubmittingPatches](https://www.kernel.org/doc/Documentation/SubmittingPatches)这些开发者文档中对patch的格式做了要求、说明，在comment信息中，包括的信息有：Signed-off-by, Acked-by, Cc, Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes。
    + 根据这些分析，特别是drivers，分析难处
    + 特别注意new comer

### 轨迹
- 从author变为committer的比率，时间：总的，各模块上. touch第二个模块的时间.(big topic:参与轨迹)

    + 总的

![x](./pics/box.tmAthr2Cmtr.AthrAlways-athr.png)
![x](./pics/box.numChgsBef-tmAthr2Cmtr.AthrAlways-athr.png)

```
> quantile(trc$numChgsBef[trc$tp=='Always author'], c(0.7, 0.8, 0.9, 0.95, 0.97, 0.98, 0.99, 1)) # num: 11717
    70%     80%     90%     95%     97%     98%     99%    100%
   9.00   19.00   55.00  121.20  211.52  297.00  481.20 8485.00
> quantile(trc$numChgsBef[trc$tp=='Become committer'], c(0.7, 0.8, 0.9, 0.95, 0.97, 0.98, 0.99, 1)) # num: 483
    70%     80%     90%     95%     97%     98%     99%    100%
 214.00  301.00  509.00  794.25 1136.45 1324.20 1547.40 5832.00
```

- 以个人为分析对象
    +

- 可以尝试一下codeface

相关论文： From Developer Networks to Verified Communities: A Fine-Grained Approach



## trace 分析
关于author、committer的贡献模块转变，查看这里：[author](./res/athrTrcTreeSmry.md), [committer](./res/cmtrTrcTreeSmry.md)

在这个转变分析中，还没有区分那些“一次贡献者”、只在一个模块贡献的“持久贡献者”。

### 简化方法
- 一个revision可能有多个mod（实际上这样的revision是少数），可以先把增减行数最多的mod确定为main mod
- 加入时间因素：考虑一段时间内开始贡献的dvpr

也就是：以月份为时间单位，把每个author在一个月内的changes取出来，按照在每个模块的增删行数对模块排序，确定累计增删行数占比80%的模块，作为这个作者在这个月的主贡献模块。这样，我们就能得到每个作者的月份贡献轨迹。然后，对于每个作者，再对轨迹进行简化，方法是，去掉与其前一个月份相同的贡献模块，例如，'a b b c c b'被简化为'a b c b'。

## Narrow 1
- 别想着对‘难’下个定义，量化它，这是弊大于利的：把问题复杂化，却可得太少
- 也许，我们只需列出几个事实，最好是不易发现的，让大家感受到‘嗯，这确实是不太利于开发呀’。那么这些事实可以是哪些呢？首先，我们要从整体环境来看Linux kernel的开发趋势，这会受到多重因素的影响，比如技术因素（Android、新型文件系统、流行新硬件的驱动等）、经济因素等，因为Linux kenel在实际中地位非凡、用户颇多，很受关注。这些因素的影响，在开发数据中可能会有体现，因此我们用一些量度去看这些影响。具体的度量可能包括： # of chgs，# of athrs, # of cmtrs等，看这些量度是如何变化的。
    + LTC 比例下降
    + 稳定成熟的（子）模块，是否很难贡献（直觉如此）
    + 新兴（子）模块
    + 开发者集中地drivers，是否被公司‘控制’？

# product structure
## how the organization of contribution team and culture are affected by product structure in Linux kernel?
- what is product stucture?
    + 从目录层次来看。（arch和drivers，从文件层次来看，都是loose的，arch的ratio为何低，和mm差不多。）
    + 从各个目录的形成来看，drivers是各个硬件驱动代码的合集，mm则不然。（这个由文字叙述，需要相关资料的支持）
    + 从函数调用关系来看。

- what is organization of contribution team and culture?
用3年时间窗口不合理，我猜想老师原来用3年是用来平滑的，但是当把他解释为团队规模时，就不合理了。对于drivers来说，以月为时间单元，得到的ratio值为6左右，以三年为时间单元，就是20+。


3. introduction中到模块的过渡不好。
4. 关于linux kernel的commit机制，如何成为committer需要进一步了解和阐述。这是因为，ratio的含义还应该结合具体的环境。
5. volunteers. commercial participation
6.
> it is of interest to understand if
the contribution practice of different modules of Linux kernel differs from each other, and how they evolve over time
adapting to different business environments

# product structure
- 从目录层次来看。（arch和drivers，从文件层次来看，都是loose的，arch的ratio为何低，和mm差不多。）
- 从各个目录的形成来看，drivers是各个硬件驱动代码的合集，mm则不然。（这个由文字叙述，需要相关资料的支持）
- 从函数调用关系来看。
-

# team organization
怎样描述team organization呢？
而且，当我们讨论不同模块

- 用a2c ratio可能不合理。例如，2010~2010.5年的mm，author和committer的对应情况如下：
![x](./pics/a2c/mm-2010-05.png)

要用a2c，首先要理解'commit'到底是意味着什么。

>
From: lf_pub_whowriteslinux2015.pdf
<br/>
Who is Reviewing the Work
Patches do not normally pass directly into the mainline kernel; instead, they pass through one of over 100 subsystem trees. Each subsystem tree is dedicated to a specific part of the kernel (examples might be SCSI drivers, x86 architecture code, or networking) and is under the control of a specific maintainer.
<br/>
When a subsystem maintainer accepts a patch into a subsystem tree, he or she will attach a “Signed-off-by” line to it. This line is a statement that the patch can be legally incorporated into the kernel; the sequence of signoff lines can be used to establish the path by which each change got into the kernel.
<br/>
An interesting (if approximate) view of kernel development can be had by looking at signoff lines, and, in particular, at signoff lines added by developers who are not the original authors of the patches in question. These additional signoffs are usually an indication of review by a subsystem maintainer. Analysis of signoff lines gives a picture of who admits code into the kernel–who the gatekeepers are.

```
[pkuas@bear linux]$ git log --no-merges -n 10000 | grep 'Signed-off-by' | wc -l
20244
[pkuas@bear linux]$ git log --no-merges -n 100000 | grep 'Signed-off-by' | wc -l
197072
[pkuas@bear linux]$ git log --no-merges -n 10000 | grep 'Signed-off-by' | wc -l
20244
[pkuas@bear linux]$ git log --no-merges -n 20000 | grep 'Signed-off-by' | wc -l
39907
[pkuas@bear linux]$ git log --no-merges -n 30000 | grep 'Signed-off-by' | wc -l
59516
[pkuas@bear linux]$ git log --no-merges -n 40000 | grep 'Signed-off-by' | wc -l
78647
[pkuas@bear linux]$ git log --no-merges -n 50000 | grep 'Signed-off-by' | wc -l
98679
[pkuas@bear linux]$ git log --no-merges -n 60000 | grep 'Signed-off-by' | wc -l
118674
```

- 总结以上，从author和committer的对应关系来看。可以定义几种量度：
    + \#cmtr, #athr, #ratio
    + \#core cmtr,#core athr, #core ratio(定义这个量度，原因在与下面，就是发现了在cmtr中二八情况很明显。)
    + \# entropy cmtr, # entropy athr, # entropy ratio（可以处理这样的问题：79%，80%，，，，这个问题core ratio不合理）
- 从一个author的（一段时间内的）co-change的文件网络来看。


关于如何理解团队组织，我们目前有一些感觉了：首先，我们的确可以根据athr和cmtr的数量比率来衡量某些东西，但也有要注意的地方。单纯地使用ratio，可以揭示些东西，但也掩盖了一些东西，原因是ratio对二八原则没有很好的处理。为此，我们可以引入entropy ratio，来揭示核心团队的情况。
![x](./pics/a2c/ratio-in-mod.png)
![x](./pics/a2c/eratio-in-mod.png)

?
- ratio的收敛情况分析
drivers、net、sound一类似乎收敛
kernel、arch、fs一类收敛
- 起始状态为何如此诡异
起始时，团队不稳定，流入流出不稳定

- 为何drivers和arch的ratio差这么多，即便目录机构挺相似的

关于模块结构对团队的影响，我们目前有一些感觉了：单纯地根据ratio

## 规模和流动性
## 以版本发布时间为分隔，分析模块结构变化对团队结构的影响
## 模块结构的变化，团队结构的变化，时间偏移
## code ownership

# Narrow 2
>how does module structure affect contribution organization?

- 假设：以下两个因素对ratio值有影响。
    + module structures
    + contributor features

- 展示我们观察的结果：不同module呈现了不同的ratio
- 根据假设解释我们观察的结果。

## module structure
不同的模块有不同的特征，由于这些不同的特征可能会对ratio值得差异产生了影响。而这些模块具有不同特征的论据包括：
- directory structure，用耦合度来表示,就是下面一个。
- 耦合度。（本来应该用调用关系来衡量耦合度，问一下：能否用code ownership来衡量呢？#owner each file衡量的是团队相关的东西，数值大意味着该文件由多人协作开发，在一个module中，整体的数值大，推出该模块的耦合度高。这样合不合理呢？)(PS: 和Z的计算结果差好多？)可以用ownership来验证耦合度的不同。
![x](./pics/ownership-mod.png)

考虑几个点：耦合度会随时间变化；目录之下可能还是目录，模块之下还是模块，应以最细粒度的模块为准；考虑模块的子模块的不同规模，假如一段时间内基本只向一个子模块写代码，那么其实该模块应该只算一个子模块。

想了个方法：见code/entropy-modulize.R
![x](./pics/modularization-mod.png)

##

## contributor features
不同的
- contributor type
猜想：drivers的dvpr多来自公司。在drivers中，很多athr的chgs数量很少，即#athr的水分太多，

- objective of contribution

## team organization
#### drop fake cmtrs
![x](./pics/a2c/a2c-mod-fake-true-cmtr.png)

对于使用entropy来计算ratio的，drop fake cmtrs与否，结果基本一样。

# Narrow 3
> 具有不同特性的module，在team organization上是否有差异呢？

注意：
- 首先，引导受众：具有不同特性的module，在team organization上是有差异的。
- 然后，陈述模块之间在若干特性的差异。
- 再而，陈述不同模块的organization的差异。
- 要注意，不强调：模块本身的演化、这些不同特性对organization的差异之间因果关系、甚至相关关系。
- 要对各个量，给予详尽的、合理的解释


## 不同模块的不同特性
#### module structure
- modularity

#### participant feature
- contributor type
    + volunteers(geeks) and employees
- objective of contribution
    +

## 不同模块的organization的差异
- ratio of #A to #C
有的cmtr在某个模块仅提交了几次，所以我很怀疑：虽然cmtr会有其负责的主要子系统，但是每个cmtr有向整个repo的写权限。如果是这样的话，#C的计算方式就要变一变了。应该确定每个cmtr贡献的模块，当然向linus torvalds这类非常核心的人还是会有多个模块。
故而先搞清楚，模块中那些提交很少的人是什么情况。
```
- drivers--> fs: 'efivarfs: Move to fs/efivarfs' maintainer remains the same (10000)
- 80
```
看那些在mm中只有少量commit的cmtr，他们是什么情况？

- mm共86个cmtr（排除fake cmtr), 76.55%的提交由linus torvalds进行，
```
> head(cumsum(t) / sum(t), 10)
    linus torvalds       pekka enberg   htejun@gmail.com            al viro         axboe@carl
         0.7655486          0.8105001          0.8393240          0.8648881          0.8867633
       ingo molnar ak@linux.intel.com   from: mel gorman     h. peter anvin    catalin marinas
         0.9055503          0.9144720          0.9204770          0.9263104          0.9318864

t <- sort(t, decreasing = F)
m <- names(t[1])
table(delta$mod[delta$cid == m])
```
strange cmtrs  of mm
```
abergman@de.ibm.com: commit maily for arch and drivers. made a commit (authored by himself) for mm with cmt 'mm/slob: use min_t() to compare ARCH_SLAB_MINALIGN'
airlied: mainly for drivers. for mm once: 'Export shmem_file_setup for DRM-GEM'. aid != cid . 1+, 0- (mm/shmem.c)

```
Many maintainers of subsystems of Linux kernel have their own repositories, and many of these repos (I manually inspected several listed below) are full versions of Linux kernel at some point.
- https://github.com/agraf/linux-2.6
- https://github.com/linux-wpan/linux-wpan-next
- https://github.com/ceph/ceph-client
- https://github.com/jonmason/ntb
- https://github.com/czankel/xtensa-linux

following is not a full version.
- https://github.com/linux-test-project/ltp
- github.com/KrasnikovEugene/wcn36xx
- https://github.com/lmajewski/linux-samsung-thermal

重新审视drivers的ratio如何这么高，发现changes数量颇多的staging，其核心的committer就是一个，然而author很多，我猜想是因为staging对代码质量的要求低于很多其他的目录。
所以，不能从模块化程度来分析organization, 毕竟，一个大模块如drivers由若干个模块构成，那么team size和也不会直接受影响，例如每个子模块的team规模和mm的team规模一样也是可能的。所以抛弃模块化程度吧。

一个可能的因素是对模块质量的要求，
- code ownership(#A per file, or #C per file)

##   EXPLORE
[Role of a Linux Kernel Maintainer](https://www.linux.com/news/featured-blogs/199:greg-kroah-hartman/591212:role-of-a-linux-kernel-maintainer)

## A2C
与Z。对于一个模块，即便由一个或/2个主要的cmtr来为author提交代码，但是#A/#C仍然有其意义，因为这就是由数据算出来的，而且在各个模块之间的确呈现出了显著的区别。但是，#A/#C到底是什么意思呢？它的确是开发社区的一个量度，但，怎么说呢？

## volunteers or paid dvprs
```
> for (m in c('dr', 'ar', 'ne', 'so', 'fs', 'ke', 'mm')) {
+     sel <- delta$md2 == m
+     t <- sort(table(delta$aed[sel]), decreasing = T)
+     print(m); print(head(t)/sum(t)); print(t['gmail.com']/sum(t))
+ }
[1] "dr"

      gmail.com       intel.com      redhat.com     samsung.com         suse.de linux.intel.com
     0.12260581      0.08204828      0.06968472      0.02115728      0.02082690      0.02047506
gmail.com
0.1226058
[1] "ar"

     gmail.com     redhat.com     linaro.org         ti.com linux-mips.org  linutronix.de
    0.05772161     0.03874491     0.03353407     0.03091546     0.02770980     0.02468224
 gmail.com
0.05772161
[1] "ne"

    gmail.com     intel.com     trash.net    redhat.com    google.com davemloft.net
   0.09475896    0.07017686    0.04998586    0.04335879    0.03582926    0.03153244
 gmail.com
0.09475896
[1] "so"

                    suse.de opensource.wolfsonmicro.com                   gmail.com
                 0.24544154                  0.09751519                  0.07281611
                 metafoo.de                  ladisch.de                      ti.com
                 0.05362889                  0.03459063                  0.02562269
 gmail.com
0.07281611
[1] "fs"

        redhat.com         oracle.com zeniv.linux.org.uk          gmail.com         netapp.com
        0.15924805         0.08561414         0.06315977         0.05498583         0.04866027
     infradead.org
        0.03891178
 gmail.com
0.05498583
[1] "ke"

        redhat.com          gmail.com      linutronix.de         kernel.org linux.vnet.ibm.com
        0.13126512         0.07366920         0.05379364         0.05133080         0.04796059
         chello.nl
        0.04752852
gmail.com
0.0736692
[1] "mm"

     gmail.com     google.com        suse.de     redhat.com     kernel.org jp.fujitsu.com
    0.06399588     0.06399588     0.06116497     0.05979240     0.05172858     0.05009865
 gmail.com
0.06399588
```

## Restart and Explore
- Community structure: may refer to: Toward an Understanding of the Motivation of Open Source ....

- **topic: how does product structure shape community organization**
- **topic: dynamics of community** (different communities in different stages)
-

in a community, dvprs have different roles: project leader, core members, active dvprs, peripheral dvprs, bug fixers, bug reporters, readers, passive users.

**we can define several aspects of community structre.**

during a given period:

- size, percentage of different roles(Lorenz curve), coupling degree of community.
- diversity of experience in a community.
-


- Different modules may have different community structure.

>Here's a picture of our development model, in a simplified form.
We have about 3000 different developers. They make a patch, and send it through email to the file/driver maintainer. We have about 700 different maintainers listed in the kernel tree at the moment. That maintainer reviews it, and if they accept it, they forward it on to the subsystem maintainer. We have around 85 different subsystem maintainers at the moment, and there are about 160 different subsystem trees that get merged to Linus.
Those maintainers have public kernel trees that all get merged into the linux-next release every day. Then, when the merge window opens up, the subsystem maintainers send their stuff to Linus.(2013)

refer to: 'THE LIFECYCLE OF A PATCH' in Documentation/development-process/2.Process


- we may mean 'module' by considering that one mailing list contributes to.

(drivers|arch|fs)/[0-9a-zA-Z]+/$

But one may argue that if you define 'module' using mailing list, it will be a recursive problem in the sense that module is defined using team's feature and the objective of this research is to understand how module structure shapes team organization. Is that ok?

Yeah, we have more considerations. First, actually, we would take 'subsystem' as objects of this research. In Linux kernel, many subsystems have their own ailing lists and source trees. Therefore, forget things about 'module'. we're understanding 'subsystem'.

- we can select several modules from different domains like mm, kernel, drivers, fs, etc.

#### team structure
select bluetooth drivers to inspect:
- from maintainers(one very new version):
see: BLUETOOTH SUBSYSTEM, BLUETOOTH DRIVERS

M:  Marcel Holtmann <marcel@holtmann.org>
M:  Gustavo Padovan <gustavo@padovan.org>
M:  Johan Hedberg <johan.hedberg@gmail.com>

- from cids:
```                  from: greg kroah-hartman
                                        24
                            linus torvalds
                                        70
                               dave miller
                                        80
                         dominik brodowski
                                       122
                        gustavo f. padovan
                                       215
                             johan hedberg
                                       236
                           marcel holtmann
                                       454

```

use 'git show <SHA1>:<FILE>' to view content of the file at the time of the given commit.

#### select subsystem/module
- bluetooth

> BLUETOOTH DRIVERS
M:  Marcel Holtmann <marcel@holtmann.org>
M:  Gustavo Padovan <gustavo@padovan.org>
M:  Johan Hedberg <johan.hedberg@gmail.com>
L:  linux-bluetooth@vger.kernel.org
W:  http://www.bluez.org/
T:  git git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git
T:  git git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git
S:  Maintained
F:  drivers/bluetooth/
-
F:  net/bluetooth/
F:  include/net/bluetooth/
目录下皆是文件

net's "bluetooth"  "nfc"        "ieee802154" "atm" can be found in drivers.
net's "wireless"   "irda"       "caif"       "ieee802154" "dsa" "can"        "ethernet"   "wimax"      "appletalk" can be found in drivers/net.


- scsi

> M:    "James E.J. Bottomley" <JBottomley@odin.com>
T:  git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
M:  "Martin K. Petersen" <martin.petersen@oracle.com>
T:  git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
L:  linux-scsi@vger.kernel.org
S:  Maintained
F:  drivers/scsi/
F:  include/scsi/
目录下有很多文件，也有一些目录


- usb

> USB SUBSYSTEM
M:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
L:  linux-usb@vger.kernel.org
W:  http://www.linux-usb.org
T:  git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
S:  Supported
F:  Documentation/usb/
F:  drivers/usb/
F:  include/linux/usb.h
F:  include/linux/usb/


## idea: how does community change?


> discuss:
things are full of variety, but still represent some stability.
For a subsystem, how authors correspond to maintainers and/or committers?
IEEE transaction on se
ACM trans on se methodology
TSE(IEEE Transactions on Software Engineering, IEEE T SOFTWARE ENG, 双月刊, 2.588, 1.980)
TOSEM(ACM Transactions on Software Engineering and Methodology, ACM T SOFTW ENG METH, 季刊,  1.548, 1.269)

## Signed-off-by
- mm has avg 3
$ git log --no-merges  mm | grep 'Signed-off-by' | wc -l
23817
$ git log --no-merges  mm | grep 'Author:' | wc -l
8844

- fs 2, kernel 2, arch 2, net 2, sound 2, dr 2


## Important: System evolution and community evolution
- how community and System evolve
- 不同system的community的不同演化

或者： 不谈evolution， 毕竟题目太大。换个： 理解开源软件贡献团队的变化性。

community
- size
- structure
- code ownership
- 成员的变化性

System
- 技术的重大变更
- 外部依赖（drivers对mm的依赖）
- 日常维护

changes数量多表示什么，数量少又表示什么？需要解释清楚。可能和#new file有关系，但不一定是在同一个版本内。
core和peripheral各自的成分又是什么？相互转化存在吗，是否存在什么规律？各个subsystem之间是否有什么不同？

## 开发者团队结构的变化规律（抽象级别）
- 如何描述、量化结构
- 有什么变化规律
- 与该团队相联系的软件系统或模块的变化与开发者结构的变化有什么关系？若有，如何解释这样的关系？

??
age小，#chgs多：大new feature，
age小，#chgs少：小new feature，临时文件
age大，#chgs多：重构，
age大，#chgs少：稳定状态，

code ownership(own)

    \#chgs & #core | #chgs & #peri | #peri & #core | owner & #chgs | owner & #core | owner & #peri

root:   0.58 0.82 0.92 0.42 ---- ---- (200, 1000, 19000)

drivers:0.70 0.92 0.90 ---- ---- ---- (160, 800, 10000)
arch:   ---- 0.67 0.55 0.56 ---- 0.46 (80, 300, 3300)
net:    ---- 0.55 0.59 0.65 ---- 0.50 (40, 150, 1800)
fs:     ---- 0.77 0.53 0.59 0.61 0.59 (25, 130, 1500)
kernel: ---- 0.91 ---- 0.57 ---- 0.46 (20, 80, 600)
mm:     ---- 0.92 ---- 0.56 ---- 0.61 (20, 60, 300)

arm:    0.52 0.89 0.79 0.72 0.70 0.78 (40, 150, 1500)
x86:    ---- 0.95 ---- 0.78 ---- 0.78 (25, 90, 600)
usb:    ---- 0.84 ---- ---- ---- 0.35 (20, 80, 400)
power:  ---- 0.73 0.55 0.63 ---- 0.39 (20, 60, 300)
scsi:   ---- 0.82 ---- 0.74 ---- 0.60 (20, 60, 300)
mips:  -0.39 0.69 ---- 0.42 ---- 0.58 (10, 30, 300)
btrfs:  ---- 0.40 0.62 0.41 0.67 0.85 (8, 25, 250)
xfs:   -0.37 0.51 ---- 0.45 0.30 0.51 (3, 10, 200)
ext4:   ---- 0.82 ---- 0.65 0.35 0.74 (8, 20, 100)
nfs:    ---- 0.75 0.28 0.73 0.39 0.71 (5, 15, 100)
cifs:   ---- 0.42 ---- 0.41 0.33 0.63 (2, 8, 80)
ide:    ---- 0.83 ---- 0.60 0.44 0.83 (5, 15, 100)

for 'root' and 'drivers', positive correlation between #core and #chgs perhaps can be explained by increasing number of subsystems. Inspired by this, maybe we can identify several types of status from macro perspective, say developing, developed (or maintained).

We notice that no significant correlation between #core and #chgs. More specifical, #core is more stable than #peri. When #chgs is high, #core can be very low or , where these changes are mainly writen by a few authors; ---(Can we identify cases with high #chgs and high #core, and cases with high #chgs and low #core?)

基尼系数和#chgs的正相关，和core的负相关，和peri的正相关。

也可能是这样的解释：不管change多还是少，其实团队的成员可能没什么大的变化，只是在change少的时候实际上的core开发者贡献的数量也就不多，此时其core体现地不是那么的明显，而在changes数量多的时候，其core的特征就得到很好的体现了。所以，如果从这个角度来看，团队本身可能没有变，只是在不同的项目状态下有不同的呈现形式。

主题：理解项目不同状态下的团队状态。项目的状态可以用changs数量和age来度量，团队的状态可以用团队结构来度量，但我想还可以更多，否则不够丰富。可能的比如，#athr, #core, #peri, gini index, new comer,------.

### new observation:
- in most cases, weighted age of authors is greater than age of authors.(Ob1)
- (expected age of changes - age of changes), (expected age of authors - age of authors) have positive correlation. (Ob2)
- (expected age of changes - age of changes), (expected weighted age of authors - weighted age of authors) have positive correlation. (Ob3)

Ob2 by itself suggests that new features may attract new comers, or that new features are more likely to be developed by new comers. Ob3 has the same suggestions. Combining Ob2 or Ob3 with Ob1, we can find that the former case is more often, i.e. new features attract new comers. Yet there are some cases where weighted age of authors is less than non-weighted.

#### Argu: Why don't use  # of new files and # of new comers to tackle this problem?
- for both metrics,
correlation between # new files and # of new athrs

-
mod, dc and dwa, dc and da
mm, 0.25 0.068, 0.196 0.16
usb 0.25 0.069, 0.10 0.47
scsi, 0.66 ***, 0.55 ***
ide, 0.28 0.047, 0.28 0.05
mips, 0.22 0.118, 0.375 ***
arm, 0.52 ***, 0.58 ***
x86,


long term

root:   0.97  0.98  1.00 -0.81 -0.75 -0.75

drivers:0.97  0.99  0.99 -0.79 -0.65 -0.72
arch:   ----  0.48  0.95  0.55  0.68  0.81
net:    0.23  0.37  0.96  0.64  0.62  0.64
sound:  ----  0.65  0.65 -0.38  0.70  0.38
fs:     ----  0.87 -0.27  0.69  0.39  0.67
kernel: -0.61 0.42  0.37  0.22 -0.71 -0.72
mm:     0.73  0.93  0.89 -----  0.44  ----

usb:    ----  0.78  0.58 -0.56  ---- -0.37
scsi:   -0.49 ----  0.50 ----- -0.69 -----
ide:    -0.85 0.93 -0.79  0.87 -0.75  0.98
mips:   -0.78 0.52 -----  0.84 -0.54  0.62
arm:    0.92  0.98  0.97  0.98  0.90  0.97
x86:    -0.27 0.62  0.57  0.40  0.72  0.94
powerpc:---- -----  0.77  0.88  ----  ----
xfs:    ---- -0.53 -0.49 -0.35  0.80  ----
btrfs:  0.64  0.87  0.86  0.82  0.93  0.98
nfs:    0.28  0.71  0.59  0.25  ----  0.35
cifs:   0.37 ----- -0.40  0.66  0.78 -0.38
ext4:   -0.46 0.94 -0.38  0.76  ----  0.68

## discuss 2016.4.6

开源软件最佳实践的度量与对比分析

通过度量来帮助最佳实践。

#### 对比分析：Linux kernel 和 FireFox.
- 总体情况（基本面），如changes, loc,authors,committers.这个比较general，一般都会看。
- 面向开发者的度量，如LTC,  new comers, 转化为LTC的比率，author转化为committer的比率。author和committer的比率。

软件开发状态的dashboard，要有层次感。

###### Community Structure Metrics
- Current. yearly or monthly. No sliding window.
- Historical. Full history or in the past several years. Sliding window. Based on this metrics, we can analyze growth of peripheral contributors from a macro view. 
    + Core code athr
    + code athr
    + documentation
    + bug reporters


