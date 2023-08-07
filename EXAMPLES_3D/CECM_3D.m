clc
clear
format long g
close all

restoredefaultpath;
NAMEFECODE =  ['../CODE_CECM'];  % Folder in which the source code is located
addpath(genpath(NAMEFECODE)) ;

% INPUTS
% ---------------------
InputDataFile =   'DATAlagrange3D_p3';
LOAD_FROM_MEMORY = 0;
DATA_from_MAIN.MAKE_VIDEO_POINTS = 0;  % Create an animated GIF
DATA_from_MAIN.NameVideo = [InputDataFile,'.gif']; % NAme of the animated GIF
DATA_from_MAIN.DelayBetweenFrames =0.25;  % Time delay between frames
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
    
    figure(134)
    hold on
    ylabel('Total number of iterations for zeroing one weight')
    xlabel('% Zeroed weights')
    npointsZEROED = length(DATA_AUX.AUXVAR.HISTORY.totalNumberIterationsForEliminatingOnePoint) ;
    XX =  (1:npointsZEROED)/npointsZEROED*100;
    
    bar(XX,DATA_AUX.AUXVAR.HISTORY.totalNumberIterationsForEliminatingOnePoint)
    
    
    % Acumulated
    CC = cumsum(DATA_AUX.AUXVAR.HISTORY.totalNumberIterationsForEliminatingOnePoint) ;    
    CC  = CC/CC(end)*100 ;     
    figure(135)
    hold on
    ylabel('Acumukated  iterations (%)  ')
    xlabel('% Zeroed weights')
    bar(XX,CC)
    
    
    % Number of paths explored 
    figure(136)
    hold on
    ylabel('Number of trials')
    xlabel('% Zeroed weights')
      
    bar(XX,DATA_AUX.AUXVAR.HISTORY.NumberOfTrialsForFindingViableRoute)
    
    
else
    % -------------------------------
    % Get mesh variables
    %--------------------------------
    clear('CECMoutputF.txt')
    diary('CECMoutputF.txt')
    
    [MESH,wFE,xFE] = GetMeshVariables3d(DATA) ;
    % --------------------------------
    % Evaluation integrands
    % --------------------------------
    
    DATA.Integrand.EVALUATE_GRADIENT = 0 ;
    
    if ~isfield(DATA.Integrand,'Partition')
        A = feval(DATA.Integrand.NameFunctionGenerate,xFE,DATA.Integrand) ;
        DATA.ExactIntegral = A'*wFE ;
    else
        [A,DATA]= EvaluateFunction_CELL(DATA,xFE,wFE)  ;
    end
    
    
    % Continuous Empirical Cubature Method
    [CECMoutput,DATA_AUX]= ContinuousECMgen(A,xFE,wFE,DATA,MESH,DATA_ECM) ;
    save(NAMEWSstore,'CECMoutput','DATA_AUX','DATA')
    ErrorCalcLocal(DATA,CECMoutput)  ;
    diary off
end
