clc;clear;close all

%% parameters 
T = 5;
b = 0;
rou = 0;

N_dots = 20;
SNRs = logspace(-3, 2, N_dots);
sigma_n = sqrt(1./(SNRs.*T));

g2 = [1,0,1,1;1,1,1,1];
g3 = [1,1,0,1;1,0,1,1;1,1,1,1];


rng(0); % set random seed
N = 1200;
send_bits = randi([0, 1], 1, N);

%% simulations 4000
%3bit映射成一个符号，效率1/2
errors2 = zeros(1,N_dots);
%2bit映射成一个符号，效率1/2，扔掉1bit
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    v = conv_encode(send_bits, 2, 3, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,3,0);
    error = 1-corr_rate;
    errors2(i) = error;
    
    v = conv_encode(send_bits, 2, 2, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,2,3);
    error = 1-corr_rate;
    errors3(i) = error;
end
figure(); 
    semilogy(pow2db(SNRs), errors2, 'Marker', 'o', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), errors3, 'Marker', '*', 'Linewidth', 2);
    legend("3-bits mapping", "2-bits mapping");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Bit Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Bit Rate - SNR without conv coding(4000)', 'FontWeight', 'bold');
    
    
    
%% simulations 5000
%3bit映射成一个符号，效率1/2
errors2 = zeros(1,N_dots);
% 2bit映射成一个符号，效率1/2，但是丢掉1/6 
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    v = conv_encode(send_bits, 2, 3, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,3,0);
    error = 1-corr_rate;
    errors2(i) = error;
    
    v = conv_encode(send_bits, 2, 2, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,2,6);
    error = 1-corr_rate;
    errors3(i) = error;
end
figure(); 
    semilogy(pow2db(SNRs), errors2, 'Marker', 'o', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), errors3, 'Marker', '*', 'Linewidth', 2);
    legend("3-bits mapping", "2-bits mapping");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Bit Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Bit Rate - SNR without conv coding(5000)', 'FontWeight', 'bold');
    
 %% simulations 6000
%2bit映射成一个符号，效率1/2
errors2 = zeros(1,N_dots);
%3bit映射成一个符号，效率1/3
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    v = conv_encode(send_bits, 2, 2, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,2,0);
    error = 1-corr_rate;
    errors2(i) = error;
    
    v = conv_encode(send_bits, 3, 3, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g3,0,send_bits,0,0,0,3,0);
    error = 1-corr_rate;
    errors3(i) = error;
end
figure(); 
    semilogy(pow2db(SNRs), errors2, 'Marker', '+', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), errors3, 'Marker', '*', 'Linewidth', 2);
    legend("2-bits mapping", "3-bits mapping");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Bit Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Bit Rate - SNR without conv coding(6000)', 'FontWeight', 'bold');
    
    %% simulations 7500
%2bit映射成一个符号，效率1/2
errors2 = zeros(1,N_dots);
%3bit映射成一个符号，效率1/3
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    v = conv_encode(send_bits, 2, 2, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,2,0);
    error = 1-corr_rate;
    errors2(i) = error;
    
    v = conv_encode(send_bits, 3, 3, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g3,0,send_bits,0,0,0,3,0);
    error = 1-corr_rate;
    errors3(i) = error;
end
figure(); 
    semilogy(pow2db(SNRs), errors2, 'Marker', '+', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), errors3, 'Marker', '*', 'Linewidth', 2);
    legend("2-bits mapping", "3-bits mapping");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Bit Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Bit Rate - SNR without conv coding(7500)', 'FontWeight', 'bold');
    
    %% simulations 9000
%1bit映射成一个符号，效率1/2，但是丢掉1/4
errors1 = zeros(1,N_dots);
%2bit映射成一个符号，效率1/2
errors2 = zeros(1,N_dots);
%3bit映射成一个符号，效率1/3
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    v = conv_encode(send_bits, 2, 1, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,1,4);
    error = 1-corr_rate;
    errors1(i) = error;
    
    v = conv_encode(send_bits, 2, 2, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,2,0);
    error = 1-corr_rate;
    errors2(i) = error;
    
    v = conv_encode(send_bits, 3, 3, 0, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g3,0,send_bits,0,0,0,3,0);
    error = 1-corr_rate;
    errors3(i) = error;
end
figure(); 
    semilogy(pow2db(SNRs), errors1, 'Marker', 'o', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), errors2, 'Marker', '+', 'Linewidth', 2);
    semilogy(pow2db(SNRs), errors3, 'Marker', '*', 'Linewidth', 2);
    legend("1-bits mapping", "2-bits mapping", "3-bits mapping");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Bit Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Bit Rate - SNR without conv coding(9000)', 'FontWeight', 'bold');