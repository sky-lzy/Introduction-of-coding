function visualize_error_snr(L)
    % L为序列长度 
    dtest = floor(rand(1,L)*2); %产生长为L个符号的{0,1}二元测试用待编码序列，长度为L
    N_dots = 20;
    SNRs = logspace(-2, 2, N_dots);
    error_rate2s = zeros(1,N_dots);
    error_rate2sc = [];
    real_error_rate = [];
    error_rate2sc_tail = [];
    real_error_rate_tail = [];
    error_rate3s = zeros(1,N_dots);
    error_rate_tail2s = zeros(1,N_dots);
    error_rate_tail3s = zeros(1,N_dots);
    error_rate2h = zeros(1,N_dots);
    error_rate3h = zeros(1,N_dots);
    error_rate_tail2h = zeros(1,N_dots);
    error_rate_tail3h = zeros(1,N_dots);
    g2 = [1,0,1,1;1,1,1,1];
    g3 = [1,1,0,1;1,0,1,1;1,1,1,1];
    % 不收尾
    for i = 1:N_dots
        SNR = SNRs(i);
        sigma_n = sqrt(1/SNR);
        
    % 软判别
        v2s = conv_encode(dtest,2,0,sigma_n);
        [decode2s,~] = conv_decode(v2s,L,g2,1,dtest,0,0,0);
        error_rate2s(i) = 1-sum(dtest==decode2s)/L;
        
        v3s = conv_encode(dtest,3,0,sigma_n);
        [decode3s,~] = conv_decode(v3s,L,g3,1,dtest,0,0,0);
        error_rate3s(i) = 1-sum(dtest==decode3s)/L;
        
        % 不收尾软判别crc
        v2sc = conv_encode(dtest,2,1,sigma_n);
        g = [1,0,1,1;1,1,1,1];
        [decode,errsc] = conv_decode(v2sc,L+3*L/200,g,1,dtest,1,203,L/200);
        error_rate2sc = [error_rate2sc,1-errsc];
        real_errnum = 0;
        for j= 1:L/200% 实际误块率
           decode_block = decode(203*(j-1)+1:203*j-3);
           block = dtest(200*(j-1)+1:200*j);
           if(sum(block==decode_block)~=200)
               real_errnum = real_errnum+1;
           end
        end
        real_error_rate = [real_error_rate,real_errnum/(L/200)];
        
        
    % 硬判别
        v2h = conv_encode(dtest,2,0,sigma_n);
        [decode2h,~] = conv_decode(v2h',L,g2,0,dtest,0,0,0);
        error_rate2h(i) = 1-sum(dtest==decode2h)/L;
        
        v3h = conv_encode(dtest,3,0,sigma_n);
        [decode3h,~] = conv_decode(v3h',L,g3,0,dtest,0,0,0);
        error_rate3h(i) = 1-sum(dtest==decode3h)/L;
        
        
    end
    % 收尾
    for i = 1:N_dots
        SNR = SNRs(i);
        sigma_n = sqrt(1/SNR);
    % 软判别
        v2s = conv_encode(dtest,2,0,sigma_n,true);
        dtest_tail = [dtest,zeros(1,3)];
        [decode2s,~] = conv_decode(v2s,L+3,g2,1,dtest_tail,0,0,0);
        error_rate_tail2s(i) = 1-(sum(dtest_tail==decode2s)/(L+3));
        
        v3s = conv_encode(dtest,3,0,sigma_n,true);
        dtest_tail = [dtest,zeros(1,3)];
        [decode3s,~] = conv_decode(v3s,L+3,g3,1,dtest_tail,0,0,0);
        error_rate_tail3s(i) = 1-(sum(dtest_tail==decode3s)/(L+3));
        
    % 收尾软判别crc
        v2sc = conv_encode(dtest,2,1,sigma_n,true);
        g = [1,0,1,1;1,1,1,1];
        [decode,errsc] = conv_decode(v2sc,L+6*L/200,g,1,dtest,1,206,L/200);
        error_rate2sc_tail = [error_rate2sc_tail,1-errsc];
        real_errnum = 0;
        for j= 1:L/200% 实际误块率
           decode_block = decode(206*(j-1)+1:206*j-6);
           block = dtest(200*(j-1)+1:200*j);
           if(sum(block==decode_block)~=200)
               real_errnum = real_errnum+1;
           end
        end
        real_error_rate_tail = [real_error_rate_tail,real_errnum/(L/200)];
        
    % 硬判别
        v2h = conv_encode(dtest,2,0,sigma_n,true);
        dtest_tail = [dtest,zeros(1,3)];
        [decode2h,~] = conv_decode(v2h',L+3,g2,0,dtest_tail,0,0,0);
        error_rate_tail2h(i) = 1-(sum(dtest_tail==decode2h)/(L+3));
        
        v3h = conv_encode(dtest,3,0,sigma_n,true);
        dtest_tail = [dtest,zeros(1,3)];
        [decode3h,~] = conv_decode(v3h',L+3,g3,0,dtest_tail,0,0,0);
        error_rate_tail3h(i) = 1-(sum(dtest_tail==decode3h)/(L+3));
    end
    figure();
    semilogy(pow2db(SNRs), error_rate2h(1,:), 'Marker', '*', 'Linewidth', 2);hold on;grid on;
    semilogy(pow2db(SNRs), error_rate_tail2h(1,:), 'Marker', 'o', 'Linewidth', 2);
    semilogy(pow2db(SNRs), error_rate3h(1,:), 'Marker', '+', 'Linewidth', 2);
    semilogy(pow2db(SNRs), error_rate_tail3h(1,:), 'Marker', '.', 'Linewidth', 2);
    legend("1/2non-ending","1/2ending","1/3non-ending","1/3ending");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Rate - SNR in CC', 'FontWeight', 'bold');

    figure(); 
    semilogy(pow2db(SNRs), error_rate2h, 'Marker', '*', 'Linewidth', 2);hold on;grid on;
    semilogy(pow2db(SNRs), error_rate2s, 'Marker', 'o', 'Linewidth', 2);
    semilogy(pow2db(SNRs), error_rate3h, 'Marker', '+', 'Linewidth', 2);
    semilogy(pow2db(SNRs), error_rate3s, 'Marker', '.', 'Linewidth', 2);
    legend("1/2hard","1/2soft","1/3hard","1/3soft");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Rate - SNR in CC', 'FontWeight', 'bold');

    figure(); 
    semilogy(pow2db(SNRs), real_error_rate, 'Marker', 'o', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), error_rate2sc, 'Marker', '*', 'Linewidth', 2);
    legend("real error block rate", "error block rate of crc");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Block Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Block Rate - SNR in CC', 'FontWeight', 'bold');
    
    figure(); 
    semilogy(pow2db(SNRs), real_error_rate_tail, 'Marker', 'o', 'Linewidth', 2);hold on; grid on;
    semilogy(pow2db(SNRs), error_rate2sc_tail, 'Marker', '*', 'Linewidth', 2);
    legend("real error block rate(tailed)", "error block rate of crc(tailed)");
    xlabel('SNR of Complex Sampling Channel (dB)');
    ylabel('Error Block Rate');
    set(gca, 'FontName', 'Times New Roman');
    title('Error Block Rate - SNR in CC', 'FontWeight', 'bold');
end



