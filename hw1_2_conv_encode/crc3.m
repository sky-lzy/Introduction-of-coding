% 使用CRC-3标准,即每个数据块的最后三个比特为校验位。
% 输入为长度为L的原始数据行向量，输出为添加了校验位后的数据
function out = crc3(in)
    g = [1,1,0,1];% 生成多项式为x^3+x^2+1
    lg = 3;% 生成多项式最高次为3
    % 若最高位能除，则一定为1，剩余位进行模2和操作,所以在最高位已知的前提下可以转换为异或操作
    i = 1;% i用来保存长除循环中被除数所对应原序列的位置
    in_exp = [in,zeros(1,lg)];% 输入多项式末lg位补0
    numerator = in_exp(i:i+lg);% 初始化被除数为输入序列前4位
    % 长除操作
    while(i<length(in))
        if(numerator(1) == 1)% 如果首位为1，则能除
            result = xor(numerator,g);
            i = i+1;
            numerator = [result(2:lg+1),in_exp(i+lg)];% 将结果首位（0）去掉，末位补上输入序列的对应符号
        else
            i = i+1;
            numerator = [numerator(2:lg+1),in_exp(i+lg)];% 首位为0，不能除。将首位（0）去掉，末位补上输入序列的对应符号
        end
    end
    % 求出余式t
    if(numerator(1)==1)
        t = mod(-xor(numerator,g),2);
        t = t(2:lg+1);
    else
        t = numerator(2:lg+1);
    end
    out = [in,t];% 将CRC校验位放在末尾输出
end