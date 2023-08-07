function COOR = SpatialGrid(X,P)

% X = DATA.SNAPSHOTMATRIX.SPATIAL_DOMAIN  ; % = {[-1,1],{-1,1},{-1,1}} ;
% P = DATA.SNAPSHOTMATRIX.GRID_SPATIAL_DOMAIN  ; 
COOR = cell(size(X)); 

for i = 1:length(X)
    COOR{i} = linspace(X{i}(1),X{i}(2),P(i)) ;
end
[X1, X2, X3] = meshgrid(COOR{1},COOR{2},COOR{3}) ;
COOR = [X1(:), X2(:), X3(:)] ; 