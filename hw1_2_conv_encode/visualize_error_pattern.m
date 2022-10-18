function visualize_error_pattern(snr,input_L)
% 输入参数分别为信噪比、测试序列长度
    
    h = figure();
    sgt = sgtitle('Error Pattern','Color','Red');
    sgt.FontSize = 20;
    set(sgt, 'FontName', 'Times New Roman');
    dtest = floor(rand(1,input_L)*2); %产生长为L个符号的{0,1}二元测试用待编码序列，长度为L  
    for i = 1:max(length(snr),10)
        visual_map = zeros(2,input_L,3);
        visual_map(:,:,1) = 0;
        visual_map(:,:,2) = 255;
        visual_map(:,:,3) = 0;
        sigma_n = sqrt(1/snr(i));
        v = conv_encode2(dtest,sigma_n);
        %scatterplot(v);
        decode = conv_decode2(v);
        visual_map(:,decode~=dtest,1) = 255;
        visual_map(:,decode~=dtest,2) = 0;
        subplot(5,2,i);
        display(decode~=dtest);
        imshow(visual_map)
    end
    
end