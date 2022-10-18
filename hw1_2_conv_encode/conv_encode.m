function output_v = conv_encode(input_code, N_bits, crc, sigma_n, is_tail)
    % 二元1/2效率卷积码模块 
    % input_code
    % 输入序列，N_bits为2或3表示效率，crc为1时添加crc校验，sigma_n为噪声方差，is_tail为1时收尾。
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
        output_v = digital_channel(output_code,1,5,0,0,sigma_n);
    elseif (N_bits == 3)
        x1 = mod(conv(g31,dtest),2);
        x2 = mod(conv(g32,dtest),2);
        x3 = mod(conv(g33,dtest),2);
        d = reshape([x1;x2;x3],[1,length(x1)+length(x2)+length(x3)]);% d为卷积码编码后不收尾得到的序列
        L = L*3;% 效率为1/3，编码后码长为三倍
        d = d(1:L); %对编码器中残留的部分进行截断
        output_code = d;
        output_v = digital_channel(output_code,1,5,0,0,sigma_n);
    end
end

function v = digital_channel(input_bits, N_bits, T, b, rou, sigma_n, Send_acquire_beta, Recv_acquire_beta)
    send_flag = exist('Send_acquire_beta', 'var') && (Send_acquire_beta == true);
    recv_flag = exist('Recv_acquire_beta', 'var') && (Recv_acquire_beta == true);

    % encode: N_bits-bit for every signal
    M = 2^N_bits;
    len_encode = length(input_bits)/N_bits;
    encode_bits = zeros(1, len_encode);
    for iter = 1:len_encode
        encode_bits(iter) = bin2dec(num2str(input_bits(N_bits*(iter-1)+1:N_bits*iter)));
    end
    
    % generate channel
    a = generate_channel(len_encode*T, b, rou);
    % avg_a = zeros(1, len_encode);
    % for iter_t = 1:T
    %     avg_a = mean(a(T*(iter_t-1)+1:T*iter_t));
    % end

    % signal processing
    u = pskmod(encode_bits, M);
    % if (send_flag)
    %     u = u .* exp(-1j*angle(avg_a));
    % end
    v = complex_elec_channel(u, T, a, sigma_n, send_flag, ~send_flag&&recv_flag);
end
    
function y = complex_sample_channel(x, a, sigma_n)

    N = length(x);
    noise = (randn(1, N) + 1j*randn(1, N)) * sigma_n / sqrt(2);
    y = a.*x + noise;

end

function v = complex_elec_channel(u, T, a, sigma_n, flag_send, flag_recv)

    L = length(u);
    v = zeros(1, L);

    for iter_l = 1:L
        x = 1/sqrt(T)*u(iter_l)*ones(1, T);
        if (flag_send)
            x = x .* exp(-1j*angle(a(T*(iter_l-1)+1:T*iter_l)));
        end
        y = complex_sample_channel(x, a(T*(iter_l-1)+1:T*iter_l), sigma_n);
        if (flag_recv)
            y = y .* exp(-1j*angle(a(T*(iter_l-1)+1:T*iter_l)));
        end
        v(iter_l) = 1/sqrt(T)*sum(y);
    end

end

function a = generate_channel(N, b, rou)

    betas = zeros(1, N);
    betas(1) = (randn() + 1j*randn()) / sqrt(2);
    for iter_n = 2:N
        z_n = (randn() + 1j*randn()) / sqrt(2);
        betas(iter_n) = rou*betas(iter_n-1) + sqrt(1-rou^2)*z_n;
    end

    a = sqrt(1-b^2) + b*betas;

end

