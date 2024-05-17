j = sentinelnodes(K);
i = lymphosome{K};
% Plot all skin vertices for lymphosome K
hold on
prange = pC - pL;

pmax = max(pdiscon(1:length(Vskin)));
for ip = 1:length(Vskin)
    prel = pdiscon(ip)/pmax; 
    if prel < 0;
        prel = 0;
    end
    color = [prel, 0, 1-prel];         % Red to Blue colormap
    % color = [(pdiscon(ip)-pL)/prange,1-(pdiscon(ip)-pL)/prange,0];
    plot3(Vskin(ip,1),Vskin(ip,2),Vskin(ip,3),'.','Color',color,'MarkerSize',8)
    if ismember(ip,i)
        plot3(Vskin(ip,1),Vskin(ip,2),Vskin(ip,3),'o','Color',color,'MarkerSize',6)
    end
end

% Plot the sentinel lymph node for lymphosome K in black
plot3(Vdeep(j,1),Vdeep(j,2),Vdeep(j,3),'*','Color','k','MarkerSize',60)
plot3(Vdeep(j,1),Vdeep(j,2),Vdeep(j,3),'.','Color','k','MarkerSize',60)
% text(Vdeep(j,1)-10,Vdeep(j,2),Vdeep(j,3),num2str(K))

% Plot the largest compensatory lymph nodes for K in red
jc = sentinelnodes(find(FlowRatio>1.1));
% plot3(Vdeep(jc,1),Vdeep(jc,2),Vdeep(jc,3),'*','Color','r','MarkerSize',50)
plot3(Vdeep(jc,1),Vdeep(jc,2),Vdeep(jc,3),'.','Color','r','MarkerSize',50)

% xlim([-1000 1000]); % xlim([-300 300])
% ylim([-1000 1000]); % ylim([0 1000]); % for front only
% zlim([0 2000]);  % zlim([900 1500])
xlim([-100 100]);ylim([-80 120]);zlim([-100 100]) % Mouse range
axis off
% grid on
view([0 1e-5 -1]) % Belly view