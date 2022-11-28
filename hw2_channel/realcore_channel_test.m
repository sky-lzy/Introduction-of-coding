%% initial test
clc;clear;
N = 100;
dtest = round(rand(1,N));
T = 21;
K = 3;
fs = 10000;% 假定采样率10k
n0 = 0.0001;
sigma2 = fs*n0/2;
[output,eb] = realcore_channel(dtest,1,T,K,fs,n0,1);
disp('BER:');
display(1-sum(output==dtest)/N);
disp('Eb/n0:');
display(pow2db(eb/n0));
%% BER 1/3 convolutional code 
L = 10000;
g = [1,1,0,1;1,0,1,1;1,1,1,1];
input = round(rand(1,L));
T = 21;
K = 3;
fs = 10000;% 假定采样率10k
N_dots = 15;

n0 = logspace(-6,0,N_dots);
sigma2 = fs*n0/2;
ber = zeros(1,N_dots);
Eb = zeros(1,N_dots);
for i = 1:N_dots
    output_code = conv_encode(input, 3, 0, 0);
    [output,eb] = realcore_channel(output_code,1,T,K,fs,n0(i),0);
    [decode,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
    ber(i) = 1-corr_rate;
    Eb(i) = eb;
end
figure();
semilogy(pow2db(Eb./n0), ber, 'Marker', 'o', 'Linewidth', 2); hold on;
grid on;
xlabel('Eb/n0(dB)');
ylabel('BER');
title('BER');