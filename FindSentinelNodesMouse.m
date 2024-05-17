% Find the sentinel nodes for each deep inlet
% J. Baish
% April 22, 2023

% Set up array for identity of sentinel (first downstream) node for each deep inlet
sentineldeep = zeros(nins,1); 
% Find the sentinel lymph node for each deep inlet (skin and deep)
% Convert the final outlet (996) to a pseudo-node to avoid no termination
vertices(out) = 1;
for i=1:nins
    j=ins(i);
    while vertices(j)==0   % Keep searching if still not a node
        % Find all occurances of j in 'from'
        occur=find(from==j);
        % Find the first occurance of j in 'from', call it ind
        ind = occur(1); 
        % Replace j with to(ind)
        j = to(ind); 
    end
    sentineldeep(i) = j;
end

% If a node shows up as a sentinel node, find its deep inlets 
% Then find its skin vertices
sentinelnodes = unique(sentineldeep);
nsentinelnodes = length(sentinelnodes); 
% Plot the sentinel nodes with a circle around the node
plot3(xd(sentinelnodes),yd(sentinelnodes),zd(sentinelnodes),'o','Color','r','MarkerSize',4)

% The number of lymphosomes should match the number of sentinelnodes
lymphosome = {};
for i = 1:nsentinelnodes
    % Indices of deep inlets for each sentinel node (117 total)
    deepinletsforeachsentinel = ins(find(sentineldeep==sentinelnodes(i)));
    ndeepinlets = length(deepinletsforeachsentinel);
    lymphosome{i} = [];
    % for each deepinlet append the associated skin nodes
    for j = 1:ndeepinlets
        lymphosome{i} = [lymphosome{i},find(Collecti==deepinletsforeachsentinel(j))];
    end
end

Vlymphosomecentroid = zeros(length(lymphosome),3);
for i=1:length(lymphosome)
    % Locate centroid of each lymphosome
    Vlymphosomecentroid(i,:) = mean(Vskin(lymphosome{i},:));
end