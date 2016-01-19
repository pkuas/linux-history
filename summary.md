## 要研究的问题
> 当前，关于向Linux kernel做贡献，我们听到了一些声音：向Linux kernel做贡献很难。我们要研究的问题就是，到底有什么难，为什么难。

## 一些相关的背景
我们要研究的问题是非常实际的，对背景事实不加以了解、脱离实际，那是不会带来有价值的东西，也会有遭人耻笑的风险。

网上资源：

- [http://www.linuxfoundation.org/](http://www.linuxfoundation.org/)
- [http://www.linux.org/](http://www.linux.org/)
- [The Linux Kernel Archives]( https://www.kernel.org/)
- [The kernel guide]( http://www.linux.org/threads/linux-kernel-reading-guide.5384/)
- [Linux Kernel Newbies](http://kernelnewbies.org/)
- 其他

Linux kernel是一个大型的开源项目，有着规范的开发流程。关于如何向Linux kernel做贡献，可以参考这些文档：

- [How to Participate in the Linux Community](http://www.linuxfoundation.org/content/how-participate-linux-community)
- [Documentation/development-process/*](https://www.kernel.org/doc/Documentation/development-process/)
- [Documentation/SubmittingPatches](https://www.kernel.org/doc/Documentation/SubmittingPatches)

LinuxFoundation的publication:

- [Who Writes Linux: Linux Kernel Development: How Fast it is Going, Who is Doing It, What They are Doing, and Who is Sponsoring It](http://www.linuxfoundation.org/publications/linux-foundation/who-writes-linux-2015) 或者直接点[这里](./docs/lf_pub_whowriteslinux2015.pdf)

还有一些比较杂的资料，放在docs目录下。

## 分析准备
#### 数据获取
```
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
```
#### 数据清洗
```
$ cd linux
$ git log --numstat --pretty=format:"STARTOFTHECOMMIT%n%H;%an;%ae;%ad;%cn;%ce;%cd;%s" > log.linux

$ mv linux/log.linux .

$ perl /home/user/unixhistory/extrgit.perl < log.linux > linux.l1

$ cat linux.l1 |
while read 
  do perl -ane 'use Time::ParseDate qw(parsedate); ($rev,$aname,$cname,$alogin,$clogin,$nadd,$atime,$ctime,$f,$cmt)=split(/\;/,$_, -1); $at=parsedate("$atime");$ct=parsedate("$ctime"); print "$rev\;$aname\;$cname\;$alogin\;$clogin\;$nadd\;$at\;$ct\;$f\;$cmt"';
done > linux.l2 
```
#### 开发者多个email、name的识别与合并
一个开发者可能有多个name、email，这个要先处理一下。

#### 限定待分析数据的集合
- 丢弃2005年前的changes: **89**个
- 2005年1月 ~ 2015年11月(2015.917): **1305252**个
- 在这 **1305252** 个changes, 我们只考虑对 **.c** 文件的修改，这样得到了**859729**个, 占比 **65.87%**. 另外 **.h** 文件的修改占比 **22.52%**。 


## 分析
一些基本情况见pics目录。

## PS
- 没有怎么整理的记录，见[note.md](./note.md)。这个文件记录了一些思路，基本只增不删，可读性差些，甚至有一些不正确的地方。
