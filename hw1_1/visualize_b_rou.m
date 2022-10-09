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
send_case = [false, false, true];
recv_case = [false, true, true];

errors = zeros(3, 3, N_SNR);
for iter_SNR = 1:N_SNR

    for iter_case = 1:3
        for k = 1:3
            rng(0);
            for iter_n = 1:N_cycle
                receive_bits = digital_channel(send_bits, 1, T, b(k), rou(k), sigma_n(iter_SNR), false, send_case(iter_case), recv_case(iter_case));
                error_num = sum(abs(send_bits - receive_bits));
                errors(iter_case, k, iter_SNR) = errors(iter_case, k, iter_SNR) + error_num / len_bits;
            end
        end
    end

end
errors = errors / N_cycle;

%% visualization
errors1 = reshape(errors(1, :, :), [3, N_SNR]);
errors2 = reshape(errors(2, :, :), [3, N_SNR]);
errors3 = reshape(errors(3, :, :), [3, N_SNR]);

figure(); 
semilogy(pow2db(SNR), errors1(1, :), 'Marker', '*', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR), errors1(2, :), 'Marker', 's', 'Linewidth', 2);
semilogy(pow2db(SNR), errors1(3, :), 'Marker', 'o', 'Linewidth', 2);
legend('b = 0, rou = 0', 'b = 1, rou = 1', 'b = 0.7, rou = 0.996');
xlabel('SNR (dB)');
ylabel('Error Rate');
title('Variation of Error Rate with SNR within Different b and rou');
set(gca, 'FontName', 'Times New Roman');

figure(); 
semilogy(pow2db(SNR), errors2(1, :), 'Marker', '*', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR), errors2(2, :), 'Marker', 's', 'Linewidth', 2);
semilogy(pow2db(SNR), errors2(3, :), 'Marker', 'o', 'Linewidth', 2);
legend('b = 0, rou = 0', 'b = 1, rou = 1', 'b = 0.7, rou = 0.996');
xlabel('SNR (dB)');
ylabel('Error Rate');
title('Variation of Error Rate with SNR within Different b and rou (With known betas in recv)');
set(gca, 'FontName', 'Times New Roman');

figure(); 
semilogy(pow2db(SNR), errors3(1, :), 'Marker', '*', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR), errors3(2, :), 'Marker', 's', 'Linewidth', 2);
semilogy(pow2db(SNR), errors3(3, :), 'Marker', 'o', 'Linewidth', 2);
legend('b = 0, rou = 0', 'b = 1, rou = 1', 'b = 0.7, rou = 0.996');
xlabel('SNR (dB)');
ylabel('Error Rate');
title('Variation of Error Rate with SNR within Different b and rou (With known betas in both send and recv)');
set(gca, 'FontName', 'Times New Roman');

figure();
semilogy(pow2db(SNR), errors1(1, :), 'LineStyle', '-', 'Marker', 'o', 'Linewidth', 2); hold on;
semilogy(pow2db(SNR), errors1(2, :), 'LineStyle', '-', 'Marker', '+', 'Linewidth', 2);
semilogy(pow2db(SNR), errors1(3, :), 'LineStyle', '-', 'Marker', 'x', 'Linewidth', 2);
semilogy(pow2db(SNR), errors2(1, :), 'Linestyle', '--', 'Marker', 'o', 'Linewidth', 2);
semilogy(pow2db(SNR), errors2(2, :), 'Linestyle', '--', 'Marker', '+', 'Linewidth', 2);
semilogy(pow2db(SNR), errors2(3, :), 'Linestyle', '--', 'Marker', 'x', 'Linewidth', 2);
semilogy(pow2db(SNR), errors3(1, :), 'Linestyle', ':', 'Marker', 'o', 'Linewidth', 2);
semilogy(pow2db(SNR), errors3(2, :), 'Linestyle', ':', 'Marker', '+', 'Linewidth', 2);
semilogy(pow2db(SNR), errors3(3, :), 'Linestyle', ':', 'Marker', 'x', 'Linewidth', 2);
legend('b = 0, rou = 0, no beta', 'b = 1, rou = 1, no beta', 'b = 0.7, rou = 0.996, no beta', 'b = 0, rou = 0, recv beta', 'b = 1, rou = 1, recv beta', 'b = 0.7, rou = 0.996, recv beta', 'b = 0, rou = 0, send and recv beta', 'b = 1, rou = 1, send and recv beta', 'b = 0.7, rou = 0.996, send and recv beta');
xlabel('SNR (dB)');
ylabel('Error Rate');
