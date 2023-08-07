function A = EvaluateFunction_CELL(COOR,PARAMETER,NAME_PARAMETER,NameFunctionGenerate,LimitGbytesMatricesSnapshots);  

if nargin == 0
    load('tmp.mat')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NameWS_Store_Matrices = 'DATAWS/Amat_' ; 

% NameParam = DATA.Integrand.NameParameterMatrix ;  % This should be specified in the input data file
% if ~isempty(NameParam)
% PARAM = DATA.Integrand.(NameParam) ;
% else
%     PARAM = [] ; 
% end

Integrand = [] ; 

if ~isempty(PARAMETER) && iscell(PARAMETER)
    disp('Generating snapshot matrix (partitioned version)')
    disp(['Block matrices whose size in Gbytes is above ',num2str(LimitGbytesMatricesSnapshots),' will be stored in hard memory'])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A = cell(size(PARAMETER)) ;
    A = A(:)' ;
     
    for iparam = 1:length(A)
        disp(['Block iparam = ',num2str(iparam)])
        Integrand.(NAME_PARAMETER) = PARAMETER{iparam} ;
        Ai = feval(NameFunctionGenerate,COOR,Integrand) ;
    
        
        nbytesA = prod(size(Ai))*8e-9;
        if nbytesA > LimitGbytesMatricesSnapshots
            disp(['Storing in memory...(ncols =',num2str(size(Ai,2)),' size in Gb=',num2str(nbytesA), ' )'])
            NameWSLOC = [NameWS_Store_Matrices,num2str(iparam),'.mat'] ;
            save(NameWSLOC,'Ai') ;
            A{iparam} =NameWSLOC ;
            disp(['...Done '])
        else
            A{iparam}  = Ai;
            disp(['ncols =',num2str(size(Ai,2)),' size in Gbytes=',num2str(nbytesA), ' '])
        end
        
        
    end
  %  PARAM = cell2mat(PARAMETER) ;
   % DATA.Integrand.(NameParam) = PARAM ;
   % DATA.ExactIntegral = cell2mat(DATA.ExactIntegral) ;  
else
     Integrand.(NAME_PARAMETER) = PARAMETER ; 
    A = feval(NameFunctionGenerate,COOR,Integrand) ;
    
end
 