clc;clear;
N = 10;
dtest = round(rand(1,N));
T = 21;
K = 3;
sigma = 0.0001;
output = realcore_channel(dtest,1,T,K,sigma,1);
%% 