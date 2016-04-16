#code=utf-8

import re
fn = '/store1/chenqy/linuxhistory/linux/MAINTAINERS'
mid = '^M:\s+'
fid = '^F:\s+'
lines = open(fn, 'r').readlines()
out = ''
stline = 127 # ignore previous lines
edline = len(lines)
i = stline - 1
while i < edline:
    line = lines[i]
    files = []
    mnames = []
    memails = []
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
        i += 1
        if i < edline:
            line = lines[i]
        else:
            line = '\n'

    tout = ''
    for fl in files:
        for j in range(len(mnames)):
            tout += fl + ',' + mnames[j] + ',' + memails[j] + '\n'
    out += tout
    i+=1

out = re.sub('"', '', out)
fout = open('/store1/chenqy/linuxhistory/file-maintainers', 'w')
fout.write(out)
fout.close()
