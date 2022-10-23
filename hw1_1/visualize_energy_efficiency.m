clear; close all; clc;

%% parameters
T = 1;
b = 0;
rou = 0;
N_SNR = 10;
SNR1 = logspace(-1, 1, N_SNR);
SNR2 = SNR1 * 3 / 8;
sigma_n1 = sqrt(1./SNR1);
sigma_n2 = sqrt(1./SNR2);
rng(0); % set random seed


%% simulations 
N = 90000;
send_bits = randi([0, 1], 1, N);
errors = zeros(2, N_SNR);
for iter = 1:N_SNR
    rng(0);
    rece_codes = digital_channel(send_bits, 1, T, b, rou, sigma_n1(iter));
    rece_834 = decode8_3_4(digital_channel(encode8_3_4(send_bits), 1, T, b, rou, sigma_n2(iter)));
    errors(1, iter) = sum(abs(rece_codes - send_bits)) / N;
    errors(2, iter) = sum(abs(rece_834 - send_bits)) / N;
end


%% visualization 
figure();
semilogy(pow2db(SNR1/T), errors(1, :), 'Marker', 'o', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR1/T), errors(2, :), 'Marker', '+', 'Linewidth', 2); 
legend('Non-code', '834-code');
xlabel('Energy Efficiency (dB Joule/bit)');
ylabel('Error Rate');
title('Error Rate in Different Signal-Bit Ratio');
set(gca, 'FontName', 'Times New Roman');

