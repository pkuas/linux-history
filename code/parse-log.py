#coding:utf-8
import re
import sys

# STARTOFTHECOMMIT
# commithan;author name;author email;author time(unix time:seconds from 1970/01/01/00);committer name;committer email;commit time;description 
# addedlines  deletedlines  filedirectory  (可能是多行)

# STARTOFTHECOMMIT
# 265b2cd0acae97dc6f871d753fe6c59f53513779;Fabio Tomat;f.t.public@gmail.com;1459855648;GNOME Translation Robot;gnome-sysadmin@gnome.org;1459855740;Updated Friulian translation (cherry picked from commit 62708cd7cd3e5e90960c93b79e17f7aaad365331)
# 5       5       po/fur.po

# if len(sys.argv) < 2:
# 	print "usage: python script.py input-file"
# 	exit()
def parse_rec(rec):
	fields = rec.split(';')


infile = sys.argv[1]

fin = open(infile, 'r')

lines = fin.readlines()
i = 0
while i < len(lines):
	line = lines[i]
	if line == 'STARTOFTHECOMMIT\n':
		while i < len(lines):
			out = ''
			i += 1
			rec = lines[i].strip()
			#print i, rec
			#rec_fields = res.split(';')
			i += 1
			line = lines[i]
			if line == 'STARTOFTHECOMMIT\n':
				continue
			while True:
				if line == '\n':
					break
				out += rec + ';' + line.replace('\t', ';')
				i += 1
				if i >= len(lines):
					line = '\n'
				else:
					line = lines[i]
			i += 1
			print out.strip()
	i += 1


