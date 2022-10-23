clear; close all; clc;

addpath(genpath('../hw1_1'));

%% parameters
T = 1;
b = 0;
rou = 0;
N_SNR = 10;
SNR = logspace(-1, 1, N_SNR);
sigma_n = sqrt(1./SNR);
sigma_n_834 = sqrt(1./SNR * 8/3);
sigma_n_conv2 = sqrt(1./SNR * 2);
sigma_n_conv3 = sqrt(1./SNR * 3);
rng(0); % set random seed


%% simulations 
N_len = 150000;
send_bits = randi([0, 1], 1, N_len);
errors = zeros(4, N_SNR);
g2 = [1,0,1,1;1,1,1,1];
g3 = [1,1,0,1;1,0,1,1;1,1,1,1];

for iter = 1:N_SNR
    rng(0);
    rece_noncode = digital_channel(send_bits, 1, T, b, rou, sigma_n(iter));
    rece_834 = decode8_3_4(digital_channel(encode8_3_4(send_bits), 1, T, b, rou, sigma_n_834(iter)));
    [rece_conv2, ~] = conv_decode(conv_encode(send_bits, 2, 0, sigma_n_conv2(iter))', N_len, g2, 0, send_bits, 0, 0, 0);
    [rece_conv3, ~] = conv_decode(conv_encode(send_bits, 3, 0, sigma_n_conv3(iter))', N_len, g3, 0, send_bits, 0, 0, 0);
    errors(1, iter) = sum(abs(rece_noncode - send_bits)) / N_len;
    errors(2, iter) = sum(abs(rece_834 - send_bits)) / N_len;
    errors(3, iter) = sum(abs(rece_conv2 - send_bits)) / N_len;
    errors(4, iter) = sum(abs(rece_conv3 - send_bits)) / N_len;
end


%% visualizations 
figure();
semilogy(pow2db(SNR/T), errors(1, :), 'Marker', 'o', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR/T), errors(2, :), 'Marker', '+', 'Linewidth', 2); 
semilogy(pow2db(SNR/T), errors(3, :), 'Marker', 'x', 'Linewidth', 2); 
semilogy(pow2db(SNR/T), errors(4, :), 'Marker', '*', 'Linewidth', 2); 
legend('Non-code', '834-code', '1/2-conv-code', '1/3-conv-code');
xlabel('Energy Efficiency (dB Joule / bit)');
ylabel('Error Rate');
title('Channel Efficiency with Non-code, 834-code, 1/2-conv-code and 1/3-conv-code');
set(gca, 'FontName', 'Times New Roman');


