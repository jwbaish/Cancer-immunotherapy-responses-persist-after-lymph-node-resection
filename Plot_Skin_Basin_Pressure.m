hold on
i = BasinSkin;

pmax = max(pdiscon(1:length(Vskin)));
for ip = 1:length(Vskin)
    prel = pdiscon(ip)/pmax; 
    if prel < 0;
        prel = 0;
    end
    color = [prel, 0, (1-prel)];         % Red to Blue colormap
    % color = [(pdiscon(ip)-pL)/prange,1-(pdiscon(ip)-pL)/prange,0];
    plot3(Vskin(ip,1),Vskin(ip,2),Vskin(ip,3),'.','Color',color,'MarkerSize',8)
    % Circle skin vertices in the basin
    if ismember(ip,i)
        plot3(Vskin(ip,1),Vskin(ip,2),Vskin(ip,3),'.','Color','r','MarkerSize',8)
        % plot3(Vskin(ip,1),Vskin(ip,2),Vskin(ip,3),'o','Color',color,'MarkerSize',12)
    end
end

% Plot the blocked nodes upstream of K and K
% plot3(Vdeep(Shutdown_Nodes,1),Vdeep(Shutdown_Nodes,2),Vdeep(Shutdown_Nodes,3),'.','Color','k','MarkerSize',60)
plot3(Vdeep(Shutdown_Nodes,1),Vdeep(Shutdown_Nodes,2),Vdeep(Shutdown_Nodes,3),'*','Color','k','MarkerSize',24,'LineWidth',4)
% Plot and label the disabled node K
% plot3(Vdeep(K,1),Vdeep(K,2),Vdeep(K,3),'*','Color','k','MarkerSize',60)
plot3(Vdeep(K,1),Vdeep(K,2),Vdeep(K,3),'*','Color','k','MarkerSize',24,'LineWidth',4)
% text(Vdeep(K,1)-10,Vdeep(K,2),Vdeep(K,3),num2str(K))

% Plot the nodes with the 4 biggest changes outside the disabled region in red
% Find the lymphosomes that have realistic values:  0<FlowRatios<100
keep = find(FlowRatio<100 & FlowRatio>0);
% Find the lymphosomes that are not part of the disabled region
keep = setdiff(keep,Shutdown_Nodes);
% Now find the lymphosomes with the 4 largest FlowRatios
[a,b] = sort(FlowRatio(keep),'descend');
jc = sentinelnodes(keep(b(1:4)));
% jc = sentinelnodes(find(FlowRatio>1.5));
% plot3(Vdeep(jc,1),Vdeep(jc,2),Vdeep(jc,3),'*','Color','r','MarkerSize',50)
% plot3(Vdeep(jc,1),Vdeep(jc,2),Vdeep(jc,3),'.','Color','g','MarkerSize',50)
plot3(Vdeep(jc,1),Vdeep(jc,2),Vdeep(jc,3),'o','Color','k','MarkerSize',20,'LineWidth',4)

xlim([-100 100]);ylim([-80 120]);zlim([-100 100]) % Mouse range
axis off
% grid on
view([0 1e-5 -1]) % Belly view