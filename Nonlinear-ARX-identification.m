clear all;close all;clc;

load('iddata-08.mat');

%% Input for grade m and orders na and nb

m = input('Give m: ');
na = input('Order na: ');
nb = input('ORder nb: ');
nk = 1; % we consider the delay nk as 1
n = na+nb; % no. of system's inputs

%% Representation of identification data

uid = id.u;
yid = id.y;
subplot(211);plot(uid);legend('U Id');title('Identification Data');
subplot(212);plot(yid);legend('Y Id');

%% Representation of Validation Data

yval = val.y;
uval = val.u;
figure;
subplot(211);plot(uval);legend('U Val');title('Validation Data');
subplot(212);plot(yval);legend('Y Val');

% at negative time samples we consider elements to be 0 
 yid=[zeros(1,na+nb),yid'];
 uid=[zeros(1,na+nb),uid'];
 
 yval=[zeros(1,na+nb),yval'];
 uval=[zeros(1,na+nb),uval'];


%%% Prediction

%% Prediction on Identification Data

% matrix of phi parameters
phi = ObtainPhi(yid,uid,na,nb,nk,m,n);

% vector of theta parameters
theta = phi\id_array(:,3);

% estimated output
yhat = phi*theta;

mse = ObtainMSE(yhat,id_array(:,3));
figure;
plot(yid);hold on
plot(yhat,'r');
title(['MSE id=',num2str(mse)]); legend('Y id','Y id aprox');

%% Prediction on validation data

phiv = ObtainPhi(yval,uval,na,nb,nk,m,n);

yhatv = phiv*theta;

msev = ObtainMSE(yhatv,val_array(:,3));
figure;
plot(yval);hold on
plot(yhatv,'r');
title(['MSE  val=',num2str(msev)]); legend('Y id','Y val aprox');

%%% Simulation


ysid=[zeros(n,1)];

ysiv=[zeros(n,1)];

%% Simulation on identification data

ysid = Simulation(na,nb,nk,m,uid,ysid,theta);

mses = ObtainMSE(ysid,yid');
figure;
plot(yid);hold on
plot(ysid,'r');
title(['MSE simulation id = ',num2str(mses)]);
legend('Y id','Y sim id');

%% Simulation on validation data
ysiv = Simulation(na,nb,nk,m,uval,ysiv,theta);

msesv = ObtainMSE(ysiv,yval');
figure;
plot(yval);hold on
plot(ysiv,'r');
title(['MSE simulation val = ',num2str(msesv)]);
legend('Y val','Y sim val');
