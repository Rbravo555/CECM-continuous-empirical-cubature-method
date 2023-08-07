function HistoryPointsDECM3D(AUXVAR,MESH,VAR_SMOOTH_FE)
% Patterned after
%/home/joaquin/Desktop/CURRENT_TASKS/MATLAB_CODES/FE_HROM/LARGE_STRAINS/ContinuousECM/HistoryPointsPlot3D.m
if nargin == 0
    load('tmp1.mat')
    
   % AUXVAR.DATA_from_MAIN.MAKE_VIDEO_POINTS = 0 ;
    % AUXVAR.DATALOC.SHOW_GAUSS_POINTS_IN_ITERATIVE_PLOT = 0;
  % AUXVAR.DATALOC.SHOW_MESH_DOMAIN = 1; 
end

% Build matrices of weights and points
HistoryPoints = AUXVAR.DATAOUTdecm.HistoryPoints ;
HistoryWeights = AUXVAR.DATAOUTdecm.HistoryWeights ;
DATA.errorDECM = AUXVAR.DATAOUTdecm.Error ;

%List of points
HistoryPoints_all = cellfun(@transpose,HistoryPoints,'UniformOutput',false) ;
HistoryPoints_all = unique(cell2mat(HistoryPoints_all(:)')) ;
zALL = HistoryPoints_all(:);
xALL = VAR_SMOOTH_FE.COORg(zALL,:) ; % Coordinates of all the DECM points
% Building wALL
niter = length(HistoryWeights) ;
wALL = zeros(length(zALL),niter) ;
for iter = 1:niter
    POINTloc = HistoryPoints{iter} ;
    wLOC = HistoryWeights{iter} ;
    [~,IB,IC] = intersect(zALL,POINTloc) ;
    wALL(IB,iter) = wLOC(IC) ;
end
%wMAX_1st  = max(max(wALL)) ;  % Maximum weight (scaling purpose)
wALL_2nd = cell2mat(AUXVAR.HISTORY.WEIGHTS_all) ; % Weights during iterations
DATA.wMAX = max(max(wALL_2nd)) ;  % Maximum weight (scaling purpose)
DATA.wMIN = 0 ;


f=  figure ;
hold on

% Plot boundary of the domain (or the mesh)
 DomainContPLOT3D(AUXVAR,MESH,VAR_SMOOTH_FE) ; 



axis equal
hold on
iter = 1;
h = zeros(size(wALL,1),1) ;
% Magnitude of weights is represented as the size of the Marker
AUXVAR.DATALOC = DefaultField(AUXVAR.DATALOC,'PlotEvolutionWeights_MarkerSizeMin',5) ;
AUXVAR.DATALOC = DefaultField(AUXVAR.DATALOC,'PlotEvolutionWeights_MarkerSizeMax',100) ;
DATA.MarkerSizeMin = AUXVAR.DATALOC.PlotEvolutionWeights_MarkerSizeMin ;
DATA.MarkerSizeMax = AUXVAR.DATALOC.PlotEvolutionWeights_MarkerSizeMax ;


for iplot = 1:length(h)
    wPOINT = wALL(iplot,iter) ;
    
    if wPOINT == 0
        h(iplot) = plot3(xALL(iplot,1) ,xALL(iplot,2),xALL(iplot,3),'Color',[0,0,0],'Marker','none');
    else
        iplotREF = iplot;
        MarkerSizeLoc =  DATA.MarkerSizeMin +(DATA.MarkerSizeMax-DATA.MarkerSizeMin)/(DATA.wMAX-DATA.wMIN)*(wPOINT-DATA.wMIN) ;
        h(iplot) = plot3(xALL(iplot,1) ,xALL(iplot,2),xALL(iplot,3),'Color',[0,0,0],'Marker','.','MarkerSize',MarkerSizeLoc);
        
    end
end
DATA.h_cecm = h(iplotREF) ;

AUXVAR.CURRENT_AXIS = axis; 

xlabel('x')
ylabel('y')
zlabel('z')

axis(AUXVAR.CURRENT_AXIS );  

npoints = length(find(wALL(:,iter)) >0) ;

htitle = title(['DECM: error (%) =',num2str(DATA.errorDECM(iter)*100),';  Number of points = ',num2str(npoints),' (of ',num2str(size(wALL,1)),')'])  ;
grid on
icluster = 1;


DATA.wALL = wALL  ;
DATA.xALL = xALL  ;
niter = size(wALL,2) ;% - npointsEND+1 ;
DATA.niter = niter;
DATA.h = h  ;
%    DATA.hPOINT = hPOINT;
DATA.htitle = htitle ;


AUXVAR = DefaultField(AUXVAR,'DATA_from_MAIN',[]) ;
AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'MAKE_VIDEO_POINTS',0) ;


if   AUXVAR.DATA_from_MAIN.MAKE_VIDEO_POINTS ==1
    
    
    AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'NameVideo','animation.gif') ;
    DATA.NameVideo = AUXVAR.DATA_from_MAIN.NameVideo ;
    
    AUXVAR.DATA_from_MAIN = DefaultField(AUXVAR.DATA_from_MAIN,'DelayBetweenFrames',0.001) ;
    DATA.DelayBetweenFrames = AUXVAR.DATA_from_MAIN.DelayBetweenFrames ;
    
    
    
    UpdateWeights3Ddecm_video(DATA,f) ;
    
    ok = menu('Press OK if you want to see the CECM reduction stages','OK','FINISH SIMULATION') ;
    
    
    [AUXVAR.angle1,AUXVAR.angle2 ] =view ;
    AUXVAR.fhandle = f ;
    
    if ok == 1
        
        for iplot = 1:length(DATA.h)
            delete(DATA.h(iplot))
        end
        delete(DATA.htitle) ;
        
        
        HistoryPointsPlot3D(AUXVAR,MESH,VAR_SMOOTH_FE) ;
    end
    
    
    
    
    
else
    guidata(gcf,DATA);
    SliderStep = [1/(niter-1),1/(niter-1)]  ;
    b = uicontrol('Parent',f,'Style','slider','Position',[81,20,419,23],...
        'value',icluster, 'min',1, 'max',niter,'Callback','UpdateWeights3D_DECM','SliderStep',SliderStep,'Tag','slide_tag');
end
