clear; close all; clc;

%% parameters
T = 1;
b = 0;
rou = 0;
N_SNR = 10;
SNR = logspace(-1, 0.5, N_SNR);
sigma_n = sqrt(1./SNR);
rng(0); % set random seed


%% simulations 
N_len = 90000;
send_bits = randi([0, 1], 1, N_len); 
errors = zeros(2, N_SNR);
for iter = 1:N_SNR
    rng(0);
    rece_834 = decode8_3_4(digital_channel(encode8_3_4(send_bits), 1, T, b, rou, sigma_n(iter)));
    rece_codes = digital_channel(send_bits, 1, T, b, rou, sigma_n(iter));
    errors(1, iter) = sum(abs(rece_codes - send_bits)) / N_len;
    errors(2, iter) = sum(abs(rece_834 - send_bits)) / N_len;
end


%% visualization
figure();
semilogy(pow2db(SNR/T), errors(1, :), 'Marker', 'o', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR/T), errors(2, :), 'Marker', '+', 'Linewidth', 2); 
legend('Non-code', '834-code');
xlabel('SNR (dB)');
ylabel('Error Rate');
title('Channel Efficiency with Non-code and 834-code');
set(gca, 'FontName', 'Times New Roman');



