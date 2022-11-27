function ciphertext = aes_bl(message, key)
% Input: two 1x16 char vectors, the message to encrypt and the key
% Output: an 1x16 char vector, the ciphertext

% preparation
s_box = s_box_foward(); % s-box generation
pos = uint8([2,3,1,1;1,2,3,1;1,1,2,3;3,1,1,2]);

% subkey generation
if(length(key)==16)
    keys = subkey(key,s_box);
else
    keys = key;
end

% add key0
message = reshape(uint8(message),[4,4]);
c = bitxor(message, keys(:,1:4)); % ciphertext

% 10 rounds
for k = 1:10
    % substitute bytes
    for r = 1:16
        c(r) = s_box(uint16(c(r))+1);
    end
    % shift rows
    for r = 2:4
        c(r,:) = [c(r,r:4),c(r,1:r-1)];
    end
    % mix columns
    if(k~=10) % not the final round
        c = mul_matrix(pos, c);
    end
    % add round key
    c = bitxor(c, keys(:,4*k+1:4*k+4));
%     c
end

ciphertext = char(reshape(c, [1,16]));

end

function out = s_box_foward()
% Output: s-box for AES

out = zeros(1,256);
for k = 0:255
    b = inverse(k); % b = k ^ -1
    b = dec2bin(b, 8) - '0';
    s = [0,1,1,0,0,0,1,1];
    for l = 0:4
        s = xor(s, [b(1+l:end),b(1:l)]);
    end
    out(k+1) = bin2dec(char(s + '0'));
end
out = uint8(out);

end

function keys = subkey(key,s_box)
% Input: an 1x16 char vector of original key
% Output: a 40x4 char array of subkey

rc = [1,2,4,8,0x10,0x20,0x40,0x80,0x1B,0x36];
keys = zeros(44, 4);
keys(1:4,:) = reshape(uint8(key),[4,4])';
for k = 1:40
    if(mod(k-1,4) ~= 0)
        keys(4+k,:) = bitxor(keys(k,:),keys(3+k,:));
    else
        for l = 1:4
            keys(4+k,mod(l-2,4)+1) = s_box(uint16(keys(3+k,l))+1);
        end
        keys(4+k,1) = bitxor(keys(4+k,1),rc(round((k+3)/4))); % round constant
        keys(4+k,:) = bitxor(keys(k,:),keys(4+k,:));
    end
end
keys = uint8(keys');
end