function [POLYINFO,ELEMENTS_CONTAINING_xNEW,PHIk_y] = LocationPointsInElement_withCN(xNEW,VAR_SMOOTH_FE,POLYINFO,PHIk_y)
if nargin == 0
    load('tmp1.mat')
end

npoints = size(xNEW,1) ; % Number of points at which to evaluate the function


%[INDEXES_NEAR,IND_POLYG] = FindClosestNodes(xNEW,VAR_SMOOTH_FE) ; 
ELEMENTS_CONTAINING_xNEW = zeros((npoints),1) ; % Indices of the elements containing the points
POLYINFO.ListPointsOutside = [] ; % Lists points outside
for inew =1:npoints
    xLOC = xNEW(inew,:); % Coordinate of the point at which the function is to be evaluated
    % Searching for the element containing xLOC --> elemCONTAINER
    [elemCONTAINER,POLYINFO ]= WhichElementInsideCN(xLOC,VAR_SMOOTH_FE,inew,POLYINFO) ;     
    if isempty(elemCONTAINER)
       % Point outside the domain 
       PHIk_y = [];
        ELEMENTS_CONTAINING_xNEW(inew ) = 0 ;
        POLYINFO.ListPointsOutside = [POLYINFO.ListPointsOutside;inew] ;      
    else        
        ELEMENTS_CONTAINING_xNEW(inew ) = elemCONTAINER ;  % Element containing the point        
    end
   
end