% ESSENTIAL INPUTS 
DATA.Integrand.NameFunctionGenerate  =  'LagrangePolynomial1Dnew';  %    Lagrange polynmial 1D
DATA.Integrand.xLIM = [-1,1] ;  %  
DATA.Integrand.PORDER  =  5 ;  % This is the order of the polynomial we want to integrate  
DATA.NumberOfElementsFE =200 ; % Number of elements in the FE partition
DATA.NumberOfGaussPointsPerElement = [4] ; % number of gauss points per element 
DATA_ECM.Method_Evaluation_Basis_Integrand =2; % 1 --> FE fitting   / 2 ---> FE analytical evaluation  


% for comparison purposes:   GAUSS RULE  
% m >= (p+1)/2 
mGAUSS = ceil((DATA.Integrand.PORDER +1)/2) ; 
[DATA.xGAUSS, DATA.wGAUSS] = GaussQuad(mGAUSS, DATA.Integrand.xLIM(1), DATA.Integrand.xLIM(2)) ;



% Default inputs 
% -------------------------------------------------
DATA_ECM.ACTIVE =1;  % Enable the continuous empirical cubature method
DATA_ECM.TOL_SVD_A =0 ; % Tolerance SVD data matrix  (here it is just for orthogonalization purposes)
DATA_ECM.UsePartitionedRandomizedAlgorithm = 0 ;  % Use advanced SVD
DATA_ECM.TOL_NewtonRaphson_EliminationPoints = 1e-8 ;  % Tolerance for the Newton-Raphson algorithm
DATA_ECM.MaxIterationsNR_ElimPoints = 40 ;  % Number of iteration for each NR step
DATA_ECM.SECOND_STAGE_ITERATIONS  = 20 ;   % Number of steps for each weight elimination in the second stage

%DATA_ECM.Include2ndStageIterations_PlotEvolutionWeights = 1; 

