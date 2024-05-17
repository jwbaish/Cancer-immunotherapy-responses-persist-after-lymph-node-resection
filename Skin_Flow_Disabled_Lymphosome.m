% Find the flow through the skin network with a disabled lymphosome 
% This allows skin drainage into upstream lymph nodes which could be misleading
% Feb 25, 2023
% J. Baish

% Example to give Lvdisabled = 38.8 mm Lvenabled = 15.8 mm
pC = 1330;     % capillary pressure (Pa)
pL = -266;     % lymph pressure (Pa)
n_per_L = 1.7; % Density of connections per width 
kappa = 3e-14; % 1e-18; For lymphosome mapping nominal = 3e-14; % m^2
betaC = 0.2e-7;% 1/(Pa*s)
betaL = 1e-7;  % 1/(Pa*s)
mu = 1e-3;     % Pa*s
t = 0.001;     % m

% Set up the conductance matrix
% Supplement Gskin with connections to blood & lymph

% Find the size of the skin network
nskin = length(Vskin);

% Begin with the Gskin 
Gfull = sparse(nskin+2,nskin+2);
% Typical length
L = mean(Area)^0.5; % in mm
L = L/1000; % in m
Ft = L*t*kappa/mu/n_per_L;
% Rescale in meters with parameters
Gfull(1:nskin,1:nskin) = Ft*Gskin*1000;
Areafull = Area/(1000^2);
% Add connections to the blood proportional to area
% Add capillaries as nskin+1
Gfull(1:nskin,nskin+1) = t*Areafull*betaC;
Gfull(nskin+1,1:nskin) = t*Areafull*betaC;
% Add connectons to the lymph proportional to area
% Add lymph as nskin+2
Gfull(1:nskin,nskin+2) = t*Areafull*betaL;
Gfull(nskin+2,1:nskin) = t*Areafull*betaL;
% Number of knowns = 2 (capillaries and lymph)
known = [nskin+1,nskin+2];
pknown = [pC,pL];
pfull = pressure(Gfull,known,pknown);

% Now disconnect an arbitrary region
Gdiscon = Gfull;
% Option 1: Disconnect a lymphosome (K = lymphosome number)
Discon = lymphosome{K};

Gdiscon(Discon,nskin+2) = 0;
Gdiscon(nskin+2,Discon) = 0;
% Find new pressures
pdiscon = pressure(Gdiscon,known,pknown);

% Compensatory flows
% Find the flow into each lymphosome before and after
FlowLymphosomeFull = zeros(length(lymphosome),1);
FlowLymphosomeDiscon = zeros(length(lymphosome),1);
for i=1:length(lymphosome)
    FlowLymphosomeFull(i) = sum((pfull(lymphosome{i}) - pL).*Areafull(lymphosome{i})');
    FlowLymphosomeDiscon(i) = sum((pdiscon(lymphosome{i}) - pL).*Areafull(lymphosome{i})');
end

% Correct the disconnected lymphosome
FlowLymphosomeDiscon(K) = 0;

% Find ratio of disconnected to original flow in that lymphosome
FlowRatio = FlowLymphosomeDiscon./FlowLymphosomeFull;

% Find the distance to each centroid from K
for i=1:length(lymphosome)
    dK(i) = sqrt(sum((Vlymphosomecentroid(i,:)-Vlymphosomecentroid(K,:)).^2));
end

[dKsort,order] = sort(dK);

figure(2)
clf
Plot_Skin_Lymphosome_Pressure
view([0 1e-5 -1])

figure(3)
plot(dKsort,FlowRatio(order),'.')
xlim([0 max(dKsort)]); ylim([1 1.1]); 
xlabel('Distance from Centroid of Disabled Lymphosome (mm)')
ylabel('Relative Lymphosome Absorption')
xlim([0 200]);ylim([1 1.1])

% Find the distance of each vertex from the centroid of K
dV = zeros(nskin,1);
for i=1:nskin
    dV(i) = sqrt(sum((Vskin(i,:)-Vlymphosomecentroid(K,:)).^2));
end

figure(4)