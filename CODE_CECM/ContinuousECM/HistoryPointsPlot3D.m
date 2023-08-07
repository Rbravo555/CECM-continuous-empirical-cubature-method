function HistoryPointsPlot3D(AUXVAR,MESH,VAR_SMOOTH_FE)
% Patterned after
% /home/joaquin/Desktop/CURRENT_TASKS/MATLAB_CODES/FE_HROM/LARGE_STRAINS/ContinuousECM/HistoryPointsPlot1D.m

if nargin == 0
    load('tmp.mat')
    
    % AUXVAR.DATALOC.SHOW_GAUSS_POINTS_IN_ITERATIVE_PLOT = 0;
    AUXVAR.DATALOC.PlotEvolutionWeights_MarkerSizeMin = 20 ;
    AUXVAR.DATALOC.PlotEvolutionWeights_MarkerSizeMax = 200 ;
    AUXVAR.DATALOC.ColorMarkerPOINTS = [0,0,1] ;
end

wALL = cell2mat(AUXVAR.HISTORY.WEIGHTS_all) ; % Weights during iterations
xALL =  AUXVAR.HISTORY.POINTS_all ;  % Location points during iterations
DATA.wMAX  = max(max(wALL)) ;  % Maximum weight (scaling purpose)
DATA.wMIN  = 0 ;
AUXVAR = DefaultField(AUXVAR,'fhandle',[]) ; %  =f ;
if isempty(AUXVAR.fhandle)
    f=  figure ;   
else
    f = AUXVAR.fhandle ;
end
hold on
DomainContPLOT3D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
axis equal
hold on
iter = 1;
h = zeros(size(wALL,1)) ;
% Magnitude of weights is represented as the size of the Marker
AUXVAR.DATALOC = DefaultField(AUXVAR.DATALOC,'PlotEvolutionWeights_MarkerSizeMin',5) ;
AUXVAR.DATALOC = DefaultField(AUXVAR.DATALOC,'PlotEvolutionWeights_MarkerSizeMax',100) ;
AUXVAR.DATALOC = DefaultField(AUXVAR.DATALOC,'ColorMarkerPOINTS',[0,0,1]) ;


DATA.MarkerSizeMin = AUXVAR.DATALOC.PlotEvolutionWeights_MarkerSizeMin ;
DATA.MarkerSizeMax = AUXVAR.DATALOC.PlotEvolutionWeights_MarkerSizeMax ;

% Plotting the points
for iplot = 1:length(h)
    wPOINT = wALL(iplot,iter) ;
    MarkerSizeLoc =  DATA.MarkerSizeMin +(DATA.MarkerSizeMax-DATA.MarkerSizeMin)/(DATA.wMAX-DATA.wMIN)*(wPOINT-DATA.wMIN) ;
    h(iplot) = plot3(xALL{iter}(iplot,1) ,xALL{iter}(iplot,2),xALL{iter}(iplot,3),'Color',AUXVAR.DATALOC.ColorMarkerPOINTS,'Marker','.','MarkerSize',MarkerSizeLoc);
end
DATA.h_cecm = h(1) ;


aaa = axis;

xlabel('x')
ylabel('y')
zlabel('z')


AUXVAR = DefaultField(AUXVAR,'CURRENT_AXIS',aaa) ;

axis(AUXVAR.CURRENT_AXIS) ;

DATA.LEGEND_GAUSS = [] ;

AUXVAR = DefaultField(AUXVAR,'DATA_from_MAIN',[]) ;
AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'SHOW_GAUSS_POINTS_IN_ITERATIVE_PLOT',0) ;


if AUXVAR.DATA_from_MAIN.SHOW_GAUSS_POINTS_IN_ITERATIVE_PLOT == 0
    AUXVAR.DATALOC.xGAUSS = [] ;
