clear; close all; clc;

addpath(genpath('../hw1_1'));

%% parameters
T = 1;
b = 0;
rou = 0;
N_SNR = 10;
SNR = logspace(-1, 1, N_SNR);
sigma_n = sqrt(1./SNR);
rng(0); % set random seed


%% simulations 
N_len = 500000;
send_bits = randi([0, 1], 1, N_len);
errors = zeros(3, N_SNR);
g2 = [1,0,1,1;1,1,1,1];

for iter = 1:N_SNR
    rng(0);
    rece_noncode = digital_channel(send_bits, 1, T, b, rou, sigma_n(iter));
    [rece_hard, ~] = conv_decode(conv_encode(send_bits, 2, 0, sigma_n(iter))', N_len, g2, 0, send_bits, 0, 0, 0);
    [rece_soft, ~] = conv_decode(conv_encode(send_bits, 2, 0, sigma_n(iter)), N_len, g2, 1, send_bits, 0, 0, 0);
    errors(1, iter) = sum(abs(rece_noncode - send_bits)) / N_len;
    errors(2, iter) = sum(abs(rece_hard - send_bits)) / N_len;
    errors(3, iter) = sum(abs(rece_soft - send_bits)) / N_len;
end


%% visualizations 
figure();
semilogy(pow2db(SNR/T), errors(1, :), 'Marker', 'o', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR/T), errors(2, :), 'Marker', '+', 'Linewidth', 2); 
semilogy(pow2db(SNR/T), errors(3, :), 'Marker', 'x', 'Linewidth', 2); 
legend('Non-code', 'hard-decode conv', 'soft-decode conv');
xlabel('SNR (dB)');
ylabel('Error Rate');
title('Channel Efficiency with Non-code, 834-code, 1/2-conv-code and 1/3-conv-code');
set(gca, 'FontName', 'Times New Roman');


