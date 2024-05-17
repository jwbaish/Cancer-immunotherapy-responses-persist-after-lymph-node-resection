% Find the drainage basin of skin vertices that ultimately reach a node
% J. Baish
% April 22, 2023

nK_from = find(from == K);
nK_from = mod(nK_from,length(from));
% Find the downstream deep vertex from node K (node not lymphosome)
nK_to = to(nK_from);

% Put flow through the uncut deep network with p=1 at all collectors
pknown = [ones(1,length(ins)),zeros(1,length(out))];
knownp = [ins,out];
p0 = pressure(Gdeep,knownp,pknown);
Q0 = flow(Gdeep,p0);
% Now remove the conductance between K and nK_to
GcutK = Gdeep;
GcutK(K,nK_to) = 0;
GcutK(nK_to,K) = 0;
% Find the new flows with p at K set to 1.
% This should stagnate all flows between K and upstream collectors.
pknown = [pknown,ones(1,length(K))];
knownp = [knownp,K];
pcut = pressure(GcutK,knownp,pknown);
Qcut = flow(GcutK,pcut);
% The ins that are now negligibly small are the collectors for the node K basin
Stagnant = find(sum(abs(Qcut))<1e-16);
BasinCollectors = intersect(Stagnant,ins);
% Find the skin vertices for the collectors in the basin
s = ismember(Collecti,BasinCollectors);
BasinSkin = find(s);
% Find all nodes that are disabled due to K being disabled 
% These are all upstream of the diabled node
Shutdown_Nodes = setdiff(Stagnant,BasinCollectors);