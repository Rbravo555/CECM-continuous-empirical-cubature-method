function HistoryPointsALL2D(AUXVAR,MESH,VAR_SMOOTH_FE)

if nargin == 0
    load('tmp.mat')
    close all
    AUXVAR.ShowLocationPointsBASE =1 ; %
    AUXVAR.AmplificationFactorDomain =0  ;
    AUXVAR.ASPECT_RATIO =[1,1,1]  ;
    AUXVAR.LineWidth =10 ;
    AUXVAR.ColorLines  = [0,0,0] ;
    AUXVAR.ColorToBeEliminated  = [1,0,0] ;
    AUXVAR.MarkerToBeEliminated  = 'o' ;
    AUXVAR.MarkerSizeToBeEliminated  = 20 ;
    AUXVAR.DATA_from_MAIN.MAKE_VIDEO_POINTS = 1;
end

AUXVAR = DefaultField(AUXVAR,'DATAOUTdecm',[]) ;
AUXVAR.DATAOUTdecm = DefaultField(AUXVAR.DATAOUTdecm,'HistoryPoints',[]) ;
AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'SHOW_ALSO_DECM_ITERATIVE_PROCESS_GRAPHICALLY',1) ;
AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'MAKE_VIDEO_POINTS',0) ;
AUXVAR = DefaultField(AUXVAR,'ShowLocationPointsBASE',1) ;
AUXVAR = DefaultField(AUXVAR,'AmplificationFactorDomain',0.2) ;
AUXVAR = DefaultField(AUXVAR,'LineWidth',4) ;
AUXVAR = DefaultField(AUXVAR,'ColorLines',[0,0,0]) ;
AUXVAR = DefaultField(AUXVAR,'ASPECT_RATIO',[1,1,0.5]) ;
AUXVAR = DefaultField(AUXVAR,'ColorToBeEliminated',[1,0,0]) ;
AUXVAR = DefaultField(AUXVAR,'MarkerToBeEliminated','x') ;
AUXVAR = DefaultField(AUXVAR,'MarkerSizeToBeEliminated',10) ;







if AUXVAR.DATA_from_MAIN.SHOW_ALSO_DECM_ITERATIVE_PROCESS_GRAPHICALLY == 1 && ~isempty( AUXVAR.DATAOUTdecm.HistoryPoints)
    if AUXVAR.DATA_from_MAIN.MAKE_VIDEO_POINTS == 1
        HistoryPointsDECM2D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
        %  HistoryPointsPlot1D(AUXVAR,MESH) ;
    else
        HistoryPointsDECM2D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
        HistoryPointsPlot2D(AUXVAR,MESH) ;
    end
    
else
    HistoryPointsPlot2D(AUXVAR,MESH) ;
end
