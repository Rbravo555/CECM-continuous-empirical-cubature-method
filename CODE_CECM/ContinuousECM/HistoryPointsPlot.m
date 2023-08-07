function HistoryPointsPlot(AUXVAR,MESH,VAR_SMOOTH_FE)
% Patterned after /home/joaquin/Desktop/CURRENT_TASKS/MATLAB_CODES/TESTING_PROBLEMS_FEHROM/CLUSTERING_HROM/10_HOMOG_3D_1T/WeightsPlotEvolution.m
% more specifically:
% /home/joaquin/Desktop/CURRENT_TASKS/MATLAB_CODES/TESTING_PROBLEMS_FEHROM/CLUSTERING_HROM/10_HOMOG_3D_1T/WeightPlot2D.m

if nargin == 0
    load('tmp1.mat')
    close all
    
end

if size(MESH.COOR,2) == 1
 %   HistoryPointsPlot1D(AUXVAR,MESH) ;
    HistoryPointsALL1D(AUXVAR,MESH,VAR_SMOOTH_FE)
elseif size(MESH.COOR,2) == 2
    HistoryPointsALL2D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
elseif size(MESH.COOR,2) == 3
    
    HistoryPointsALL3D(AUXVAR,MESH,VAR_SMOOTH_FE) ; 
    
end