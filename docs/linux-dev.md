- [Documentation/SubmittingPatches](https://www.kernel.org/doc/Documentation/SubmittingPatches)
- [MAINTAINERS](https://www.kernel.org/doc/linux/MAINTAINERS)
- [staging](https://lkml.org/lkml/2008/6/10/329)
- version number

https://en.wikipedia.org/wiki/Linux_kernel

The Linux kernel has had three different numbering schemes.

The first scheme was used in the run-up to "1.0". The first version of the kernel was 0.01. This was followed by 0.02, 0.03, 0.10, 0.11, 0.12 (the first GPL version), 0.95, 0.96, 0.97, 0.98, 0.99 and then 1.0.[288] From 0.95 on there were many patch releases between versions.

After the 1.0 release and prior to version 2.6, the number was composed as "a.b.c", where the number "a" denoted the kernel version, the number "b" denoted the major revision of the kernel, and the number "c" indicated the minor revision of the kernel. The kernel version was changed only when major changes in the code and the concept of the kernel occurred, twice in the history of the kernel: in 1994 (version 1.0) and in 1996 (version 2.0). Version 3.0 was released in 2011, but it was not a major change in kernel concept. The major revision was assigned according to the even–odd version numbering scheme. The minor revision had been changed whenever security patches, bug fixes, new features or drivers were implemented in the kernel.

In 2004, after version 2.6.0 was released, the kernel developers held several discussions regarding the release and version scheme[289][290] and ultimately Linus Torvalds and others decided that a much shorter "time-based" release cycle would be beneficial. For about seven years, the first two numbers remained "2.6", and the third number was incremented with each new release, which rolled out after two to three months. A fourth number was sometimes added to account for bug and security fixes (only) to the kernel version. The even-odd system of alternation between stable and unstable was gone. Instead, development pre-releases are titled release candidates, which is indicated by appending the suffix '-rc' (release candiate) to the kernel version, followed by an ordinal number.

The first use of the fourth number occurred when a grave error, which required immediate fixing, was encountered in 2.6.8's NFS code. However, there were not enough other changes to legitimize the release of a new minor revision (which would have been 2.6.9). So, 2.6.8.1 was released, with the only change being the fix of that error. With 2.6.11, this was adopted as the new official versioning policy. Later it became customary to continuously back-port major bug-fixes and security patches to released kernels and indicate that by updating the fourth number.

On 29 May 2011, Linus Torvalds announced[291] that the kernel version would be bumped to 3.0 for the release following 2.6.39, due to the minor version number getting too large and to commemorate the 20th anniversary of Linux. It continued the time-based release practice introduced with 2.6.0, but using the second number; for example, 3.1 would follow 3.0 after a few months. An additional number (now the third number) would be added on when necessary to designate security and bug fixes, as for example with 3.0.18; the Linux community refers to this as "3.x.y.z" versioning. The major version number was also later raised to 4, for the release following version 3.19.[292][b]

In addition to Linus's "-rc" development releases, sometimes the version will have a suffix such as "tip", indicating another development branch, usually (but not always) the initials of a person who made it. For example, "ck" stands for Con Kolivas, "ac" stands for Alan Cox, etc. Sometimes, the letters are related to the primary development area of the branch the kernel is built from, for example, "wl" indicates a wireless networking test build. Also, distributors may have their own suffixes with different numbering systems and for back-ports to their "enterprise" (i.e. stable but older) distribution versions.


- With android
    + March 19, 2012: 
    + https://lwn.net/Articles/472984/
    +http://www.cnet.com/news/linux-and-android-together-at-last/#!
    + http://www.engadget.com/2012/03/19/linux-kernel-3-3-merged-android-code/
    + http://kernelnewbies.org/Linux_3.3#head-b733d694037e0b34ad47e1b5d38ebc4d1bd1d89f
    + http://www.all-things-android.com/content/android-kernel-versus-linux-kernel
    + (2 February 2010). "Android and the Linux kernel community": http://www.kroah.com/log/linux/android-kernel-problems.html, http://www.zdnet.com/article/linux-developer-explains-android-kernel-code-removal/

> The Android project uses the Linux kernel, but with some modifications and features built by themselves. For a long time, that code has not been merged back to the Linux repositories due to disagreement between developers from both projects. Fortunately, after several years the differences are being ironed out. Various Android subsystems and features have already been merged, and more will follow in the future. This will make things easier for everybody, including the Android mod community, or Linux distributions that want to support Android programs. (https://lwn.net/Articles/472984/)