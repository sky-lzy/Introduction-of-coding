clc;clear;

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
    
    v = conv_encode(send_bits, 2, 2, crc, sigma_n(i), 0);
    [~,corr_rate] = conv_decode(v,1200,g3,1,send_bits,0,0,0,2,0);
    error = 1-corr_rate;
    errors3(i) = error;
end
figure(); 
    semilogy(pow2db(SNRs), errors2, 'Marker', 'o', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), errors3, 'Marker', '*', 'Linewidth', 2);
    legend("2-bits mapping", "3-bits mapping");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Bit Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Bit Rate - SNR without no coding(4000)', 'FontWeight', 'bold');
    
    
    
%% simulations 5000
errors2 = zeros(1,N_dots);
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    receive_bits = digital_channel(send_bits, 2, 1, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
    errors2(i) = error;
    
    receive_bits = digital_channel(send_bits, 3, 2, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
    errors3(i) = error;
end
figure(); 
    semilogy(pow2db(SNRs), errors2, 'Marker', 'o', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), errors3, 'Marker', '*', 'Linewidth', 2);
    legend("2-bits mapping", "3-bits mapping");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Bit Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Bit Rate - SNR without no coding(5000)', 'FontWeight', 'bold');
    
 %% simulations 6000
errors1 = zeros(1,N_dots);
errors2 = zeros(1,N_dots);
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    receive_bits = digital_channel(send_bits, 1, 1, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
    errors1(i) = error;
    
    receive_bits = digital_channel(send_bits, 2, 2, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
    errors2(i) = error;
    
    receive_bits = digital_channel(send_bits, 3, 3, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
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
    title('Error Bit Rate - SNR without no coding(6000)', 'FontWeight', 'bold');
    
    %% simulations 7500
errors1 = zeros(1,N_dots);
errors2 = zeros(1,N_dots);
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    receive_bits = digital_channel(send_bits, 1, 1, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
    errors1(i) = error;
    
    receive_bits = digital_channel(send_bits, 2, 2, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
    errors2(i) = error;
    
    receive_bits = digital_channel(send_bits, 3, 3, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
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
    title('Error Bit Rate - SNR without no coding(7500)', 'FontWeight', 'bold');
    
    %% simulations 9000
errors1 = zeros(1,N_dots);
errors2 = zeros(1,N_dots);
errors3 = zeros(1,N_dots);
for i = 1:N_dots
    receive_bits = digital_channel(send_bits, 1, 1, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
    errors1(i) = error;
    
    receive_bits = digital_channel(send_bits, 2, 3, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
    errors2(i) = error;
    
    receive_bits = digital_channel(send_bits, 3, 4, T, b, rou, sigma_n(i));
    error = sum(abs(send_bits-receive_bits))/N;
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
    title('Error Bit Rate - SNR without no coding(5000)', 'FontWeight', 'bold');