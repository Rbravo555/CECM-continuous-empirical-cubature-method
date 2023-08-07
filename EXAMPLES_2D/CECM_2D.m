clc
clear
format long g
close all

restoredefaultpath;
NAMEFECODE =  ['../CODE_CECM'];  % Folder in which the source code is located
addpath(genpath(NAMEFECODE)) ;

% INPUTS
% ---------------------
InputDataFile = 'DATAlagrange2D_p3';    
LOAD_FROM_MEMORY = 0;
DATA_from_MAIN.MAKE_VIDEO_POINTS = 0;  % Create an animated GIF
DATA_from_MAIN.NameVideo = [InputDataFile,'.gif']; % NAme of the animated GIF
DATA_from_MAIN.DelayBetweenFrames =0.5;  % Time delay between frames
%DATA_from_MAIN.AspectRatioPlotGraphLocationPointsVersusWeights = [1,1,0.1] ;
DATA_from_MAIN.SHOW_GAUSS_POINTS_IN_ITERATIVE_PLOT =0;

% END INPUTS
% -------------------------------
NAMEWSstore = [cd,filesep,'WSFILES',filesep,InputDataFile,'.mat'] ;

if exist('GetMeshVariables') ==0
    addpath(genpath(NAMEFECODE)) ;
end
eval(InputDataFile)

if LOAD_FROM_MEMORY == 1
    load(NAMEWSstore,'CECMoutput','DATA_AUX','DATA') ;
    DATA_AUX.AUXVAR.DATA_from_MAIN = DATA_from_MAIN;
    VariousPLOTS_CECM(DATA_AUX.DATA_ECM,CECMoutput,DATA_AUX.MESH,DATA_AUX.AUXVAR,...
        DATA_AUX.VAR_SMOOTH_FE)  ;
    ErrorCalcLocal(DATA,CECMoutput)  ;
    
else
    % -------------------------------
    % Get mesh variables
    %--------------------------------
    clear('CECMoutputF.txt')
    diary('CECMoutputF.txt')
    [MESH,wFE,xFE] = GetMeshVariables(DATA) ;
    % --------------------------------
    % Evaluation integrands
    % --------------------------------
    DATA.Integrand.EVALUATE_GRADIENT = 0 ;
    A = feval(DATA.Integrand.NameFunctionGenerate,xFE,DATA.Integrand) ;
    DATA.ExactIntegral = A'*wFE ;
    % Continuous Empirical Cubature Method
    [CECMoutput,DATA_AUX]= ContinuousECMgen(A,xFE,wFE,DATA,MESH,DATA_ECM) ;
    save(NAMEWSstore,'CECMoutput','DATA_AUX','DATA')
    ErrorCalcLocal(DATA,CECMoutput)  ;
    diary off
    
    
    
end
