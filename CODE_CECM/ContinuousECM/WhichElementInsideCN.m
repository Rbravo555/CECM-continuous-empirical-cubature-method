function [elemCONTAINER,POLYINFO] = WhichElementInsideCN(xLOC,VAR_SMOOTH_FE,inew,POLYINFO) 
if nargin == 0
    load('tmp2_48.mat')
end

% List of candidates 
ELEMnear = POLYINFO.setElements(inew,:) ;
nNEIGHS = VAR_SMOOTH_FE.CONNECT_info.ElemShared(ELEMnear)  ; 
NEIGH_elemes = VAR_SMOOTH_FE.CONNECT_info.TableElements(ELEMnear,1:nNEIGHS) ; % Neighboring elements 
ELEMnear = [ELEMnear,NEIGH_elemes] ; % The first candidate is the element under consideration itelf

ielem = 1;
elemCONTAINER = [] ;
while ielem <= length(ELEMnear)
    elemLOC = ELEMnear(ielem) ;    
    [inELEM,onELEM,TriLocal] = IsInsideALL(xLOC,VAR_SMOOTH_FE,elemLOC,VAR_SMOOTH_FE.IND_POLYG_ELEMENT,POLYINFO)  ;
    POLYINFO.TriangulationDelaunay{elemLOC} = TriLocal ; 
    if inELEM == 1 || onELEM == 1
        elemCONTAINER  = elemLOC ;
    break
    end
    ielem = ielem + 1;
end