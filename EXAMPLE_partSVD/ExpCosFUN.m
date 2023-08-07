function   A=    ExpCosFUN(x,DATA)
%  See /home/joaquin/Desktop/CURRENT_TASKS/MATLAB_CODES/TESTING_PROBLEMS_FEHROM/ContinuousEmpiricalCubatureM/Paper_hernandez2021ecm/09_ASSESSMENTpaper/Fun3D/README_Cubature3D.mlx
% ------------------------------------------------------------------------
% JAHO,  21-Oct-2021
% --------------------------____---------------------------------------------
if nargin == 0
    load('tmp.mat')
end


A = SinCosExpFun3D_2param(DATA.mu,x(:,1),x(:,2),x(:,3)) ;

