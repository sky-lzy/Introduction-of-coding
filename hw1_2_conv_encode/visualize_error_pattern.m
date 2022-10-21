function visualize_error_pattern(snr,input_L,is_tail)
% 输入参数分别为信噪比、测试序列长度
    if(is_tail)
        h = figure();
        sgt = sgtitle('Error Pattern','Color','Red');
        sgt.FontSize = 20;
        set(sgt, 'FontName', 'Times New Roman');
        dtest = floor(rand(1,input_L)*2); %产生长为L个符号的{0,1}二元测试用待编码序列，长度为L  
        for i = 1:max(length(snr),10)
            visual_map = zeros(2,input_L+3,3);
            visual_map(:,:,1) = 0;
            visual_map(:,:,2) = 255;
            visual_map(:,:,3) = 0;
            sigma_n = sqrt(1/snr(i));
            v = conv_encode(dtest,2,0,sigma_n,true);
            dtest_tail = [dtest,zeros(1,3)];
            L = length(dtest);
            g2 = [1,0,1,1;1,1,1,1];
            g3 = [1,1,0,1;1,0,1,1;1,1,1,1];
            [decode,~] = conv_decode(v,L+3,g2,1,dtest_tail,0,0,0);
            visual_map(:,decode~=dtest_tail,1) = 255;
            visual_map(:,decode~=dtest_tail,2) = 0;
            subplot(5,2,i);
            imshow(visual_map);
        end
    else
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
            v = conv_encode(dtest,2,0,sigma_n);
            L = length(dtest);
            g2 = [1,0,1,1;1,1,1,1];
            g3 = [1,1,0,1;1,0,1,1;1,1,1,1];
            [decode,~] = conv_decode(v,L,g2,1,0,0,0);
            visual_map(:,decode~=dtest,1) = 255;
            visual_map(:,decode~=dtest,2) = 0;
            subplot(5,2,i);
            imshow(visual_map);
        end
    end
end