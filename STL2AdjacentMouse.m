function [Vskin,Adjskin,Gskin,Area,degree] = STL2AdjacentMouse(V,F)
% Create all conductances based on distance between vertices
% Estimate the area around each vertex
% Feb 20, 2023
% J. Baish

% The STL file should have a triangular mesh (as created in Meshmixer)
% F defines the facets it should be Nfacets x 3
% V defines the vertices Nvertices x 3
% Vskin is the pruned skin vertices with redundancy removed
% Adj is the adjacency matrix with 1's
% Gskin is the conductance based on the distance between vertices
% Area is the approximate area of a Voronoi domain around each vertex

% Retain only the unique vertices
[Vskin,iVp,iV] = unique(V(:,1:3),'rows','stable');
Fskin = iV(F);
degree = accumarray(iV,1);
nVertices = length(Vskin);
nFacets = length(Fskin);

% Connect to other vertices of each facet
% Find the distances to each connected vertex
Gskin = sparse(nVertices,nVertices);
Adjskin = sparse(nVertices,nVertices);
for i=1:nFacets
    Adjskin(Fskin(i,1),Fskin(i,2)) = 1;
    Adjskin(Fskin(i,2),Fskin(i,3)) = 1;
    Adjskin(Fskin(i,3),Fskin(i,1)) = 1; 
    d12 = sqrt((Vskin(Fskin(i,1),1)-Vskin(Fskin(i,2),1)).^2 ...
         + (Vskin(Fskin(i,1),2)-Vskin(Fskin(i,2),2)).^2 ...
         + (Vskin(Fskin(i,1),3)-Vskin(Fskin(i,2),3)).^2);
    G(Fskin(i,1),Fskin(i,2)) = 1/d12;
    d23 = sqrt((Vskin(Fskin(i,2),1)-Vskin(Fskin(i,3),1)).^2 ...
         + (Vskin(Fskin(i,2),2)-Vskin(Fskin(i,3),2)).^2 ...
         + (Vskin(Fskin(i,2),3)-Vskin(Fskin(i,3),3)).^2);
    Gskin(Fskin(i,2),Fskin(i,3)) = 1/d23;
    d31 = sqrt((Vskin(Fskin(i,3),1)-Vskin(Fskin(i,1),1)).^2 ...
         + (Vskin(Fskin(i,3),2)-Vskin(Fskin(i,1),2)).^2 ...
         + (Vskin(Fskin(i,3),3)-Vskin(Fskin(i,1),3)).^2);
    Gskin(Fskin(i,3),Fskin(i,1)) = 1/d31;
  end
% end

% % Make symmetric
Adjskin = Adjskin|Adjskin';
Gskin = Gskin + Gskin';

figure(1)
hold on

axis square
grid on
view([0 1 0])
xlabel('x');ylabel('y');zlabel('z');
[from,to] = find(Adjskin);
% Reorganize the axes if needed
xs = Vskin(:,1); ys = Vskin(:,2); zs = Vskin(:,3);
zmax = max(zs);zmin = min(zs);dz = zmax-zmin;
for i = 1:length(from)
    color = [1-(zs(from(i))-zmin)/dz,1-(zs(from(i))-zmin)/dz,0];
    plot3([xs(from(i)),xs(to(i))],...
        [ys(from(i)),ys(to(i))],...
        [zs(from(i)),zs(to(i))],'Color',color) %'k')
end
hold off

Area = zeros(nVertices,1);
for i=1:nVertices
    [m,n,dr]=find(Gskin(i,:));
    Area(i) = (1/prod(dr))^(2/degree(i)); %degree(i));
end
