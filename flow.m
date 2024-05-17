% function to find the flow through the existing network
% arguments G,p
% returns volumetric flow
% 7/28/94
% new version 12/8/94

function f=flow(G,p)

n=length(G);					% n=number of nodes
[i,j,G]=find(G);				% i,j are indices of all nonzero conductances
dp=p(j)-p(i);					% calculate all pressure differences
f=G'.*dp;						% find flows into each node
f=sparse(i,j,f,n,n);		% put result in a sparse matrix
