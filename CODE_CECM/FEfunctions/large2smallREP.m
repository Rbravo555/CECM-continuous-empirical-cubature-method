function [ListElements,IndGaussLoc ]=  large2smallREP(IndGauss,ngaus)

if nargin == 0
    ngaus = 8 ; 
    IndGauss =[1 2 3 4 9 20 ] ; 
    
   
end

DIV = IndGauss/ngaus ;
ListElements = ceil(DIV) ; 
ListElements = ListElements(:) ;  

IndGaussINI = ListElements*ngaus - ngaus  ; 
IndGaussLoc = IndGauss(:)-IndGaussINI; 

ListElements = unique(ListElements,'stable') ; 
