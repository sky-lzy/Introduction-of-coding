clear; close all; clc;

rng(0); % set random seed

T = round(logspace(0, 3, 50));

error = zeros(1, 50);
input_bits = round(rand(1, 1000));
for iter = 1:50
    output_bits = digital_channel(input_bits, T(iter), 0, 0, 1);
    error(iter) = sum(abs(output_bits - input_bits) > 0.5);
end

figure();
stem(error);

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

function output_bits = digital_channel(input_bits, T, b, rou, sigma_n)

    u = (input_bits*2-1) * (1+1j);
    v = complex_elec_channel(u, T, b, rou, sigma_n);
    output_bits = abs(v-(1+1j)) < abs(v-(-1-1j));

end