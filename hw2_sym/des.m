function ciphertext = des(message, key, CBC)
% Input: two uint8/char vector, message ot encrypt and key, and CBC or ECB
% Output: a char vector, the ciphertext

% default mode: CBC
if(~exist('CBC','var'))
    CBC = true;
end

% default key: V me 50!
if(~exist('key','var'))
    key = 'KFCCrazyThuVMe50';
end

% padding(Pkcs7)
Nblocks = fix(length(message)/16)+1; % block num
Npadding = 16 * Nblocks - length(message); % padding bytes num
m_padded = zeros(1, 16 * Nblocks);
m_padded(1:length(message)) = message;
m_padded(length(message)+1:end) = Npadding; % padding value == padding num
m_padded = char(m_padded); % padded char

% subkey generation
s_box = s_box_foward(); % s-box
keys = subkey(key,s_box);

% encryption
ciphertext = char(zeros(1, 16 * Nblocks));
for k = 1:Nblocks
    if(CBC && k>1) % xor last cipher block
        m_padded(16*k-15:16*k) = bitxor(uint8(m_padded(16*k-15:16*k)),uint8(ciphertext(16*k-31:16*k-16)));
    end
    ciphertext(16*k-15:16*k) = des_bl(m_padded(16*k-15:16*k),keys,s_box); % encrypt by block
end
ciphertext = char(ciphertext); % convert to char

end