function[ Nelem,posgp ] = ComputeNelemALL(TypeElement,nnodeE,ndim,nelem,TypeIntegrand) ; 
if nargin == 4
    TypeIntegrand = 'RHS';
end
%%%%
% This subroutine   returns
%  1) the matrix Nelem (ndim*nelem*ngaus x ndim*nnodeE)  consisting of all element shape function matrices
% Inputs:   COOR: Coordinate matrix (nnode x ndim), % CN: Connectivity matrix (nelem x nnodeE),
% TypeElement: Type of finite element (quadrilateral,...),
%% Vectorized version
% Joaquín A. Hernández (jhortega@cimne.upc.edu), 26-Oct-2015
%dbstop('10')
if nargin == 0
    load('tmp2.mat')
end
%nnode = size(COOR,1); ndim = size(COOR,2); nelem = size(CN,1); nnodeE = size(CN,2) ;
% Shape function routines (for calculating shape functions and derivatives)


[weig,posgp,shapef,dershapef] = ComputeElementShapeFun(TypeElement,nnodeE,TypeIntegrand) ;
ngaus = length(weig) ;
% Shape functions for vector  fields 
Ne = zeros(ngaus*ndim,nnodeE*ndim) ; 
for g = 1:ngaus
    indI = (g-1)*ndim+1; indF = g*ndim ; 
    Ne(indI:indF,:) = StransfN(shapef(g,:),ndim) ;
end
% Shape functions are INDEPENDENT of the physical coordinates
%                     ---------------------------------------
% Therefore, the sought-after Nelem matrix can be computed by making  nelem tiling
% copies of Ne
Nelem = repmat(Ne,nelem,1); 



% Initialization
% Nelem = zeros(ndim*nelem*ngaus,nnodeE*ndim) ;
% % Let us define a matrix ROWSgauss such that   Belem(ROWSgauss(g,:),:) returns 
% % the N-matrices of the g-th points of all elements
% indREF = 1:nstrain*ngaus*nelem ;
% ROWSgauss = reshape(indREF,nstrain,nelem*ngaus) ; 
% weigREP = repmat(weig',nelem,1)  ; % nelem x 1 tiling copies of weig  
% for  g = 1:ngaus
%     % Matrix of derivatives for Gauss point "g"
%     BeXi = dershapef(:,:,g) ;
%     % Jacobian Matrix for the g-th G. point of all elements %
%     JeALL = XeALL*BeXi' ;
%     %%%%%%%%%
%     % JAcobian
%     detJeALL= determinantVECTORIZE(JeALL,ndim) ;
%     % Matrix of derivatives with respect to physical coordinates
%     inv_JeTall = inverseTRANSvectorize(JeALL,ndim,detJeALL) ;
%     BeTILDEall = inv_JeTall*BeXi ;
%     % Matrix of symmetric gradient
%     % dbstop('18')
%     BeALL = QtransfBvect(BeTILDEall,ndim) ; % Transformation from B-matrix for scalar fields to B-matrix for vector fields
%     % Assigning BeALL ( g-th Gauss point) to the global matrix Belem    
%     ROWSglo =  ROWSgauss(:,g:ngaus:ngaus*nelem);   
%     ROWSglo = ROWSglo(:) ;      
%     Belem(ROWSglo,:) = BeALL ;   
%     % Weight vectors
%     % --------------
%     [wST,wSTs] = DetermineWeightsST(detJeALL,weigREP,ngaus,g,nelem,wST,wSTs,nstrain,ROWSglo);
%     
% end
