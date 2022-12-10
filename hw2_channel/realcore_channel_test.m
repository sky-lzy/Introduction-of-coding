%% initial test
clc;clear;close all;
N = 100;
dtest = round(rand(1,N));
T = 21;
K = 3;
fs = 10000;% 假定采样率10k
n0 = 0.0001;
sigma2 = fs*n0/2;
[output,es] = realcore_channel(dtest,1,T,K,fs,n0,1);
disp('BER:');
display(1-sum(output==dtest)/N);
disp('Eb/n0:');
display(pow2db(es/n0/N));
%% BER 1/3 convolutional code - n-bits mapping
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
title('BER with different mapping');
%% BER 1/3 convolutional code - different symbol rate
L = 100000;
g = [1,1,0,1;1,0,1,1;1,1,1,1];
input = round(rand(1,L));
T = 21;
K = 3;
Rs = [10^3,10^4,10^5];
len_rs = length(Rs);
fs = Rs*T;
N_dots = 15;

n0 = logspace(-6,0,N_dots);
ber_bit = zeros(len_rs,N_dots);
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
    semilogy(pow2db(Eb(k,:)./n0), ber_bit(k,:), 'Marker', '*', 'Linewidth', 2);hold on;
end
grid on;
xlabel('Eb/n0(dB)');
ylabel('BER');
title('BER with different bps');
legend('1k symbols/s','10k symbols/s','100k symbols/s');
%% BER 1/3 convolutional code - different K T
L = 10000;
g = [1,1,0,1;1,0,1,1;1,1,1,1];
input = round(rand(1,L));
T = [2,3,5,10,21,30];
K = [2.5,2.5,2.5,3,3,3];
fs = 10000;
N_dots = 30;
len_KT = length(T);

n0 = logspace(-6,1,N_dots);
ber_bit = zeros(len_KT,N_dots);
Eb = zeros(len_KT,N_dots);
figure();
for k = 1:len_KT
    for i = 1:N_dots
        output_code = conv_encode(input, 3, 0, 0);
        % 1bit mapping
        [output,es] = realcore_channel(output_code,1,T(k),K(k),fs,n0(i),0);
        [~,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
        ber_bit(k,i) = 1-corr_rate;
        Eb(k,i) = es/L;
    end
    semilogy(pow2db(Eb(k,:)./n0), ber_bit(k,:), 'Marker', '*', 'Linewidth', 1.5); hold on;
end
grid on;
xlabel('Eb/n0(dB)');
ylabel('BER');
title('BER with differernt K T');
legend('K = 2.5 T = 2','K = 2.5 T = 3','K = 2.5 T = 5','K = 3 T = 10','K = 3 T = 21','K = 3 T = 30');
%% BER 1/3 convolutional code - K = 2.5/3.25
L = 10000;
g = [1,1,0,1;1,0,1,1;1,1,1,1];
input = round(rand(1,L));
T = [2,3,5,10];
K = 2.5*ones(1,4);
fs = 10000;
N_dots = 30;
len_KT = length(T);

n0 = logspace(-6,1,N_dots);
ber_bit1 = zeros(len_KT,N_dots);
ber_bit2 = zeros(len_KT,N_dots);
ber_bit3 = zeros(len_KT,N_dots);
Eb1 = zeros(len_KT,N_dots);
Eb2 = zeros(len_KT,N_dots);
Eb3 = zeros(len_KT,N_dots);

figure();
for k = 1:len_KT
    for i = 1:N_dots
        output_code = conv_encode(input, 3, 0, 0);
%         % 1bit mapping
%         [output,es] = realcore_channel(output_code,1,T(k),K(k),fs,n0(i),0);
%         [~,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
%         ber_bit1(k,i) = 1-corr_rate;
%         Eb1(k,i) = es/L;
        % 2bit mapping
        [output,es] = realcore_channel(output_code,2,T(k),K(k),fs,n0(i),0);
        [~,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
        ber_bit2(k,i) = 1-corr_rate;
        Eb2(k,i) = es/L;
        % 3bit mapping
        [output,es] = realcore_channel(output_code,3,T(k),K(k),fs,n0(i),0);
        [~,corr_rate] = conv_decode(output',L,g,0,input,0,0,0);
        ber_bit3(k,i) = 1-corr_rate;
        Eb3(k,i) = es/L;
    end
    semilogy(pow2db(Eb2(k,:)./n0), ber_bit2(k,:), 'Marker', '*', 'Linewidth', 1.5, 'LineStyle', '--');hold on;
    semilogy(pow2db(Eb3(k,:)./n0), ber_bit3(k,:), 'Marker', '*', 'Linewidth', 1.5, 'LineStyle', '-.');
end
grid on;
xlabel('Eb/n0(dB)');
ylabel('BER');
title('BER when K = 2.5');
legend('K = 2.5 T = 2 2-bit','K = 2.5 T = 2 3-bit',...
    'K = 2.5 T = 3 2-bit','K = 2.5 T = 3 3-bit',...
    'K = 2.5 T = 5 2-bit', 'K = 2.5 T = 5 3-bit',...
     'K = 2.5 T = 10 2-bit', 'K = 2.5 T = 10 3-bit');