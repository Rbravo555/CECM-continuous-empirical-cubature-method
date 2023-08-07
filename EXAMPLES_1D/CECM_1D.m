clc
clear
format long g
close all

restoredefaultpath;
NAMEFECODE =  ['../CODE_CECM'];  % Folder in which the source code is located
addpath(genpath(NAMEFECODE)) ;

% INPUTS
% ---------------------
% Input data defining the functions  to be integrated (and other options)
InputDataFile =  'DATA_Lag_poly_5' ;  

% OTHER INPUTS
LOAD_FROM_MEMORY =0;  % Load from binary file results already computed
widthPLOTopt = 0.1;   % Width bar plot
DATA_from_MAIN.MAKE_VIDEO_POINTS = 0;  % Create an animated GIF
DATA_from_MAIN.NameVideo = [InputDataFile,'.gif']; % NAme of the animated GIF
DATA_from_MAIN.DelayBetweenFrames =0.2;  % Time delay between frames
% END INPUTS
% -------------------------------
NAMEWSstore = [cd,filesep,'WSDATA',filesep,InputDataFile,'.mat'] ;



if LOAD_FROM_MEMORY == 1
    load(NAMEWSstore,'CECMoutput','DATA_AUX')
    DATA_AUX.AUXVAR.DATA_from_MAIN = DATA_from_MAIN;
    VariousPLOTS_CECM(DATA_AUX.DATA_ECM,CECMoutput,DATA_AUX.MESH,DATA_AUX.AUXVAR,...
        DATA_AUX.VAR_SMOOTH_FE)  ;
    
    disp(['COORDINATE and WEIGHTS CECM POINTS'])
    disp('----------------------------------------------')
    x = CECMoutput.xCECM ;
    w = CECMoutput.wCECM ;
    table(x,w)
else
    clear('CECMoutputF.txt')
    diary('CECMoutputF.txt')
    % -------------------------------
    % Get mesh variables
    %------------------------
    eval(InputDataFile)
    [MESH,wFE,xFE] = GetMeshVariables1D(DATA) ;
    % Evaluation integrands
    % --------------------------------
    DATA.Integrand.EVALUATE_GRADIENT = 0 ;
    A = feval(DATA.Integrand.NameFunctionGenerate,xFE,DATA.Integrand) ;
   
    
    DATA.ExactIntegral = A'*wFE ;
    %     % Elements to exclude in the initial set
    %     DATA_ECM = DefaultField(DATA_ECM,'ListElementsExclude_fromGID',[]) ;
    %     if ~isempty(DATA_ECM.ListElementsExclude_fromGID)
    %         ListElementsToExclude = load(DATA_ECM.ListElementsExclude_fromGID) ;
    %         DATA_ECM.ListElementsToExclude = ListElementsToExclude(:,1) ;
    %     else
    %         DATA_ECM.ListElementsToExclude = [] ;
    %     end
    
    % Continuous Empirical Cubature Method
    
    [CECMoutput,DATA_AUX]= ContinuousECMgen(A,xFE,wFE,DATA,MESH,DATA_ECM) ;
    
    disp(['COORDINATE and WEIGHTS CECM POINTS'])
    disp('----------------------------------------------')
    x = CECMoutput.xCECM ;
    w = CECMoutput.wCECM ;
    table(x,w)
    
    save(NAMEWSstore,'CECMoutput','DATA_AUX')
    
    % Approximated integral
    Acecm = feval(DATA.Integrand.NameFunctionGenerate,CECMoutput.xCECM,DATA.Integrand) ;
    IntApproxCECM = Acecm'*CECMoutput.wCECM ;
    
    ErrorApprox = norm(CECMoutput.INTexac-IntApproxCECM)/norm(CECMoutput.INTexac)*100 ;
    %disp(['Approximation ERROR CECM original functions  ',num2str(ErrorApprox),' %'])
    disp(['Approximation ERROR CECM original functions  (',num2str(length(CECMoutput.wCECM)),')  ',num2str(ErrorApprox),' %'])
    
    
    
    figure(495)
    hold on
    xlabel('x')
    ylabel('Weights')
    grid on
    aaaa(1)= bar(CECMoutput.xCECM,CECMoutput.wCECM,widthPLOTopt,'FaceColor','b') ;
    legendGAUSS{1} = ['CECM',' m=',num2str(length(CECMoutput.wCECM))] ;
    
    aaaa(2)= bar(CECMoutput.xDECM,CECMoutput.wDECM,2*widthPLOTopt,'FaceColor','r' );
    legendGAUSS{2} = ['DECM',' m=',num2str(length(CECMoutput.wDECM))] ;
    
    DATA = DefaultField(DATA,'xGAUSS',[]) ;
    if ~isempty(DATA.xGAUSS)
        aaaa(3)= bar(DATA.xGAUSS,DATA.wGAUSS,1.1*widthPLOTopt,'FaceColor','g' );
        legendGAUSS{3} = ['GAUSS',' m=',num2str(length(DATA.wGAUSS))] ;
        
        Agauss= feval(DATA.Integrand.NameFunctionGenerate,DATA.xGAUSS,DATA.Integrand) ;
        IntApproxGAUSS = Agauss'*DATA.wGAUSS ;
        
        ErrorApprox = norm(CECMoutput.INTexac-IntApproxGAUSS)/norm(CECMoutput.INTexac)*100 ;
        disp(['Approximation ERROR GAUSS original functions  (',num2str(length(DATA.wGAUSS)),')  ',num2str(ErrorApprox),' %']) ;
        
        
    end
    
    legend(aaaa,legendGAUSS)
    
    
    
    
    diary off
    
end
