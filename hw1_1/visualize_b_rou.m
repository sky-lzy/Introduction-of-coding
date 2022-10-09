clear; close all; clc;

%% parameters
T = 10;
b = [0, 1, 0.7];
rou = [0, 1, 0.996];
N_SNR = 10;
SNR = logspace(-1, 1, N_SNR);
sigma_n = sqrt(1./SNR);


%% simulations 
rng(0); % set random seed
len_bits = 100;
N_cycle = 100;
send_bits = randi([0, 1], 1, len_bits);

errors = zeros(3, N_SNR);
for iter_SNR = 1:N_SNR

    for k = 1:3
        rng(0);
        for iter_n = 1:N_cycle
            receive_bits = digital_channel(send_bits, 1, T, b(k), rou(k), sigma_n(iter_SNR));
            error_num = sum(abs(send_bits - receive_bits));
            errors(k, iter_SNR) = errors(k, iter_SNR) + error_num / len_bits;
        end
    end

end
errors = errors / N_cycle;

%% visualization
figure(); 
semilogy(pow2db(SNR), errors(1, :), 'Marker', '*', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR), errors(2, :), 'Marker', 's', 'Linewidth', 2);
semilogy(pow2db(SNR), errors(3, :), 'Marker', 'o', 'Linewidth', 2);
legend('b = 0, rou = 0', 'b = 1, rou = 1', 'b = 0.7, rou = 0.996');
xlabel('SNR (dB)');
ylabel('Error Rate');
title('Variation of Error Rate with SNR within Different b and rou');
set(gca, 'FontName', 'Times New Roman');


