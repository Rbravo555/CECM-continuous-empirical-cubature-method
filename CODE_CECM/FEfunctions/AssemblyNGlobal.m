function Nst = AssemblyNGlobal(Nelems,nelem,nnodeE,ndim,ngaus,CONNECT,nnode) ;
% This function returns the global "staked" shape function matrix given the following
% inputs
%  Nelems: Shape function matrices for all elements  (nelem*ngaus*ndim x nnodeE*ndim)
% nelem: Number of elements
% nnodeE: Number of nodes per element
% ndim: Number of spatial dimensions
% ngaus: Number of gauss per element %
% CONNECT: Array of connectivities
% nnode: Number of nodes
% %
% J.A. Hernández, jhortega@cimne.upc.edu  (27 Oct. 2015, Barcelona, Spain)
%dbstop('14')
if nargin == 0
    load('tmp1.mat')
end
m = ndim*nelem*ngaus ; % Number of rows
n = nnode*ndim ;          % Number of columns
nzmaxLOC = m*nnodeE*ndim ;   % Maximum number of zeros (number of entries of Belems)
Nst = sparse([],[],[],m,n,nzmaxLOC); % Allocating memory for Bst
for inode = 1:nnodeE   % Loop over number of nodes at each element
    setnodes = CONNECT(:,inode) ;  % Global numbering of the inode-th node of each element
    for idime = 1:ndim   % loop over spatial dimensions
        % We employ here the Matlab's built-in "sparse" function --> S = sparse(i,j,s,m,n,nzmax).
        %  This function uses
        % vectors i, j, and s to  generate an m-by-n sparse matrix
        % such that S(i(k),j(k)) = s(k), with space allocated
        % for nzmax nonzeros.
        % --------------------------------------------------------
        % 1) Extracting the column of Nelems corresponding to the idime-th
        % DOF of the inode-th node of each element
        DOFloc = (inode-1)*ndim+idime ;  % Corresponding indices
        s = Nelems(:,DOFloc) ;           % Corresponding column
        % -----------------------------------------------------------------
        % 2) Now we determine the position within matrix Bst of each entry
        % of vector "s"
        %  a) Rows
        i = [1:m]' ;  %    (all rows)
        %  b) Columns
        DOFglo = (setnodes-1)*ndim+idime ;      %  Global DOFs associated to nodes   "setnodes"
        %  and local DOF "idim". This vector has "nelem" entries,
        % while "i" has
        % "m=nstrain*nelem*ngaus ".
        % Therefore, we have to make
        % nstrain*ngaus tiling
        % copies of DOFglo (see next two lines)
        j = repmat(DOFglo', ndim*ngaus,1) ; %
        j = reshape(j,length(i),1) ;
        % Assembly process  (as sum of matrix with sparse representation)
        Nst = Nst + sparse(i,j,s,m,n,m) ;
    end
end