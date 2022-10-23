clc;clear;close all

%% parameters 
T = 5;
b = 0;
rou = 0;

N_dots = 10;
SNRs = 2;
sigma_n = sqrt(1/(SNRs*T));

g2 = [1,0,1,1;1,1,1,1];
g3 = [1,1,0,1;1,0,1,1;1,1,1,1];


rng(0); % set random seed
N = 1200;
send_bits = randi([0, 1], 1, N);

%% simulations
errors = zeros(1,N_dots);
i = 1;
throws = 0:N_dots-1;
for throw = 0:N_dots-1
   v = conv_encode(send_bits, 2, 2, 0, sigma_n, 0);
    [~,corr_rate] = conv_decode(v,1200,g2,0,send_bits,0,0,0,2,throw);
    error = 1-corr_rate;
    errors(i) = error; 
    i = i+1;
end
figure();
    semilogy(throws, errors, 'Marker', '*', 'Linewidth', 2);hold on; grid on;
    xlabel('n for Every n Bits discard One Bit');
    ylabel('Minimum Error Bit Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Minimum Error Bit Rate with different discards', 'FontWeight', 'bold');