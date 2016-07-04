#code=utf-8

import re
import numpy as np
import commands
fn = '/store1/chenqy/linuxhistory/linux/MAINTAINERS'
mid = '^M:\s+'
fid = '^F:\s+'
sid = '^S:\s+'
def is_doc(p):
    return re.match('^Documentation', p) != None
def is_include(p):
    return re.match('^include', p) != None
def list_to_str(lst):
    return re.sub("['\[\]]", '', str(lst))

fin = open(fn, 'r')
lines = fin.readlines()
fin.close()
out = ''
stline = 127 # ignore previous lines
edline = len(lines)
i = stline - 1
while i < edline:
    line = lines[i]
    files = []
    mnames = []
    memails = []

    subsys_name = line.strip()
    i += 1
    line = lines[i]
    while line != '\n':
        if re.match(mid, line) != None:
            line = re.sub(',', '', line)
            t = re.sub(mid, '', line)
            t = re.split('<', t)
            if (len(t) != 2):
                print t, ': bad at', i
                mnames.append("?")
                memails.append(re.sub('\s*>', '', t[0]).strip())
            else:
                mnames.append(t[0].strip())
                memails.append(re.sub('\s*>', '', t[1]).strip())
        elif re.match(fid, line) != None:
            line = re.sub(',', '.', line)
            files.append(re.sub(fid, '', line).strip())
        elif re.match(sid, line) != None:
            status = re.sub(sid, '', line).strip()
        i += 1
        if i < edline:
            line = lines[i]
        else:
            line = '\n'
    files_is_doc = map(is_doc, files)
    files_is_include = map(is_include, files)
    files_is_core = [not(files_is_doc[k] or files_is_include[k]) for k in range(len(files))]
    tout = subsys_name + ';'
    loc = 0
    for j, fl in enumerate(files):
        if files_is_core[j]:
            cmd = 'find ' + fl + ' | xargs wc  -l  | tail -n 1'
            res = commands.getstatusoutput(cmd)
            if res[0] == 0:
                loc += int(re.search(r'\d+', res[1]).group())
    num_words_doc = 0
    for j, fl in enumerate(files):
        if files_is_doc[j]:
            cmd = 'find ' + fl + ' | xargs wc  -w  | tail -n 1'
            res = commands.getstatusoutput(cmd)
            if res[0] == 0:
                num_words_doc += int(re.search(r'\d+', res[1]).group())

    tout = subsys_name + ';' + list_to_str([files[k] for k in range(len(files)) if files_is_core[k]])
    tout += ';' + list_to_str(memails) + ';' + list_to_str(mnames) +  ';' + status
    tout += ';' + list_to_str(files) + ';' + list_to_str([files[k] for k in range(len(files)) if files_is_doc[k]])
    tout += ';' + str(num_words_doc) + ';' + str(loc) + '\n'

    out += tout
    i+=1

out = re.sub('"', '', out)
fout = open('/store1/chenqy/linuxhistory/maintainers-df', 'w')
fout.write(out)
fout.close()
