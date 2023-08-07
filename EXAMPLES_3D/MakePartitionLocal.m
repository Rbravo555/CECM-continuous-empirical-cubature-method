function  DATA =  MakePartitionLocal(DATA,mu)

if nargin == 0
    load('tmp.mat')
end

nsnap = size(mu,1);
nrows = floor(nsnap/DATA.Integrand.NumberOfPartitions) ;
ntimes = floor(nsnap/nrows);
res =  nsnap-ntimes*nrows;
if res ~=0
    Partition = [repmat([nrows],ntimes,1);res ] ;
else
    Partition = repmat([nrows],ntimes,1);
end
DATA.Integrand.Partition = Partition ;

if DATA.Integrand.NumberOfPartitions > 1
   % DATA.Integrand.mu  =  mu;
%else
    
    %     DATA.Integrand.mu  =  mu;
    mu = mat2cell(mu,Partition', 2) ;
    %
   
end

 DATA.Integrand.NameParameterMatrix = 'mu';
    DATA.Integrand.Partition = Partition;
    DATA.Integrand.mu  =  mu;