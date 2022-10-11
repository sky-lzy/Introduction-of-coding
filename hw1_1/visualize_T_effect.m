clear; close all; clc;

%% parameters
N_epochs = 20;
T = round(logspace(0, 4, N_epochs));
b = 0.7;
rou = 0.996;
N_dots = 10;
SNR = [1, 2, 5, 10];
sigma_n = sqrt(1./SNR);
rng(0); % set random seed


%% simulations 
length_bits = 100;
N_cycles = 100;
send_bits = randi([0, 1], 1, length_bits);

errors = zeros(4, N_epochs);
for epoch = 1:N_epochs
    for k = 1:4
        rng(0);
        for iter_n = 1:N_cycles
            receive_bits = digital_channel(send_bits, 1, T(epoch), b, rou, sigma_n(k));
            error_number = sum(abs(receive_bits-send_bits));
            errors(k, epoch) = errors(k, epoch) + error_number / length_bits;
            fprintf('epoch: %d, k: %d, iter: %d, finished!\n', epoch, k, iter_n);
        end
    end
end
errors = errors / N_cycles;

%% visualization
figure(); 
semilogx(T, errors(1, :), 'Marker', '*', 'Linewidth', 2); hold on;
semilogx(T, errors(2, :), 'Marker', 's', 'Linewidth', 2);
semilogx(T, errors(3, :), 'Marker', 'o', 'Linewidth', 2);
semilogx(T, errors(4, :), 'Marker', 'x', 'Linewidth', 2);
legend('SNR = 0 dB', 'SNR = 3 dB', 'SNR = 7 dB', 'SNR = 10 dB');
xlabel('Value of T');
ylabel('Error Rate');
set(gca, 'FontName', 'Times New Roman');
title('Variation of Error Rate with T', 'FontWeight', 'bold');
% saveas(gca, 'Error_with_T.pdf');
