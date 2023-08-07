function [VAR_SMOOTH_FE,DATA,DATA_ECM] = DataPreparationCECM(MESH,DATA,DATA_ECM,wFE,xFE,VSinv)


% Printing reduced set of elements
%--------------------------------------
%DATA_DECM = ECMpointsPRINT(DATA_DECM,MESH,HYPERREDUCED_VARIABLES) ;
% -------------------------------------
VAR_SMOOTH_FE.ngausE = MESH.ngausE;
% Matrix of coordinates/connectivities
% ---------------------------
VAR_SMOOTH_FE.COOR = MESH.COOR ;
VAR_SMOOTH_FE.CN = MESH.CN ;
% Type of element
% --------------------------
VAR_SMOOTH_FE.TypeElement = MESH.TypeElement ;
% Dela. triangulation
% --------------------------
MESH = DefaultField(MESH,'IND_POLYG_ELEMENT',[]) ; 
if size(MESH.COOR,2) >1 && isempty(MESH.IND_POLYG_ELEMENT)
    VAR_SMOOTH_FE.DELTRIANG = delaunayTriangulation(MESH.COOR);
    switch VAR_SMOOTH_FE.TypeElement
        case 'Quadrilateral'
            IND_POLYG_ELEMENT = [1 2 3 4 1] ;
            %   ORDER_POLYNOMIALS  =[norder_poly,norder_poly] ;
        case 'Hexahedra'
            IND_POLYG_ELEMENT = [1 2 3 4 5 6 7 8 1] ;
        case 'Triangle'
            IND_POLYG_ELEMENT = [1 2 3 1] ;
        otherwise
            error('element not implemented')
    end
    VAR_SMOOTH_FE.IND_POLYG_ELEMENT = IND_POLYG_ELEMENT;   % Local numbering of corner nodes (polygon)  
else
    VAR_SMOOTH_FE.IND_POLYG_ELEMENT  = MESH.IND_POLYG_ELEMENT ; 
end
% ORDER POLYNOMIALS
% ----------------------------
ndim = size(MESH.COOR,2) ;
DATA = DefaultField(DATA,'posgp_given',[]) ;
norder_poly = round(MESH.ngausE^(1/ndim)-1);
ORDER_POLYNOMIALS = norder_poly*ones(1,ndim);

VAR_SMOOTH_FE.ORDER_POLYNOMIALS = ORDER_POLYNOMIALS;
VAR_SMOOTH_FE.wSTs =  wFE ;
VAR_SMOOTH_FE.VSinv = VSinv ; 


DATA= DefaultField(DATA,'xLIM',[]) ; 
DATA = DefaultField(DATA,'Integrand',[]) ; 
DATA_ECM.Integrand = DATA.Integrand ; 
DATA_ECM.xLIM = DATA.xLIM ; 