end
if ~isempty(AUXVAR.DATALOC.xGAUSS)
    xGAUSS=  AUXVAR.DATALOC.xGAUSS;
    wGAUSS=  AUXVAR.DATALOC.wGAUSS;
    hg = zeros(size(wGAUSS)) ;
    for iplot = 1:length(hg)
        wPOINT = wGAUSS(iplot) ;
        MarkerSizeLoc =  DATA.MarkerSizeMin +(DATA.MarkerSizeMax-DATA.MarkerSizeMin)/(DATA.wMAX-DATA.wMIN)*(wPOINT-DATA.wMIN) ;
        hg(iplot) = plot3(xGAUSS(iplot,1),xGAUSS(iplot,2),xGAUSS(iplot,3),'Color',[1,0,0],'Marker','.','MarkerSize',MarkerSizeLoc);
    end
    DATA.LEGEND_GAUSS = ['Gauss rule (',num2str(length(wGAUSS)),')'] ;
    DATA.h_gauss = hg(1) ;
end


if size(wALL,2) == 1
    
else    
    iterNEXT = iter + 1;    
    IndNOW = find(wALL(:,iter) == 0) ;
    npoints = size(wALL,1)-length(IndNOW) ;
    IndNEXT = find(wALL(:,iterNEXT) == 0) ;
    IndRemoveLOC = setdiff(IndNEXT,IndNOW) ;
    xRED = xALL{iter}(IndRemoveLOC,:) ;    
    hPOINT = plot3(xRED(1),xRED(2),xRED(3),'x','MarkerSize',30,'Color',[1,0,0]);
    if ~isempty(DATA.LEGEND_GAUSS)
        DATA.legend = legend([hPOINT,DATA.h_cecm,DATA.h_gauss],{'Point to be eliminated','CECM rule',DATA.LEGEND_GAUSS});
    else
        DATA.legend = legend([hPOINT,DATA.h_cecm],{'Point to be eliminated','CECM rule'});
    end    
    htitle = title(['First stage (elimination): STEP =',num2str(iter),';  Number of points = ',num2str(npoints),' (of ',num2str(size(wALL,1)),')'])  ;
    grid on
    icluster = 1;
    DATA.INDEXES_FIRST_STAGE  = AUXVAR.HISTORY.INDEXES_FIRST_STAGE ;
    DATA.INDEXES_SECOND_STAGE  = AUXVAR.HISTORY.INDEXEX_SECOND_STAGE ;
    AUXVAR.HISTORY = DefaultField(AUXVAR.HISTORY,'CONTROL_POINTS',[]) ;
    DATA.CONTROL_POINTS = AUXVAR.HISTORY.CONTROL_POINTS ;
    DATA.Include2ndStageIterations_PlotEvolutionWeights  = AUXVAR.DATALOC.Include2ndStageIterations_PlotEvolutionWeights ;
    %-------------------------
    DATA.wALL = wALL  ;
    DATA.xALL = xALL  ;
    niter = size(wALL,2) ;%  
    DATA.niter = niter;
    DATA.h = h  ;
    DATA.hPOINT = hPOINT;
    DATA.htitle = htitle ;
    % ----------------------------------------    
    AUXVAR = DefaultField(AUXVAR,'DATA_from_MAIN',[]) ;
    AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'MAKE_VIDEO_POINTS',0) ;
        
    if   AUXVAR.DATA_from_MAIN.MAKE_VIDEO_POINTS ==1        
        
        AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'NameVideo','animation.gif') ;
        DATA.NameVideo = AUXVAR.DATA_from_MAIN.NameVideo ;
        
        AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'DelayBetweenFrames',0.001) ;
        DATA.DelayBetweenFrames = AUXVAR.DATA_from_MAIN.DelayBetweenFrames ;
        
        AUXVAR = DefaultField(AUXVAR,'angle1',[]) ;
        AUXVAR = DefaultField(AUXVAR,'angle2',[]) ;
        
        DATA.anglesVIEW = [AUXVAR.angle1,AUXVAR.angle2] ;
        
        UpdateWeights3D_video(DATA,f) ;
    else
        guidata(gcf,DATA);
        SliderStep = [1/(niter-1),1/(niter-1)]  ;
        b = uicontrol('Parent',f,'Style','slider','Position',[81,20,419,23],...
            'value',icluster, 'min',1, 'max',niter,'Callback','UpdateWeights3D','SliderStep',SliderStep,'Tag','slide_tag');
    end
    
end