function [P,Pder ]= CoordinateMatrixPolynomial(COOR,n)
% if n =[2,2] --> then x = COOR(1,:), y = COOR(2,:)
% % P(x,y)=   [1,x,x^2,  ...
%     y,x*y,x^2*y  ...
%    y^2,x*y^2,x^2*y^2    ]_{1x9}
% See /home/joaquin/Desktop/CURRENT_TASKS/MATLAB_CODES/TESTING_PROBLEMS_FEHROM/ContinuousEmpiricalCubatureM/Paper_hernandez2021ecm/06_HROM_homog2D/OrderInterpolant.mlx
%
%
% and
% /home/joaquin/Desktop/CURRENT_TASKS/MATLAB_CODES/FE_HROM/LARGE_STRAINS/ContinuousECM/EvaluateBasisFunctionDIRECTFIT_aux.mlx

if nargin == 0
    load('tmp1.mat')
end

if nargout == 1
    COMPUTE_DERIVATIVE = 0 ;
else
    COMPUTE_DERIVATIVE = 1;
end

ndim = size(COOR,2) ;

nmon = prod(n+1) ;

nnode  = size(COOR,1) ;
P = zeros(nnode,nmon) ;

if ndim  == 1
    
    iacum = 0;
    for ix=0:n(1)
     %   for iy=0:n(2)
            iacum = iacum+1;
            P(:,iacum) = (COOR(:,1).^ix)   ; ;
      %  end
    end
    Pder = {} ;
    if COMPUTE_DERIVATIVE == 1
        % For the derivative with respect to  x
        iacum = 0;
        Pderx = zeros(nnode,nmon) ;
        for ix=0:n(1)
          %  for iy=0:n(2)
                iacum = iacum+1;
                if ix >=1
                    Pderx(:,iacum) = ix*(COOR(:,1).^(ix-1))  ;
                end
           % end
        end
        
%         % For the derivative with respect to  y
%         iacum = 0;
%         Pdery = zeros(nnode,nmon) ;
%         for ix=0:n(1)
%             for iy=0:n(2)
%                 iacum = iacum+1;
%                 if iy >=1
%                     Pdery(:,iacum) = (COOR(:,1).^(ix)).*(COOR(:,2).^(iy-1))*iy  ;
%                 end
%             end
%         end
        
        Pder = {Pderx} ;
    end
    
elseif ndim == 2
    iacum = 0;
    for ix=0:n(1)
        for iy=0:n(2)
            iacum = iacum+1;
            P(:,iacum) = (COOR(:,1).^ix).*(COOR(:,2).^iy)  ; ;
        end
    end
    Pder = {} ;
    if COMPUTE_DERIVATIVE == 1
        % For the derivative with respect to  x
        iacum = 0;
        Pderx = zeros(nnode,nmon) ;
        for ix=0:n(1)
            for iy=0:n(2)
                iacum = iacum+1;
                if ix >=1
                    Pderx(:,iacum) = ix*(COOR(:,1).^(ix-1)).*(COOR(:,2).^iy)  ;
                end
            end
        end
        
        % For the derivative with respect to  y
        iacum = 0;
        Pdery = zeros(nnode,nmon) ;
        for ix=0:n(1)
            for iy=0:n(2)
                iacum = iacum+1;
                if iy >=1
                    Pdery(:,iacum) = (COOR(:,1).^(ix)).*(COOR(:,2).^(iy-1))*iy  ;
                end
            end
        end
        
        Pder = {Pderx,Pdery} ;
    end
elseif ndim ==3
    % 3D -----------------------------------
    
    
    iacum = 0;
    for ix=0:n(1)
        for iy=0:n(2)
            for iz = 0:n(3)
                iacum = iacum+1;
                P(:,iacum) = (COOR(:,1).^ix).*(COOR(:,2).^iy).*(COOR(:,3).^iz)   ;
            end
        end
    end
    Pder = {} ;
    if COMPUTE_DERIVATIVE == 1
        % For the derivative with respect to  x
        iacum = 0;
        Pderx = zeros(nnode,nmon) ;
        for ix=0:n(1)
            for iy=0:n(2)
                for iz = 0:n(3)
                    iacum = iacum+1;
                    if ix >=1
                        Pderx(:,iacum) = ix*(COOR(:,1).^(ix-1)).*(COOR(:,2).^iy).*(COOR(:,3).^iz)  ;
                    end
                end
            end
        end
        
        % For the derivative with respect to  y
        iacum = 0;
        Pdery = zeros(nnode,nmon) ;
        for ix=0:n(1)
            for iy=0:n(2)
                for iz = 0:n(3)
                    iacum = iacum+1;
                    if iy >=1
                        Pdery(:,iacum) = (COOR(:,1).^(ix)).*((COOR(:,2).^(iy-1))*iy).*(COOR(:,3).^iz)   ;
                    end
                end
            end
        end
        
        % For the derivative with respect to  z
        iacum = 0;
        Pderz = zeros(nnode,nmon) ;
        for ix=0:n(1)
            for iy=0:n(2)
                for iz = 0:n(3)
                    iacum = iacum+1;
                    if iz >=1
                        Pderz(:,iacum) = (COOR(:,1).^(ix)).*((COOR(:,3).^(iz-1))*iz).*(COOR(:,2).^iy)   ;
                    end
                end
            end
        end
        
        Pder = {Pderx,Pdery,Pderz} ;
    end
    
else
    error('Option not implemented')
    
end



