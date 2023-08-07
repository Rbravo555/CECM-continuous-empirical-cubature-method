function [weig,posgp,shapef,dershapef] = Quadrilateral9NInPoints(TypeIntegrand)
% Computation of the information regarding the Gauss points, the shape
% functions and the derivative of those shapefunctions for
% 9Integrations points in an element of 9 points.
% SINCE GID IS THE PROGRAM FOR MESHING, THE FOLLOWING GUIDELINES SHOULD
% BE FOLLOWED
% https://www.gidhome.com/documents/referencemanual/PREPROCESSING/Mesh%20Menu/Element%20type
% In GID, cornes nodes are 1-2-3-4 (starting from (-1,-1)), midside nodes are 5-6-7-8, and the central node is 9
% AND

% https://www.gidhome.com/documents/customizationmanual/POSTPROCESS%20DATA%20FILES/Results%20format:%20ModelName.post.res/Gauss%20Points

if ~iscell(TypeIntegrand)
    % Standard 3-by-3 rule
    w1=5/9; w2=8/9; w3=5/9;
    weig= [w1*w1 w2*w1 w3*w1 w1*w2 w2*w2 w3*w2 w1*w3 w2*w3 w3*w3];
    p = sqrt(3/5);
    posgp=[-p   -p;    %   1
        0   -p;    %   5
        p   -p;    %   2
        -p    0;    %   8
        0    0;    %   9
        p    0;    %   6
        -p    p;    %   4
        0    p;    %   7
        p    p]';  %   3
    
    CONV = [1,5,2,8,9,6,4,7,3];
    
    [~,CONV] = sort(CONV) ;
    
    posgp = posgp(:,CONV) ;
    weig = weig(CONV) ;
else
    weig = TypeIntegrand{2}' ;
    posgp = TypeIntegrand{1} ; 
    
end



N = @(x,y) [x.*(x-1).*y.*(y-1)/4, x.*(x+1).*y.*(y-1)/4, ...
    x.*(x+1).*y.*(y+1)/4, x.*(x-1).*y.*(y+1)/4, ...
    (1-x.^2).*y.*(y-1)/2,  x.*(x+1).*(1-y.^2)/2,   ...
    (1-x.^2).*y.*(y+1)/2,  x.*(x-1).*(1-y.^2)/2,   ...
    (1-x.^2).*(1-y.^2)];



B = @(x,y) [(x-1/2).*y.*(y-1)/2,   (x+1/2).*y.*(y-1)/2, ...
    (x+1/2).*y.*(y+1)/2,   (x-1/2).*y.*(y+1)/2, ...
    -x.*y.*(y-1),          (x+1/2).*(1-y.^2),   ...
    -x.*y.*(y+1),          (x-1/2).*(1-y.^2),   ...
    -2*x.*(1-y.^2);
    x.*(x-1).*(y-1/2)/2,    x.*(x+1).*(y-1/2)/2, ...
    x.*(x+1).*(y+1/2)/2,    x.*(x-1).*(y+1/2)/2, ...
    (1-x.^2).*(y-1/2),       x.*(x+1).*(-y),   ...
    (1-x.^2).*(y+1/2),       x.*(x-1).*(-y),   ...
    (1-x.^2).*(-2*y)];


shapef = zeros(length(weig),9);
for i=1:length(weig)
    shapef(i,:) = N(posgp(1,i),posgp(2,i));
end

dershapef = zeros(2,9,length(weig));

for j=1:length(weig)
    dershapef(:,:,j) = B(posgp(1,j),posgp(2,j));
end
end