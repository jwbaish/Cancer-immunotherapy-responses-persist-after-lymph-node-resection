% function to find the pressures 
% arguments G, pknown, knownp, Qknown, knownQ
% knownp = indices of known pressures
% pknown = values of known pressure
% knownQ = indices of known flows into nodes from external sources
% Qknown = values of known flows (+ is into node)
% If flow unassigned then Q is assumed to be 0 and p unknown
% returns p,Q0 where all p's and Q0's are now known  
% At least one pressure must be assigned or all pressures have no reference
% Nodes should not have both known pressures and flows
% 4/15/2014

function [p,Q0] = pressureQ(G,knownp,pknown,knownQ,Qknown)

attached = find(any(G));    % indices of attached nodes
n  = length(G);             % n=number of nodes
i  = 1:n;					% i=indices of nodes
p  = zeros(1,n);
Q0 = zeros(1,n); 
p(knownp)  = pknown;	    % all pressures set to zero except known pressures
Q0(knownQ) = Qknown;        % all node flows set to zero except known flows
sumG  = sum(G);             % sum conductances over columns
sumGp = sumG.*p;
B = sumGp'-G*p'-Q0';		% right hand side of matrix equation
sumG(knownp) = -1;
A = G - diag(sumG,0);		% subtract sum from main diagonal
unknownp = find(~ismember(i,knownp)); % indices of unknown pressures
M = zeros(n);               % make a mask matrix
M(:,unknownp) = 1;
M = M|speye(n);
A = A.*M;

A = A(attached,attached);
B = B(attached);
% Now solve for p and Q0
Solution = zeros(1,n);
Solution(attached) = (sparse(A)\sparse(B))'; % sparse may be redundant

% Extract p and Q from Solution
p(unknownp) = Solution(unknownp);
Q0(knownp) = Solution(knownp);


