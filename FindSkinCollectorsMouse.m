% Find the vertices that are skin collectors 
% and the identity of the nears skin collector for each skin vertex 
% J. Baish 
% April 22, 2023

% Identify the skin collectors from all deep inlets
% Find how close each inlet is to the skin
% If the inlet is close enough to the skin it is a skin collector
SkinCollectors = [];
DeepCollectors = [];
for i = 1:length(ins)
    ds2 = (Vskin(:,1) - Vdeep(i,1)).^2 ...
         +(Vskin(:,2) - Vdeep(i,2)).^2 ...
         +(Vskin(:,3) - Vdeep(i,3)).^2;
    if min(sqrt(ds2)) < 8  % 8 yields 26 collectors
        SkinCollectors = [SkinCollectors,ins(i)];
    else
        DeepCollectors = [DeepCollectors,ins(i)];
    end
end

% The distance rule for finding skin collectors will be flawed until
% the coordinates of the vertices are improved. 
% Instead hardcode the skin collectors
SkinCollectors = [35 36 38 39 40 41 43 44 45 46 47 48 49 50 51 ...
                  68 69 70 71 74 75 76 77 78 79 80 81 86];

% Set up array to hold identity of nearest skin collector for each skin vertex
% Find how many skin vertices
nskin = length(Area);
Collecti = zeros(1,nskin);
for i = 1:nskin
    % Find distances^2 to all skin collectors
    ds2 = (Vskin(i,1) - Vdeep(SkinCollectors,1)).^2 ...
         +(Vskin(i,2) - Vdeep(SkinCollectors,2)).^2 ...
         +(Vskin(i,3) - Vdeep(SkinCollectors,3)).^2;
    % Find closest skin collector
    [ds2min,CloseCollector] = min(ds2);
    Collecti(i) = SkinCollectors(CloseCollector);
end