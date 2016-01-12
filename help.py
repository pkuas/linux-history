# ssh pae
# ssh lion
# cd /store1/chenqy/linuxhistory
# map emails and namey to namex
import pandas as pd
import numpy as np
ce_cn = pd.read_table("./ce.cn", names=['ce', 'cn'], sep=' ').fillna("")
cnsofce = ce_cn.cn.groupby(ce_cn.ce).unique()
cesofcn = ce_cn.ce.groupby(ce_cn.cn).unique()
tsel = cnsofce.index!=''
mpc = pd.Series()
for ce in cnsofce.index[tsel]:
	cns = cnsofce[ce]
	fathofcns = mpc.get(cns)
	nullfath = pd.isnull(fathofcns)
	mark = None
	for i in range(len(fathofcns)):
		if cns[i] == '':
			continue
		if not nullfath[i]:
			if not mark:
				mark = fathofcns[i]
			mpc[cns[i]] = mpc[fathofcns[i]] = mark
		else:
			mpc[cns[i]] = ce
	if mark:
		mpc[ce] = mark
	else:
		mpc[ce] = ce

for idx in mpc.index:
	fath = mpc[idx]
	while mpc[fath] != fath:
		fath = mpc[fath]
	mpc[idx] = fath

alsofcid = mpc.index.groupby(mpc.values)
mpc.to_csv("./cmtr.aliase.id")

ae_an = pd.read_table("./e.n", names=['ae', 'an'], sep=' ').fillna("")
ae_an.ae = map(str.lower, ae_an.ae)
ae_an.an = map(str.lower, ae_an.an)
ansofae = ae_an.an.groupby(ae_an.ae).unique()
aesofan = ae_an.ae.groupby(ae_an.an).unique()
tsel = ansofae.index!=''
mpa = pd.Series()
for ae in ansofae.index[tsel]:
	ans = ansofae[ae]
	fathofans = mpa.get(ans)
	nullfath = pd.isnull(fathofans)
	mark = None
	for i in range(len(fathofans)):
		if ans[i] == '':
			continue
		if not nullfath[i]:
			if not mark:
				mark = fathofans[i]
			mpa[ans[i]] = mpa[fathofans[i]] = mark
		else:
			mpa[ans[i]] = ae
	if mark:
		mpa[ae] = mark
	else:
		mpa[ae] = ae

for idx in mpa.index:
	fath = mpa[idx]
	while mpa[fath] != fath:
		fath = mpa[fath]
	mpa[idx] = fath

alsofaid = mpa.index.groupby(mpa.values)
mpa.to_csv("./all.aliase.id.lower")

# mp = mpa
# # merge mpc to mpa as mp
# for cid in alsofcid.keys():
# 	t = alsofcid[cid]
# 	t.append(cid)
# 	fath = mp.get(t)
# 	nullfath = pd.isnull(fath)
# 	mark = None
# 	for i in range(len(t)):
# 		if not nullfath[i]:
# 			mark = fath[i]
# 		mpa

# 	if not :
# 		mpa[alsofcid[cid]] = cid
# 	else:
# 		mpa[cid] = 

# a simple solution using graph
import networkx as nx
nodes = np.unique(ae_an.ae)
nodes = np.concatenate((nodes, np.unique(ae_an.an)))
nodes = np.unique(nodes)
nodes = nodes[nodes != ""]
nds2gid_mp=pd.Series(range(len(nodes)), index=nodes)
G = nx.Graph()
G.add_node
for ae in ansofae.index[ansofae.index!='']:
	tsel = ansofae[ae]!=""
	for an in ansofae[ae][tsel]:
		G.add_edge(nds2gid_mp[ae], nds2gid_mp[an])

for an in aesofan.index[aesofan.index!='']:
	tsel = aesofan[an]!=""
	for ae in aesofan[an][tsel]:
		G.add_edge(nds2gid_mp[an], nds2gid_mp[ae])

belong = pd.Series([None]*len(nds2gid_mp)) # community
def rec_mark(i, m, g):
	global belong
	belong[i] = m
	for n in g.neighbors(i):
		#print n, belong[n]
		if belong[n] == None:
			rec_mark(n, m, g)

for i in range(len(belong)):
	if belong[i] == None:
		try:
			rec_mark(i, i, G)
		except Exception, e:
			print e

mp = pd.Series(nds2gid_mp.index[list(belong[nds2gid_mp])], index=nds2gid_mp.index)
mp.to_csv("./all.aliase.id.networkx")
