function decoded_bits = decode8_3_4(raw_bits)
    % Input: an 1*n VECTOR to decode.
    % Output: an 1*m VECTOR decoded by (8,3,4) code.
    n_raw_bits = length(raw_bits); % 未解码比特数
    n_blocks = ceil(n_raw_bits / 8); % 解码块数
    padded_raw_bits = [raw_bits, zeros(1, 8 * n_blocks - n_raw_bits)]; % 末尾补零
    padded_raw_bits = transpose(reshape(padded_raw_bits, [8, n_blocks])); % 重排得到矩阵
    HH = [0,0,0,0,1; 1,1,0,1,0; 1,0,1,1,0; 1,0,0,0,0;
         0,1,1,1,0; 0,1,0,0,0; 0,0,1,0,0; 0,0,0,1,0]; % 用来检测的矩阵
    ss = mod(padded_raw_bits * HH, 2); % 计算校正子们
    err = find(any(ss, 2)); % 找出肯定出错的块序号
    codes = mod([0,0,0; 0,0,1; 0,1,0; 0,1,1; 1,0,0; 1,0,1; 1,1,0; 1,1,1] * [0,1,0,1,0,1,0,1; 0,0,1,1,0,0,1,1; 0,0,0,0,1,1,1,1], 2); % 许用码字集合
    for k = 1:length(err) % 纠错
        err_bit = find(~sum(abs(HH - mod(padded_raw_bits(err(k),:) * HH, 2)), 2)); % 先考虑纠一个错
        if (~isempty(err_bit)) % 如果只有一个错
            padded_raw_bits(err(k), err_bit) = 1 - padded_raw_bits(err(k), err_bit); % 纠错
        else % 如果错误更多
            weights = sum(abs(codes - padded_raw_bits(err(k),:)), 2);
            [minval, minidx] = min(weights); % 找出最近的码字
            padded_raw_bits(err(k),:) = codes(minidx,:); % 纠错
        end
    end
    decoded_bits = reshape(transpose(padded_raw_bits(:, [2, 3, 5])), [1, 3 * n_blocks]);
end