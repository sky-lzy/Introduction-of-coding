clear; close all; clc;

%% parameters
T = 10;
b = 0;
rou = 0;
SNR = 100;
sigma_n = sqrt(1/SNR);


%% simulations
N = 900; % numbers of bits
send_bits = randi([0, 1], 1, N);
receive_bits1 = digital_channel(send_bits, 1, T, b, rou, sigma_n, true); % 1-bit for every symbol
receive_bits2 = digital_channel(send_bits, 2, T, b, rou, sigma_n, true); % 2-bit for every symbol
receive_bits3 = digital_channel(send_bits, 3, T, b, rou, sigma_n, true); % 3-bit for every symbol


