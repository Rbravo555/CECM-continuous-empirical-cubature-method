function  [mu,Partition, NameParameterMatrix] =  MakePartitionLocal(NumberOfPartitions,mu)

if nargin == 0
    load('tmp.mat')
end

nsnap = size(mu,1);
nrows = floor(nsnap/NumberOfPartitions) ;
ntimes = floor(nsnap/nrows);
res =  nsnap-ntimes*nrows;
if res ~=0
    Partition = [repmat([nrows],ntimes,1);res ] ;
else
    Partition = repmat([nrows],ntimes,1);
end


if NumberOfPartitions > 1
    
    mu = mat2cell(mu,Partition', 2) ;
    
    
end

 
 