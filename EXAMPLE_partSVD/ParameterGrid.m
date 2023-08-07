function [mu,ngrid_param,ncolumns,ActualSize] = ParameterGrid(SIZE_SNAPSHOT_MATRIX_IN_GBYTES,nrows,PARAMETER_DOMAIN,ndimparam,...
    NUMBER_ROW_MATRICES_PARTITION)

sizeMATRIX  = SIZE_SNAPSHOT_MATRIX_IN_GBYTES*1e9/8 ; 
ncolumns =  ceil(sizeMATRIX/nrows) ; 
ngrid_param = ceil(sqrt(ncolumns/ndimparam)) ; 
disp(['Number of parameter samples  = ',num2str(ngrid_param),' x ',num2str(ngrid_param)]) ;

GRID_PARAMETER_DOMAIN = [ngrid_param,ngrid_param] ;  % For constructing grid parameter domain 
ncolumns = ndimparam*ngrid_param.^2 ; 
disp(['Number of columns snapshot matrix = ',num2str(ncolumns)]) ;
ActualSize =  ncolumns*nrows*8e-9 ; 
disp(['Actual Size Snapshot matrix = ',num2str(ActualSize),' Gbytes'])
 
 
mu = cell(size(PARAMETER_DOMAIN)) ;
for i = 1:length(PARAMETER_DOMAIN)
    mu{i} = linspace(PARAMETER_DOMAIN{i}(1),PARAMETER_DOMAIN{i}(2),GRID_PARAMETER_DOMAIN(i)) ;
end
[mu1, mu2] = meshgrid(mu{1},mu{2}) ;
mu = [mu1(:), mu2(:)] ;
% PArtition

[mu,Partition] =  MakePartitionLocal(NUMBER_ROW_MATRICES_PARTITION,mu) ; 