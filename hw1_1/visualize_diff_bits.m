clear; close all; clc;

%% parameters
T = 10;
b = 0;
rou = 0;
N_SNR = 10;
SNR = logspace(-1, 1, N_SNR);
sigma_n = sqrt(1./SNR);
rng(0); % set random seed


%% simulations 
N = 9000;
send_bits = randi([0, 1], 1, N);
errors = zeros(3, N_SNR);
for iter = 1:N_SNR

    for nbits = 1:3
        rng(0);
        receive_bits = digital_channel(send_bits, nbits, T, b, rou, sigma_n(iter));
        errors(nbits, iter) = sum(abs(receive_bits - send_bits)) / N;
    end

end


%% visualization 
figure(); hold on; box on; grid on;
plot(pow2db(SNR), pow2db(errors(1, :)), 'Marker', 'o', 'Linewidth', 2);
plot(pow2db(SNR), pow2db(errors(2, :)), 'Marker', '+', 'Linewidth', 2);
plot(pow2db(SNR), pow2db(errors(3, :)), 'Marker', 'x', 'Linewidth', 2);
xlabel('SNR (dB)');
ylabel('Error Rate (dB)');
title('Error Rate in Different Signal-Bit Ratio');
set(gca, 'FontName', 'Times New Roman');
legend('1 bit per signal', '2 bits per signal', '3 bits per signal');
saveas(gca, 'Diff_SBR.pdf');

