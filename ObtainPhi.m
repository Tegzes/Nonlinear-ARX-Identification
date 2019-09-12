function [ phi ] = ObtainPhi(y,u,na,nb,nk,m,n )

% In this function we will find the matrix of phi regresors as following:
% we generate elements of arx model y(k-i), u(k-i)
% then we get the elements at exponentiation coresponding to grade m
% after this we generate the combinations y(k-i)^i*u(k-i)^j
% with condition i+j<=m , finally we generate the matrix of regresors phi
% which contains arx liniar elements y,u , at exponentiation m


phi = [];

% initially we consider that there are no u,y elements at exponentiation m
L_yp = []; 
L_up = []; 
L_comb = [];

for k=n+1:length(y)
    Ly = -y(k-1:-1:k-na);
    Lu = u(k-1:-1:k-nb);
    for i = 1:m
        L_yp = Ly.^i; % generation of  y elements 
        L_up = Lu.^i; % generation of  u elements 
        for j = 1:m
          if(i+j<=m)
             L_comb = Ly.^i.*Lu.^j; % generation of combinated terms (y^i*u^j)
          end
      end
    end
    phi = [phi;Ly Lu L_yp L_up L_comb 1]; % adding to regresors matrix  
end

end

