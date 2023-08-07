function [PARAMETER_MATRIX,Partition]= DetermineInputParameterSampling(DATAint)

if nargin == 0
    load('tmp.mat')
end
%

% % % Now we define locally the matrix of the sampled paramer in the form
% PARAMETER_SAMPLE = [mu(:,1),mu(:,2) ... mu(:,nparam)]
Dmu = DATAint.LimitsParameterSpace  ; %{[1,pi],[1,pi]} ; % Limits of the parameter domain (cartesian)
P = DATAint.NSNAP_PER_PARAMETER ;
mu = cell(size(Dmu)) ;
for i = 1:length(Dmu)
    mu{i} = linspace(Dmu{i}(1),Dmu{i}(2),P(i)) ;
end

if length(mu) == 2
    [mu1, mu2] = meshgrid(mu{1},mu{2}) ;
    GridParameterSpace = [mu1(:), mu2(:)] ;
else
    error('Implement this option ')
end

ncolumns_snapshot  =size(GridParameterSpace,1)*DATAint.ndimparam ;
nrows_snapshot = DATAint.NumberOfIntegrationPoints ;
SizeSnapMbytes = ncolumns_snapshot*nrows_snapshot*8e-6 ;
disp(['Size of snapshot matrix  = ',num2str(SizeSnapMbytes),' Mbytes'])
NumberOfPartitions = DATAint.NumberOfPartitions ; %ceil(SizeSnapMbytes/DATAint.LimitBlockSnapshotMatrixMbytes) ;


nsnap = size(GridParameterSpace,1);
nrows = ceil(nsnap/NumberOfPartitions) ;
ntimes = floor(nsnap/nrows);
res =  nsnap-ntimes*nrows;
if res ~=0
    Partition = [repmat([nrows],ntimes,1);res ] ;
else
    Partition = repmat(nrows,ntimes,1);
end

if length(Partition) == 1
    PARAMETER_MATRIX = GridParameterSpace ; 
else

PARAMETER_MATRIX = mat2cell(GridParameterSpace,Partition', 2) ;

end
disp(['PARTITIONS rows parameter space = ',num2str(Partition')])


 

 
 
   