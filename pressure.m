% function to find the pressures 
% arguments G,known,knownp
% returns p
% 8/11/94

function p=pressure(G,known,pknown)

n=length(G);                % n=number of nodes
i=1:n;						% i=indices of nodes
p=0*i;
p(known)=pknown;			% all pressures set to zero except known pressures
sumG=sum(G);				% sum conductances over columns
A=G-diag(sumG,0);			% subtract sum from main diagonal
[x,y]=meshgrid(i,known);
unknown=i(any(G)&~any(x==y));% unknown=indices of unknown and defined pressures
B=-G*p';					% right hand side of matrix equation
B=B(unknown);				% right hand side of matrix equation for unknowns only
A=A(unknown,unknown);		% left hand side of matrix equation for unknowns only

p(unknown)=(sparse(A)\sparse(B))';	% solve matrix equation (sparse is redundant if sparse inputs)
