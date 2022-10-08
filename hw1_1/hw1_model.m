clear; close all; clc;

%% parameters 
T = 10;
b = 0;
rou = 0;
SNR = 4;
sigma_n = sqrt(1/SNR);

% rng(0); % set random seed


%% simulations
N = 1000;
send_bits = randi([0, 1], 1, N);
receive_bits = digital_channel(send_bits, 4, T, b, rou, sigma_n);
error = sum(abs(send_bits-receive_bits));

