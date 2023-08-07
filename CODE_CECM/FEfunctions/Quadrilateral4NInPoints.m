function [weig,posgp,shapef,dershapef] = Quadrilateral4NInPoints(TypeIntegrand) ; 
% This function returns, for each 4-node quadrilateral elements, 
% and using a 2x2 Gauss rule (ngaus=4): 
%
% weig = Vector of Gauss weights (1xngaus)
% posgp: Position of Gauss points  (ndim x ngaus)
% shapef: Array of shape functions (ngaus x nnodeE)
% dershape: Array with the derivatives of shape functions, with respect to
% element coordinates (ndim x nnodeE x ngaus)

%switch TypeIntegrand
%    case {'K','RHS'}
        % Four integration points
        
if ~iscell(TypeIntegrand)
  weig  = [1 1 1 1] ;
        posgp = 1/sqrt(3)*[-1 1 1 -1
            -1 -1 1 1 ];
else
    weig = TypeIntegrand{2}' ;
    posgp = TypeIntegrand{1} ; 
    
end        
        
      
        ndim = 2; nnodeE = 4 ;
        ngaus = length(weig) ;
        shapef = zeros(ngaus,nnodeE) ;
        dershapef = zeros(ndim,nnodeE,ngaus) ;
        for g=1:length(weig) ;
            xiV = posgp(:,g) ;
            [Ne BeXi] = Quadrilateral4N(xiV) ;
            shapef(g,:) = Ne ;
            dershapef(:,:,g) = BeXi ;
        end
%end