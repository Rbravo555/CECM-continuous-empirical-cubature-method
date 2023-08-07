function [InvCNmatrix, ElemNode, TableElements, ElemShared]= InverseConnectMatrix(CN) ;
% This function returns the "inverse" connectivity matrix
% given the connectivity element-node matrix CN
% Outut
% InvCNmatrix --> Connectivity matrix (Elements shared by each node)
% TableElements --> Elements shared by each element 
% Vectorized version
% % J.A. Hernández, jhortega@cimne.upc.edu  (35 April 2016, Barcelona, Spain)
if nargin == 0
    load('tmp2.mat')
    CN = [1 2  3 4
        4 5  2 6
        2 6  7 8
        7 10 9 6
        6 9  5 11];
end

[nelem nnodeE ] = size(CN) ;
nnode = max(max(CN)) ; % Number of total nodes
nzmaxLOC = nelem*nnodeE ; % Nonzero entries
InvCN = sparse([],[],[],nnode,nelem,nzmaxLOC); % Allocating memory for InvCN
for inode = 1:nnodeE   % Loop over number of nodes at each element
    i = CN(:,inode) ;
    j = 1:nelem ;
    s = ones(nelem,1);
    InvCN = InvCN + sparse(i,j,s,nnode,nelem,nelem) ;
end
% Condensed sparse matrix
[InvCNmatrix ElemNode maxELEM]= CondenseSparseMatrix(InvCN,nelem,nnode) ;
%
% % We also calculate here a nelem x nelemMAXshare element-element connectivity matrix
% But how to do it ? It doesn't seem trivial at all...
nzmaxLOC = 3*maxELEM ; % Nonzero entries, estimation
ElementBinaryMatrix = sparse([],[],[],nelem,nelem,nzmaxLOC); % Allocating memory for InvCN

iacum = 1;
for  ielem =1:maxELEM-1
    %
    ElementsIorig =InvCNmatrix(:,ielem) ;
    % indElemIloc = find(ElementsI~=0) ;
    % ElementsI= ElementsI(indElemIloc) ;
    jelemGL = ielem +1 ;
    for jelem = jelemGL:maxELEM
        ElementsJ =InvCNmatrix(:,jelem) ;
        indElemJloc = find(ElementsJ) ;  % Only nonzero elements
        ElementsJ= ElementsJ(indElemJloc) ;
        ElementsI = ElementsIorig(indElemJloc) ;
        % Remove repeated combinations
        Elements = unique([ ElementsI ElementsJ],'rows');
        iii =  Elements(:,1); 
        jjj =  Elements(:,2);
        sss = ones(size(jjj)) ;
        ElementBinaryMatrix = ElementBinaryMatrix + sparse(iii,jjj,sss,nelem,nelem,length(sss)); 
       
    end
end

 ElementBinaryMatrix = ElementBinaryMatrix + ElementBinaryMatrix' ; 
III = find(ElementBinaryMatrix) ; 
ElementBinaryMatrix(III) = 1 ; 
 % condensation 
 
 [TableElements, ElemShared, maxELEMshar]= CondenseSparseMatrix(ElementBinaryMatrix,nelem,nelem) ;

