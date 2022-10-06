clear; close all; clc;

rng(0); % set random seed

input_bits = [0, 1, 1, 0, 0];
output_bits = digital_channel(input_bits);

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

function v = complex_elec_channel(u, T, b, rou, sigma_n)

    L = length(u);
    v = zeros(1, L);

    for iter_l = 1:L
        x = 1/sqrt(T)*u(iter_l)*ones(1, T);
        y = complex_sample_channel(x, b, rou, sigma_n);
        v(iter_l) = 1/sqrt(T)*sum(y);
    end

end

function output_bits = digital_channel(input_bits)

    u = (input_bits*2-1) * (1+1j);
    v = complex_elec_channel(u, 100, 0, 0, 0.1);
    output_bits = abs(v-(1+1j)) < abs(v-(-1-1j));

end