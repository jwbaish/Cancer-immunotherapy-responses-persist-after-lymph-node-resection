% Using edges and vertices of Mouse from Grebennikov
% March 23, 2023
% J. Baish

% Load data automatically from files
warning('off');
EdgeData = readtable('/data/LS_mice_edges_remapped_5_1_2023.csv');
VertexData = readtable('/data/LS_mice_vertices_remapped_5_1_2023.csv');
from = table2array(EdgeData(:,1));
to = table2array(EdgeData(:,2));
Lengths = table2array(EdgeData(:,3));
id = table2array(VertexData(:,1));
xd = -table2array(VertexData(:,2));  
yd = table2array(VertexData(:,3));
zd = table2array(VertexData(:,4));
skin_Collectors = categorical(table2array(VertexData(:,9)));
vertices = categorical(table2array(VertexData(:,5)));

% Use import wizard to load data 
% from graph_edges.txt and graph_vertices.txt
% from = table2array(LSmiceedgesremapped512023(:,1));
% to = table2array(LSmiceedgesremapped512023(:,2));
% Lengths = table2array(LSmiceedgesremapped512023(:,3));
% id = table2array(LSmiceverticesremapped512023(:,1));
% xd = -table2array(LSmiceverticesremapped512023(:,2));  
% yd = table2array(LSmiceverticesremapped512023(:,3));
% zd = table2array(LSmiceverticesremapped512023(:,4));
% skin_Collectors = table2array(LSmiceverticesremapped512023(:,9));
% vertices = table2array(LSmiceverticesremapped512023(:,5));
vertices = vertices == 'LN';
nvertices = length(xd);
Vdeep = [xd,yd,zd];

% Find the lymph nodes
nodes = find(vertices==1);
nnodes = length(nodes);

figure(1)
% Plot all vertices
plot3(xd,yd,zd,'.','Color','k')
hold on
% xlim([0 30]);ylim([0 30]);zlim([0 30])
plot3(xd(nodes),yd(nodes),zd(nodes),'.','Color','r','MarkerSize',20)
% Label nodes
% for i=1:length(nodes)
%     text(xd(nodes(i)),yd(nodes(i)),zd(nodes(i)),num2str(nodes(i)))
% end
% Label all vertices
for i=1:length(xd)
%        text(xd(i),yd(i),zd(i),num2str(i))
end
xlabel('X');ylabel('Y');zlabel('Z')
view([0 0 1])
% axis square
axis off
% grid on

% Build the directed connectivity matrix with 1's as entries
Ca = sparse(from,to,1,nvertices,nvertices);
% Make symmetric
Cs = Ca+Ca';
% figure(2)
% spy(Cs);title('Connectivity Matrix')

% Find the inlets. These have no 'froms'.
ins = find(sum(Ca)==0);
nins = length(ins);
% Find the exit of the thoracic duct (should be 996 from Savinkov)
out = find(sum(Ca')==0); % Has no 'tos'

figure(1)
% Plot inlets
plot3(xd(ins),yd(ins),zd(ins),'.','Color','b','MarkerSize',16)
for i=1:length(ins)
%     text(xd(ins(i)),yd(ins(i)),zd(ins(i)),num2str(ins(i)))
end

% Build the conductivity matrix with 1/L as entries
Gdeep = sparse(from,to,1./Lengths,nvertices,nvertices);
% Make symmetric
Gdeep = Gdeep + Gdeep';

% Calcuate the flows in the network
knownp = [out];
pknown = 0;
knownQ = [ins];
Qknown = [ones(1,nins)];  % Assumes all inlet have Q=1
Qknown = 0.081; % mm^3/s to match Savinkov 2020
% pknown = [ones(1,length(ins)),0];
[p,Q0] = pressureQ(Gdeep,knownp,pknown,knownQ,Qknown);
% p=pressure(G,known,pknown);
Q=flow(Gdeep,p);
% find the max flow (28.93 to match Savinkov)
maxflow = max(max(Q));

for i = 1:length(from)
    % Make the line width proportional to flow
    % width = ceil(10*abs(Q(from(i),to(i)))/maxflow);
    % Alternatively use diameter=f^1/3 to satisfy 
    % Murray's Law (Constant shear stress)
    width = ceil((20*abs(Q(from(i),to(i)))/maxflow)^0.33);
    if width<1
        width=1;
    end
    plot3([xd(from(i)),xd(to(i))],...
        [yd(from(i)),yd(to(i))],...
        [zd(from(i)),zd(to(i))],...
        'Color','k','LineWidth',width)
end
title('Nodes (red) Inlets (blue)')
hold off
view([0 0 1]) % Facing view



