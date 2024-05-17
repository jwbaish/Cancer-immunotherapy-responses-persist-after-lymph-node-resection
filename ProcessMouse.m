% Process the information for the mouse
% March 25, 2023
% J. Baish

% Before running this: Import the remapped LSmiceedges and LSmicevertices with import wizard
% Run Grebenikov_Plot to define deep flow network and identify nodes 
% and store the inlet vertices of the vessels are known vertices(ins,:)
Grebennikov_Plot
% Load skin network with vertices V & facets F 
[F,V,N] = stlread('/data/Mouse_Tail_3_25_2023.stl');
% Shift and scale to mm
x = 100/15*(V(:,1)-mean(V(:,1)));  % Make symmetric in x
y = 100/15*(V(:,2)-10);            % Shift origin to hip midpoint
z = 100/15*(max(V(:,3))-V(:,3));    % Put on belly
V(:,1) = x; V(:,2) = y; V(:,3) = z;
% Run STL2Adjacent to convert skin STL data to graph
[Vskin,Adjskin,Gskin,Area,degree] = STL2AdjacentMouse(V,F);
% With cut midline
 [Vskin,Adjskin,Gskin,Area,degree] = STL2AdjacentMouseCutMidline(V,F);
xlim([-100 100]);ylim([-80 120]);zlim([-100 100])
view([0 1e-5 -1])
set(gcf,'color','w');
hold on

% Set up array to hold identity of nearest deep inlet for each skin vertex
% Find how many skin vertices
nskin = length(Area);
deepi = zeros(1,nskin);
skin_ins = intersect(ins,find(skin_Collectors'=='T'));
for i = 1:nskin
    % Find distances^2 to all deep skin collector vertices
    ds2 = (Vskin(i,1) - Vdeep(skin_ins,1)).^2 ...
         +(Vskin(i,2) - Vdeep(skin_ins,2)).^2 ...
         +(Vskin(i,3) - Vdeep(skin_ins,3)).^2;
    % Find closest deep inlet
    [ds2min,deepins] = min(ds2);
    deepi(i) = skin_ins(deepins);
end

% Determine which vertices are the collectors near the skin
% And find the nearest skin collector for each skin vertex
FindSkinCollectorsMouse

% Find the sentinel lymph node for each deep inlet
FindSentinelNodesMouse

% Plot a sample lymphosome
% K = 1; % right popliteal (hind foot) 
% K = 2; % right external sacral (tail)
% K = 3; % right iliac
% K = 4; % internal
% K = 5; % right inguinal 
% K = 6; % right deep axillary
% K = 7; % right superficial axillary
% K = 8; % right deep cervical (jowl)
% K = 9; % right medial mandibular (eyelid)
% K = 10; % right lateral mandibular (ear)
% K = 11; % internal 
% K = 12; % internal
% K = 13; % left lateral mandibular (ear)
% K = 14; % left medial mandibular (eyelid)
% K = 15; % left deep cervical (jowl)
% K = 16; % internal
% K = 17; % left deep axillary
% K = 18; % left superficial axillary (Brachial)
% K = 19; % empty
% K = 20; % empty
% K = 21; % empty
% K = 22; % internal
% K = 23; % internal
% K = 24; % internal
% K = 25; % left external sacral (tail)
% K = 26; % left popliteal
% K = 27; % left inguinal
% K = [1 5 6] % popliteal, inguinal, axillary
K = [5 6]; % inguinal, axillary
% K = [5]; % inguinal
% K = [1 5 6 7]; % popliteal, inguinal, axillary, brachial
Plotlymphosome

% Find the skin drainage basin for each node
% This will often be larger than the 'lymphosome' for a sentinel node
% because a node may be downstream from several other nodes that may 
% be sentinel nodes themselves. 
% This has problems with network redundancy. 
% Numbers are Grebennikov's 
% K = 5; % right inguinal 
% K = 17; % left deep axillary
% K = 18; % Left superficial axillary (Brachial)
% K = 26; % Left popliteal
% K = 27;  % left inguinal 
% K = [17 26];
FindDrainageBasinMouse

% Plotlymphosome
PlotBasinMouse

figure(2)
clf
% Skin_Flow_Disabled_Lymphosome
Skin_Flow_Disabled_Basin
