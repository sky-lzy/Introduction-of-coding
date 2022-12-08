function message = aes_bl_decode(ciphertext, key, s_box_0)
% Input: two 1x16 uint8/char vectors, the message to encrypt and the key
% Output: an 1x16 char vector, the ciphertext

% preparation
if(~exist('s_box_0','var'))
    s_box_0 = s_box_inverse(); % inverse s-box generation
end
neg = uint8([0x0E,0x0B,0x0D,0x09;0x09,0x0E,0x0B,0x0D;0x0D,0x09,0x0E,0x0B;0x0B,0x0D,0x09,0x0E]); % for inverse MixColumns

% subkey generation
if(length(key)==16) % if need to generate subkey
    keys = subkey(key);
else
    keys = key;
end

ciphertext = reshape(uint8(ciphertext),[4,4]);
m = ciphertext; % message

% 10 rounds
for k = 10:-1:1
    % add round key
    m = bitxor(m, keys(:,4*k+1:4*k+4));
    % inverse mix columns
    if(k~=10) % not the final round
        m = mul_matrix(neg, m);
    end
    % inverse shift rows
    for r = 2:4
        m(r,:) = [m(r,6-r:4),m(r,1:5-r)];
    end
    % inverse substitute bytes
    for r = 1:16
        m(r) = s_box_0(uint16(m(r))+1);
    end
end

% add key0
m = bitxor(m,keys(:,1:4));

message = char(reshape(m, [1,16])); % convert to char

end