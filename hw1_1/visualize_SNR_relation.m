clear; close all; clc;

%% parameters
T = 10;
b = 0;
rou = 0;
N_dots = 10;
SNR = logspace(-1, 2, N_dots);
sigma_n = sqrt(1./SNR);
rng(0); % set random seed


%% simulation
N_bits = 100;
send_bits = randi([0, 1], 1, N_bits);
send_signal = (send_bits.*2-1)*(1+1j)/sqrt(2);
SNR_elec = zeros(1, N_dots);
for iter_n = 1:N_dots
    rng(0);
    [~, SNR_elec(iter_n)] = complex_elec_channel(send_signal, T, b, rou, sigma_n(iter_n));
end


%% visualization
figure(); hold on; box on; grid on;
plot(pow2db(SNR), pow2db(SNR_elec), 'Marker', '*', 'Linewidth', 2);
xlabel('SNR of Complex Sampling Channel (dB)');
ylabel('SNR of Comples Electrical Channel (dB)');
set(gca, 'FontName', 'Times New Roman');
title('Relationship of the SNRs', 'FontWeight', 'bold');
% saveas(gca, 'SNR_Relation.pdf');

%% utils
function y = complex_sample_channel(x, b, rou, sigma_n)

    N = length(x);

    betas = zeros(1, N);
    betas(1) = (randn() + 1j*randn()) / sqrt(2);
    for iter_i = 2:N
        z_i = (randn() + 1j*randn()) / sqrt(2);
        betas(iter_i) = rou*betas(iter_i-1) + sqrt(1-rou^2)*z_i;
    end

    a = sqrt(1-b^2) + b*betas;
    noise = (randn(1, N) + 1j*randn(1, N)) * sigma_n / sqrt(2);
    y = a.*x + noise;

end

function [v, SNR] = complex_elec_channel(u, T, b, rou, sigma_n)

    L = length(u);
    v = zeros(1, L);

    for iter_l = 1:L
        x = 1/sqrt(T)*u(iter_l)*ones(1, T);
        y = complex_sample_channel(x, b, rou, sigma_n);
        v(iter_l) = 1/sqrt(T)*sum(y);
    end

    SNR = mean(abs(v).^2)/sigma_n^2;

end

