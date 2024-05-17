j = sentinelnodes(K);
i = lymphosome{K};
% Plot the skin vertices for lymphosome K
plot3(Vskin(i,1),Vskin(i,2),Vskin(i,3),'.','Color','b','MarkerSize',30)
% plot the sentinel lymph node for lymphosome K
plot3(Vdeep(j,1),Vdeep(j,2),Vdeep(j,3),'.','Color','k','MarkerSize',30)
