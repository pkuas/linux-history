# 1. extract log. wihtouy quot
for f in {epiphany,evolution,gedit,gimp,gtk+,nautilus}
do
	echo $f
	cd $f
	git log --pretty=format:'%H' --no-merges --all | wc -l
	git log --pretty=format:'%H' --no-merges  | wc -l
	#git log --pretty=format:'%H;%an;%ae;%at;%cn;%ce;%ct' > /store1/chenqy/linuxhistory/gnome/$f
	cd ..
done

git log --pretty=format:'%H;%an;%ae;%at;%cn;%ce;%ct;%s' > /store1/chenqy/linuxhistory/gnome/epiphany
# vim

######################
for f in {epiphany,evolution,gedit,gimp,gtk+,nautilus}
do
	echo $f
	cd $f
	git log --numstat --pretty=format:'STARTOFTHECOMMIT%n%H;%an;%ae;%at;%cn;%ce;%ct' > /store1/chenqy/linuxhistory/gnome/$f
	cd ..
done


for f in {epiphany,evolution,gedit,gimp,gtk+,nautilus}
do
	echo $f
	python parse-log.py $f > $f.l1
done
