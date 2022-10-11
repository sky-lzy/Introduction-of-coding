function visualize_error_snr(L)
% L为序列长度 
dtest = floor(rand(1,L)*2); %产生长为L个符号的{0,1}二元测试用待编码序列，长度为L
N_dots = 30;
SNRs = logspace(-1, 2, N_dots);
error_rate = zeros(1,N_dots);
error_rate_tail = zeros(1,N_dots);
% 不收尾
for i = 1:N_dots
    SNR = SNRs(i);
    sigma_n = sqrt(1/SNR);
    v = conv_encode2(dtest,sigma_n,0);
    %scatterplot(v);
    decode = conv_decode2(v);
    error_rate(i) = 1-sum(dtest==decode)/L;
end
% 收尾
for i = 1:N_dots
    SNR = SNRs(i);
    sigma_n = sqrt(1/SNR);
    v = conv_encode2(dtest,sigma_n,0,true);
    %scatterplot(v);
    decode = conv_decode2(v);
    dtest_tail = [dtest,zeros(1,3)];
    error_rate_tail(i) = 1-(sum(dtest_tail==decode)/(L+3));
end
figure(); hold on; box on; grid on;
plot(pow2db(SNRs), error_rate, 'Marker', '*', 'Linewidth', 2);
plot(pow2db(SNRs), error_rate_tail, 'Marker', 'o', 'Linewidth', 2);
legend("non-ending","ending");
xlabel('SNR of Complex Sampling Channel (dB)');
ylabel('Error Rate');
set(gca, 'FontName', 'Times New Roman');
title('Error Rate - SNR in 1/2CC', 'FontWeight', 'bold');



