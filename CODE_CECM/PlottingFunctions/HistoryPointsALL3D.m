function HistoryPointsALL3D(AUXVAR,MESH,VAR_SMOOTH_FE)

if nargin == 0
    load('tmp.mat')
    AUXVAR.DATA_from_MAIN.MAKE_VIDEO_POINTS = 0; 
end


AUXVAR = DefaultField(AUXVAR,'DATAOUTdecm',[]) ;
AUXVAR.DATAOUTdecm = DefaultField(AUXVAR.DATAOUTdecm,'HistoryPoints',[]) ;
AUXVAR = DefaultField(AUXVAR,'DATA_from_MAIN',[]) ;
AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'SHOW_ALSO_DECM_ITERATIVE_PROCESS_GRAPHICALLY',1) ;
AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'MAKE_VIDEO_POINTS',0) ;

if AUXVAR.DATA_from_MAIN.SHOW_ALSO_DECM_ITERATIVE_PROCESS_GRAPHICALLY == 1 && ~isempty( AUXVAR.DATAOUTdecm.HistoryPoints)
    if AUXVAR.DATA_from_MAIN.MAKE_VIDEO_POINTS == 1
        HistoryPointsDECM3D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
    else
        HistoryPointsDECM3D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
        HistoryPointsPlot3D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
    end
else
    HistoryPointsPlot3D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
end
