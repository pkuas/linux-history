## 要研究的问题
> 当前，关于向Linux kernel做贡献，我们听到了一些声音：向Linux kernel做贡献很难。我们要研究的问题就是，到底有什么难，为什么难。当然，这只是研究的引子，以后不必执着于此，毕竟，为芝麻丢西瓜，是划不来的。

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
#### 数据抽取、清洗
详见processUnix.sh

#### 开发者多个email、name的识别与合并
一个开发者可能有多个name、email，这个要先处理一下。

#### 限定待分析数据的集合
- 丢弃2005年前的changes: **89**个
- 2005年1月 ~ 2015年11月(2015.917): **1305252**个
- 在这 **1305252** 个changes, 我们只考虑对 **.c** 文件的修改，这样得到了**859729**个, 占比 **65.87%**. 另外 **.h** 文件的修改占比 **22.52%**。 


## 探索性分析
- 首先进行一些探索性的分析，详见[这里](explore.md)。
- 各模块中，每个committer为多少auhtor提交代码，如何分布，各模块有何差异,见[这里](./res/box.numAthrs-cmtr.mod.month.md)。作调整，见[这里](./res/box.adjNumAthrs-cmtr.mod.month.md)。
- 在每个模块中，committer成为这个模块的committer之前在多少个模块做过author/committer，见[这里](./res/numA-C.ModsBefCmtr-cmtr.mod.md)
- 关于author、committer的贡献模块变化，查看这里：[author](./res/athrTrcTreeSmry.md), [committer](./res/cmtrTrcTreeSmry.md)

## How does module structure shape team organization?
待续。