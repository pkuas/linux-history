


#######################################################
git clone https://github.com/dspinellis/unix-history-repo
git checkout FreeBSD-release/10.2.0

#($rev, $tree, $parent, $aname, $alogin, $atime, $cname, $clogin, $ctime, $comment) %b
user@user-ThinkPad-X1-Carbon:~/unixhistory/unix-history-repo$ git log --numstat --pretty=format:"STARTOFTHECOMMIT%n%H;%an;%ae;%ad;%cn;%ce;%cd;%s" > log.bsd

user@user-ThinkPad-X1-Carbon:~/unixhistory$ mv unix-history-repo/log.bsd .

perl extrgit.perl <log.bsd >bsd.l1

cat bsd.l1 |
while read 
  do perl -ane 'use Time::ParseDate qw(parsedate); ($rev,$aname,$cname,$alogin,$clogin,$nadd,$atime,$ctime,$f,$cmt)=split(/\;/,$_, -1); $at=parsedate("$atime");$ct=parsedate("$ctime"); print "$rev\;$aname\;$cname\;$alogin\;$clogin\;$nadd\;$at\;$ct\;$f\;$cmt"';
done > bsd.l2 

perl -Mcrm -e 'print stmp2date("77882400")'

#######################################################
user@user-ThinkPad-X1-Carbon:~/linuxhistory$ 
#git clone git://mirrors.tuna.tsinghua.edu.cn/linux.git

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

user@user-ThinkPad-X1-Carbon:~/linuxhistory/linux$ git log --numstat --pretty=format:"STARTOFTHECOMMIT%n%H;%an;%ae;%ad;%cn;%ce;%cd;%s" > log.linux

user@user-ThinkPad-X1-Carbon:~/linuxhistory$ mv linux/log.linux .

perl /home/user/unixhistory/extrgit.perl <log.linux >linux.l1

cat linux.l1 |
while read 
  do perl -ane 'use Time::ParseDate qw(parsedate); ($rev,$aname,$cname,$alogin,$clogin,$nadd,$atime,$ctime,$f,$cmt)=split(/\;/,$_, -1); $at=parsedate("$atime");$ct=parsedate("$ctime"); print "$rev\;$aname\;$cname\;$alogin\;$clogin\;$nadd\;$at\;$ct\;$f\;$cmt"';
done > linux.l2 


glm, gam

TUNA

response,  

howiehan@foxmail.com
13120382974

y:
feature#  implementer disappear cycle  #release #comp
1;    chenyu;   1;  5;  3;  2; 

glm(disappear ~ x1+x2+....+x5)

www.01.org compile errors
lkp@01.org runtime errors

