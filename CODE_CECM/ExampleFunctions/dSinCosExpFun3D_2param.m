function [Xfloc_x Xfloc_y Xfloc_z] = dSinCosExpFun3D_2param(mu,x,y,z)
P = size(mu,1);
Xfloc_x1 = zeros(length(x),P) ;
Xfloc_y1 = zeros(length(x),P) ;
Xfloc_z1 = zeros(length(x),P) ;

Xfloc_x2 = zeros(length(x),P) ;
Xfloc_y2 = zeros(length(x),P) ;
Xfloc_z2 = zeros(length(x),P) ;


Xfloc_x3 = zeros(length(x),P) ;
Xfloc_y3 = zeros(length(x),P) ;
Xfloc_z3 = zeros(length(x),P) ;

Xfloc_x4 = zeros(length(x),P) ;
Xfloc_y4 = zeros(length(x),P) ;
Xfloc_z4 = zeros(length(x),P) ;

Xfloc_x5 = zeros(length(x),P) ;
Xfloc_y5 = zeros(length(x),P) ;
Xfloc_z5 = zeros(length(x),P) ;

Xfloc_x6 = zeros(length(x),P) ;
Xfloc_y6 = zeros(length(x),P) ;
Xfloc_z6 = zeros(length(x),P) ;

B_x = (1-x) ; B_y = (1-y) ;  B_z = (1-z) ;

for iMU = 1:P
    mu1 = mu(iMU,1) ;
    mu2 = mu(iMU,2) ;
    
    C_x = cos(3*pi*mu1*(x+1)) ; D_x = sin(3*pi*mu1*(x+1)) ;
    C_y = cos(3*pi*mu1*(y+1)) ; D_y = sin(3*pi*mu1*(y+1)) ;
    E_x = exp(-(1+x)*mu1) ;  E_y = exp(-(1+y)*mu1) ;
    C_z = cos(3*pi*mu1*(z+1)) ; D_z = sin(3*pi*mu1*(z+1)) ;
    E_z = exp(-(1+z)*mu2) ;
    
    
    Xfloc_x1(:,iMU) =  (-C_x - 3*pi*mu1*B_x.*D_x - mu1*B_x.*C_x).*E_x ;
    %  Xfloc_x2(:,iMU) =  0;
    Xfloc_x3(:,iMU) =   (-C_x - 3*pi*mu1*B_x.*D_x).*E_y;
    Xfloc_x4(:,iMU) =  -mu2*(B_y.*C_y).*E_x;
    Xfloc_x5(:,iMU) =   (-C_x - 3*pi*mu1*B_x.*D_x).*E_z;
    %
    
    Xfloc_y2(:,iMU) =  (-C_y - 3*pi*mu1*B_y.*D_y - mu1*B_y.*C_y).*E_y   ;
    Xfloc_y3(:,iMU) =  -mu1*(B_x.*C_x).*E_y;;
    Xfloc_y4(:,iMU) =   (-C_y - 3*pi*mu1*B_y.*D_y).*E_x  ;
    Xfloc_y6(:,iMU) =  -mu1*(B_z.*D_z).*E_y;;
    %
    Xfloc_z5(:,iMU) =  -mu2*(B_x.*C_x).*E_z ; %+ (-C_z + 3*pi*mu1*B_z.*C_z).*E_y;
    Xfloc_z6(:,iMU) =   (-C_z - 3*pi*mu1*B_z.*D_z).*E_y;
    
end


Xfloc_x = zeros(size(Xfloc_x1,1),6*size(mu,1)) ;
Xfloc_y = zeros(size(Xfloc_x1,1),6*size(mu,1)) ;
Xfloc_z = zeros(size(Xfloc_x1,1),6*size(mu,1)) ;



Xfloc_x(:,1:6:end) = Xfloc_x1 ;
Xfloc_x(:,2:6:end) = Xfloc_x2 ;
Xfloc_x(:,3:6:end) = Xfloc_x3 ;
Xfloc_x(:,4:6:end) = Xfloc_x4 ;
Xfloc_x(:,5:6:end) = Xfloc_x5 ;
Xfloc_x(:,6:6:end) = Xfloc_x6 ;

Xfloc_y(:,1:6:end) = Xfloc_y1 ;
Xfloc_y(:,2:6:end) = Xfloc_y2 ;
Xfloc_y(:,3:6:end) = Xfloc_y3 ;
Xfloc_y(:,4:6:end) = Xfloc_y4 ;
Xfloc_y(:,5:6:end) = Xfloc_y5 ;
Xfloc_y(:,6:6:end) = Xfloc_y6 ;

Xfloc_z(:,1:6:end) = Xfloc_z1 ;
Xfloc_z(:,2:6:end) = Xfloc_z2 ;
Xfloc_z(:,3:6:end) = Xfloc_z3 ;
Xfloc_z(:,4:6:end) = Xfloc_z4 ;
Xfloc_z(:,5:6:end) = Xfloc_z5 ;
Xfloc_z(:,6:6:end) = Xfloc_z6 ;


end

