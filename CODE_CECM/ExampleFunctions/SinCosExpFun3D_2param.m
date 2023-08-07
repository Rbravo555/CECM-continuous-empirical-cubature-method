function Xfloc = SinCosExpFun3D_2param(mu,x,y,z)

P = size(mu,1) ;
Xfloc1 = zeros(length(x),P) ;
Xfloc2 = zeros(length(x),P) ;
Xfloc3 = zeros(length(x),P) ;
Xfloc4 = zeros(length(x),P) ;
Xfloc5 = zeros(length(x),P) ;
Xfloc6 = zeros(length(x),P) ;

B_x = (1-x) ; B_y = (1-y) ; B_z = (1-z) ;

for iMU = 1:size(mu,1)
    %  dbstop('80')
    mu1 = mu(iMU,1) ;
    mu2 = mu(iMU,2) ;
    
    C_x = cos(3*pi*mu1*(x+1)) ; %D_x = sin(3*pi*mu1*(x+1)) ;
    C_y = cos(3*pi*mu1*(y+1)) ; %D_y = sin(3*pi*mu1*(y+1)) ;
    E_x = exp(-(1+x)*mu1) ;  E_y = exp(-(1+y)*mu1) ;
    C_z = cos(3*pi*mu1*(z+1)) ; %D_z = sin(3*pi*mu1*(z+1)) ;
    E_z = exp(-(1+z)*mu2) ;
    
    
    Xfloc1(:,iMU) =  (B_x.*C_x).*E_x + 1;
    Xfloc2(:,iMU) =  (B_y.*C_y).*E_y + 1;
    Xfloc3(:,iMU) =  (B_x.*C_x).*E_y + 1;
    Xfloc4(:,iMU) =  (B_y.*C_y).*E_x + 1;
    Xfloc5(:,iMU) =  (B_x.*C_x).*E_z + 1 ;
    Xfloc6(:,iMU) =  (B_z.*C_z).*E_y  + 1;
end

Xfloc = zeros(size(Xfloc1,1),6*size(mu,1)) ;

Xfloc(:,1:6:end) = Xfloc1 ;
Xfloc(:,2:6:end) = Xfloc2 ;
Xfloc(:,3:6:end) = Xfloc3 ;
Xfloc(:,4:6:end) = Xfloc4 ;
Xfloc(:,5:6:end) = Xfloc5 ;
Xfloc(:,6:6:end) = Xfloc6 ;





end
