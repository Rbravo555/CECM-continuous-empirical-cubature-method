function [weig,posgp,shapef,dershapef] = ComputeElementShapeFun(TypeElement,nnodeE,TypeIntegrand) ;
% This function returns, for each "TypeElement" and 'TypeIntegrand'
% (K/RHS)*
% weig = Vector of Gauss weights (1xngaus)
% posgp: Position of Gauss points  (ndim x ngaus)
% shapef: Array of shape functions (ngaus x nnodeE)
% dershape: Array with the derivatives of shape functions, with respect to
% element coordinates (ndim x nnodeE x ngaus)
%
% *) TypeIntegrand = 'K': For integration of Conductance Matrix
% *) TypeIntegrand = 'RHS': For integration of flux vectors

switch TypeElement
    case 'Linear'
        if nnodeE ==2
            [weig,posgp,shapef,dershapef] = Linear2NInPoints(TypeIntegrand) ;
        elseif   nnodeE ==3 
             [weig,posgp,shapef,dershapef] = Linear3NInPoints(TypeIntegrand) ;
        else
            error('Option not implemented')
        end
    case 'Triangle'
        if nnodeE ==3
            [weig,posgp,shapef,dershapef] = Triangular3NInPoints(TypeIntegrand) ;
        else
            error('Option not implemented')
        end
        
    case 'Quadrilateral'
        if nnodeE ==4
            [weig,posgp,shapef,dershapef] = Quadrilateral4NInPoints(TypeIntegrand) ;
        elseif nnodeE ==9 
            [weig,posgp,shapef,dershapef] = Quadrilateral9NInPoints(TypeIntegrand) ;
        else
            error('Option not implemented')
        end
    case 'Tetrahedra'
        if nnodeE ==4 
             [weig,posgp,shapef,dershapef] = Tetrahedra4NInPoints(TypeIntegrand) ; 
        else
             error('Option not implemented')
        end    
        
        
    case 'Hexahedra'
        if nnodeE ==8
            [weig,posgp,shapef,dershapef] = Hexahedra8NInPoints(TypeIntegrand) ;
        elseif nnodeE ==27
            [weig,posgp,shapef,dershapef] = Hexahedra27NInPoints(TypeIntegrand) ;
        else
            error('Option not implemented')
        end
    otherwise
        error('Option not implemented')
end