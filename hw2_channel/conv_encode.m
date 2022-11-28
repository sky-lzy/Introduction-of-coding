function output_code = conv_encode(input_code, N_bits, crc, is_tail)
    % 二元1/2效率卷积码模块 
    % input_code输入序列，N_bits为2或3表示效率，crc为1时添加crc校验，sigma_n为噪声方差，is_tail为1时收尾。
    % 建议参数（15,17）-> oct2bin(15)=1101 oct2bin(17)=1111（2,1,4）码
    g21 = [1,1,0,1]; %生成多项式系数
    g22 = [1,1,1,1];
    g31 = [1,0,1,1]; 
    g32 = [1,1,0,1];
    g33 = [1,1,1,1];
    dtest = input_code;
    tail_flag = exist('is_tail', 'var') && (is_tail == true);
    tail = zeros(1,3);% 约束长度为4，如果要收尾则需要输入连续3个0清空编码器
    if(tail_flag)% 收尾
        dtest = [dtest,tail];
    end % 默认不收尾
    L = length(dtest);
    if(crc)
        % CRC编码，25bytes = 200bits一组
        if(tail_flag)
            dtest = dtest(1:L-3);% remove tail
            L = L-3;
        end
        packnum = ceil(L/200);
        dcrc = [];
        for k = 1:packnum
            pack = crc3(dtest(200*(k-1)+1:200*k));
            if(tail_flag)
                pack = [pack,tail];
            end
            dcrc = [dcrc,pack];
        end
        dtest = dcrc;       
    end
    L = length(dtest);
    if(N_bits == 2)
        x1 = mod(conv(g21,dtest),2);
        x2 = mod(conv(g22,dtest),2);
        d = reshape([x1;x2],[1,length(x1)+length(x2)]);% d为卷积码编码后得到的序列
        L = L*2;% 效率为1/2，编码后码长翻倍
        d = d(1:L); %对编码器中残留的部分进行截断
        output_code = d;
    elseif (N_bits == 3)
        x1 = mod(conv(g31,dtest),2);
        x2 = mod(conv(g32,dtest),2);
        x3 = mod(conv(g33,dtest),2);
        d = reshape([x1;x2;x3],[1,length(x1)+length(x2)+length(x3)]);% d为卷积码编码后不收尾得到的序列
        L = L*3;% 效率为1/3，编码后码长为三倍
        d = d(1:L); %对编码器中残留的部分进行截断
        output_code = d;
    end
end

