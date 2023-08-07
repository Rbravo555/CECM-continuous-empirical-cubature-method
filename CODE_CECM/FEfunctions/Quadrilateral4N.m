function  [Ne, BeXi] = Quadrilateral4N(xiV) 
% Shape functions and derivatives for 4-node quadrilateral 
xi = xiV(1) ; eta = xiV(2) ; 
% Matrix of shape functions
Ne =0.25*[(1-xi)*(1-eta), (1+xi)*(1-eta), (1+xi)*(1+eta), (1-xi)*(1+eta) ]; 
% Matrix of the gradient of shape functions 
BeXi = 0.25*[ -(1-eta),  (1-eta),  (1+eta), -(1+eta) ; 
             -(1-xi) , -(1+xi) , (1+xi), (1-xi)   ] ; 
