# -*- coding: utf-8 -*-
"""
Created on Fri Mar 10 16:54:53 2017

@author: ignacio
"""

import networkx as nx
import networkx.algorithms.bipartite as bip
import csv

input_file = 'outputs/list_edge_bipartite.csv'

B = nx.Graph()
PP = []
FP = []
with open(input_file,'r') as csvfile:

    csvreader = csv.reader(csvfile)
    for row in csvreader:
        if row[0] != '':
            n1 = row[1].decode('utf-8')
            n2 = row[2].decode('utf-8')
            w = float(row[3])
            if not B.has_node(n1):
                B.add_nodes_from([n1], bipartite=0)
                PP += [n1]
            if not B.has_node(n2):
                B.add_nodes_from([n2], bipartite=1)
                FP += [n2]
            B.add_edge(n1,n2,{'weight':w})            
            
            
projPP = nx.Graph()
projPPw = nx.Graph()
for n1 in PP:  
    for n2 in PP:
        if n1 != n2:
            if len(set(B.neighbors(n1)).intersection(set(B.neighbors(n2)))) > 0:
                projPP.add_edge(n1,n2)
                projPPw.add_edge(n1,n2,{'weight':len(set(B.neighbors(n1)).intersection(set(B.neighbors(n2))))})
nx.write_edgelist(projPP,'outputs/projPP.csv', delimiter=',', data=False)
nx.write_weighted_edgelist(projPPw,'outputs/projPPw.csv', delimiter=',')


projFP = nx.Graph()
projFPw = nx.Graph()
for n1 in FP:  
    for n2 in FP:
        if n1 != n2:
            if len(set(B.neighbors(n1)).intersection(set(B.neighbors(n2)))) > 0:
                projFP.add_edge(n1,n2,)
                projFPw.add_edge(n1,n2,{'weight':len(set(B.neighbors(n1)).intersection(set(B.neighbors(n2))))})
nx.write_edgelist(projFP,'outputs/projFP.csv', delimiter=',', data=['source','targe'])
nx.write_weighted_edgelist(projFPw,'outputs/projFPw.csv', delimiter=',')
