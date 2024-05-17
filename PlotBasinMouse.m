i = BasinSkin;
hold on
% Plot the skin vertices for basin of K
plot3(Vskin(i,1),Vskin(i,2),Vskin(i,3),'.','Color','b','MarkerSize',30)
% plot the lymph node K 
plot3(Vdeep(K,1),Vdeep(K,2),Vdeep(K,3),'.','Color','k','MarkerSize',30)
hold off 