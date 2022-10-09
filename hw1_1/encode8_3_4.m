function encoded_bits = encode8_3_4(raw_bits)
    % Input: an 1*n VECTOR of bits to encode.
    % Output: an 1*m VECTOR of bits encoded by (8,3,4) code.
    n_raw_bits = length(raw_bits); % 未编码比特数
    n_blocks = ceil(n_raw_bits / 3); % 编码块数
    padded_raw_bits = [raw_bits, zeros(1, 3 * n_blocks - n_raw_bits)]; % 末尾补零
    padded_raw_bits = transpose(reshape(padded_raw_bits, [3, n_blocks])); % 重排得到矩阵
    G = [0,1,0,1,0,1,0,1; 0,0,1,1,0,0,1,1; 0,0,0,0,1,1,1,1]; % 生成矩阵
    encoded_bits = reshape(transpose(mod(padded_raw_bits * G, 2)), [1, 8 * n_blocks]); % 编码结果
end