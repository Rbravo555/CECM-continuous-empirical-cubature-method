clc
clear all

NAMEFECODE =  ['../CODE_CECM'];  % Folder in which the source code is located
addpath(genpath(NAMEFECODE)) ;

% ------------------------
% MANDATORY INPUTS
% -----------------------
TOL_SVD_A =1e-4 ; % Tolerance SVD data matrix (RELATIVE)
UsePartitionedRandomizedAlgorithm =0;
GRID_SPATIAL_DOMAIN = [90,90,90] ;  % Spatial domain (CARTESIAN)
SIZE_SNAPSHOT_MATRIX_IN_GBYTES = 2;   % Size snapshot matrix
NUMBER_ROW_MATRICES_PARTITION =8 ;  % Number of partition for the snapshot matrix (along columns) A = [A1,A2...Am]
% END MANDATORY INPUTS


% DEFAULT INPUTS
% ----------------------------------------------------------------------
NameFunctionGenerate  ='ExpCosFUN' ; % % Name function
NAME_PARAMETER = 'mu';
ndimparam =  6 ; % Number of functions per each instantation of the parameter space
PARAMETER_DOMAIN = {[1,pi],[1,pi]} ;  % Parameter space (cartesian)
SPATIAL_DOMAIN = {[-1,1],[-1,1],[-1,1]} ;  % Spatial domain (CARTESIAN)
LimitGbytesMatricesSnapshots = 2 ;
% END DEFAULT INPUTS
%B ------------------------------------------------------------

% Constructing spatial grid
% -------------------------
COOR = SpatialGrid(SPATIAL_DOMAIN,GRID_SPATIAL_DOMAIN) ;
nrows = size(COOR,1) ;
disp(['Number of rows snapshot matrix = ',num2str(nrows)]) ;


% --------------------------------------------------
% Discretization parameter space so that size(A) = DATA.SIZE_SNAPSHOT_MATRIX_IN_GBYTES
[PARAMETER] = ParameterGrid(SIZE_SNAPSHOT_MATRIX_IN_GBYTES,nrows,...
    PARAMETER_DOMAIN,ndimparam,NUMBER_ROW_MATRICES_PARTITION) ;

% --------------------------
% Building snapshot matrix
% ------------------------
A = EvaluateFunction_CELL(COOR,PARAMETER,NAME_PARAMETER,NameFunctionGenerate,LimitGbytesMatricesSnapshots);

% INVOKING THE SINGULAR VALUE DECOMPOSITION
% -----------------------------------------
if UsePartitionedRandomizedAlgorithm == 1
    disp('Sequential Randomized SVD ')
    disp('-------------------------------------')
    tic
    [U,S,V] = SRSVD(A,TOL_SVD_A) ;
    toc
    disp('-------------------------------------')
    disp(['Number of singular values = ',num2str(length(S))])
    figure(1)
    hold on
    xlabel('Mode')
    ylabel('log(Singular value) ')
    h =  plot(log(S)) ;
    legend(h,['Partitioned RSVD, npart = ',num2str(length(A))])
    legend off
    legend
else
    disp('Standard SVD ')
    disp('-------------------------------------')
    DATALOC.RELATIVE_SVD = 1 ;
    if iscell(A)
        A = cell2mat(A) ;
    end
    tic
    [U,S,V] = SVDT(A,TOL_SVD_A,DATALOC) ;
    toc
    disp('-------------------------------------')
    disp(['Number of singular values = ',num2str(length(S))])
    figure(1)
    hold on
    xlabel('Mode')
    ylabel('log(Singular value) ')
    h =  plot(log(S),'LineStyle','--') ;
    legend(h,['Standard SVD'])
    legend off
    legend
end
