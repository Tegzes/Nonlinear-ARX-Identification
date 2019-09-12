function mse = ObtainMSE( yhat,y )

% Calculation of mean squared errors

e = y-yhat;
mse = sum(e.^2)/length(e);
end

