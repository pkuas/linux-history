## VCS Usage History
- Source: [https://en.wikipedia.org/wiki/Linux_kernel#Revision_control](https://en.wikipedia.org/wiki/Linux_kernel#Revision_control)

The Linux kernel source code used to be maintained without the help of an automated source code management system, mostly because of Linus Torvalds' dislike of centralized SCM systems.

In 2002, Linux kernel development switched to BitKeeper, an SCM system which satisfied Torvalds' technical requirements. BitKeeper was made available to Linus and several others free of charge, but was not free software, which was a source of controversy. The system did provide some interoperability with free SCM systems such as CVS and Subversion.

In April 2005, however, efforts to reverse-engineer the BitKeeper system by Andrew Tridgell led BitMover, the company which maintained BitKeeper, to stop supporting the Linux development community. In response, Torvalds and others wrote a new source code control system for the purpose, called Git. The new system was written within weeks, and in two months the first official kernel release was made using Git.[283] Git soon developed into a separate project in its own right and gained wide adoption in the free software community.

- Source: [https://git-scm.com/book/en/v2/Getting-Started-A-Short-History-of-Git](https://git-scm.com/book/en/v2/Getting-Started-A-Short-History-of-Git)

The Linux kernel is an open source software project of fairly large scope. For most of the lifetime of the Linux kernel maintenance (1991–2002), changes to the software were passed around as patches and archived files. In 2002, the Linux kernel project began using a proprietary DVCS called BitKeeper.

In 2005, the relationship between the community that developed the Linux kernel and the commercial company that developed BitKeeper broke down, and the tool’s free-of-charge status was revoked. This prompted the Linux development community (and in particular Linus Torvalds, the creator of Linux) to develop their own tool based on some of the lessons they learned while using BitKeeper. 

## Git Adoption
- Source: [https://en.wikipedia.org/wiki/Git_(software)#History](https://en.wikipedia.org/wiki/Git_(software)#History)

The development of Git began on 3 April 2005.[18] The project was announced on 6 April,[19] and became self-hosting as of 7 April.[18] The first merge of multiple branches was done on 18 April.[20] Torvalds achieved his performance goals; on 29 April, the nascent Git was benchmarked recording patches to the Linux kernel tree at the rate of 6.7 per second.[21] On 16 June Git managed the kernel 2.6.12 release.[22]

Torvalds turned over maintenance on 26 July 2005 to Junio Hamano, a major contributor to the project.[23] Hamano was responsible for the 1.0 release on 21 December 2005, and remains the project's maintainer.[24]

## Number of Deltas in this Repo
- before 2005(not included): **89**
- after 2005(included) to 2015.91: **1304631** (we only consider these deltas)
- further, in these **1304631** deltas, we only consider **.c** files. We get **859372** deltas, accounting for **65.86%**. BTW, deltas in **.h** files accounts for **22.52%** in **1304631** deltas. 

```
actually,
> delta <- x[x$to<2015.963 & x$tt<=131 & x$m<2015.9 & x$m>=2005 & x$ext=="c", ]
> length(delta[,1])
[1] 854705
```