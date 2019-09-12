function [ ysim ] = Simulation( na,nb,nk,m,u,ysim,theta )


% Function for simulated output ('ysim') generation
% we begin by considering the simulation vector zero, with na + nb elements
% we generate the arx terms y(k-i) and u(k-i), 
% but this time we don't have access to systems outputs so we will use simulated outputs
% meaning that we replace y(k-i) with yhat(k-i)
% now we generate the nonlinear terms and add to simulated regresors matrix phi_sim
% then we obtain each simulated term by multiplying with theta vector
% and after that we add it to ysim

L_py = [];
L_pu = [];
L_comb = [];
ys = 0;

for k=1+na+nb:length(u)
    
    Lys = -ysim(k-1:-1:k-na);
    Lus = u(k-1:-1:k-nb);
    phi_sim = [];
    for i = 1:m
        L_py = Lys.^i;
        L_pu = Lus.^i;
        for j=1:m
             if(i+j<=m)
                 L_comb = (Lys.^i)'.*Lus.^j;
             end
        end
    end 
    phi_sim = [phi_sim; Lys' Lus L_py' L_pu L_comb 1]; % matrix of simulated regresors
    ys = phi_sim*theta; % obtaining a simulated term
    ysim = [ysim; ys]; % adding to simulation vector
             
end

end

