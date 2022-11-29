%% initial test
clc;clear;close all;
N = 5;
dtest = round(rand(1,N));
T = 21;
K = 3;
fs = 10000;% 假定采样率10k
n0 = 0.0001;
sigma2 = fs*n0/2;
[output,es] = realcore_channel(dtest,2,T,K,fs,n0,1);
disp('BER:');
display(1-sum(output==dtest)/N);
disp('Eb/n0:');
display(pow2db(es/n0/N));
%% BER 1/3 convolutional code n-bits mapping
L = 100000;
g = [1,1,0,1;1,0,1,1;1,1,1,1];
input = round(rand(1,L));
T = 21;
K = 3;
fs = 10000;% 假定采样率10k
N_dots = 15;

n0 = logspace(-6,0,N_dots);
sigma2 = fs*n0/2;
ber_bit = zeros(3,N_dots);
Eb = zeros(1,N_dots);
for i = 1:N_dots
    output_code = conv_encode(input, 3, 0, 0);
    % 1bit mapping
    [output,es] = realcore_channel(output_code,1,T,K,fs,n0(i),0);
    [~,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
    ber_bit(1,i) = 1-corr_rate;
    Eb(1,i) = es/L;
    % 2bit mapping
    [output,es] = realcore_channel(output_code,2,T,K,fs,n0(i),0);
    [~,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
    ber_bit(2,i) = 1-corr_rate;
    Eb(2,i) = es/L;
    % 3bit mapping
    [output,es] = realcore_channel(output_code,3,T,K,fs,n0(i),0);
    [~,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
    ber_bit(3,i) = 1-corr_rate;
    Eb(3,i) = es/L;
end
figure();
semilogy(pow2db(Eb(1,:)./n0), ber_bit(1,:), 'Marker', 'o', 'Linewidth', 2); hold on;
semilogy(pow2db(Eb(2,:)./n0), ber_bit(2,:), 'Marker', 'o', 'Linewidth', 2);
semilogy(pow2db(Eb(3,:)./n0), ber_bit(3,:), 'Marker', 'o', 'Linewidth', 2);
grid on;
legend('1-bit mapping','2-bits mapping','3-bits mapping')
xlabel('Eb/n0(dB)');
ylabel('BER');
title('BER');
%% BER 1/3 convolutional code different symbol rate
L = 1000;
g = [1,1,0,1;1,0,1,1;1,1,1,1];
input = round(rand(1,L));
T = 21;
K = 3;
Rs = [10^3,10^6,10^9];
len_rs = length(Rs);
fs = Rs*T;
N_dots = 15;

n0 = logspace(-6,0,N_dots);
ber_bit = zeros(1,N_dots);
Eb = zeros(len_rs,N_dots);
figure();
for k = 1:len_rs
    for i = 1:N_dots
        output_code = conv_encode(input, 3, 0, 0);
        % 1bit mapping
        [output,es] = realcore_channel(output_code,1,T,K,fs(k),n0(i),0);
        [~,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
        ber_bit(k,i) = 1-corr_rate;
        Eb(k,i) = es/L;
    end
    semilogy(pow2db(Eb(k,:)./n0), ber_bit(1,:), 'Marker', 'o', 'Linewidth', 2); hold on;
    grid on;
    xlabel('Eb/n0(dB)');
    ylabel('BER');
    title('BER');
end