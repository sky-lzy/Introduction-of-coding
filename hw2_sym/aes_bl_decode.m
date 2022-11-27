function message = aes_bl_decode(ciphertext, key)
% Input: two 1x16 char vectors, the message to encrypt and the key
% Output: an 1x16 char vector, the ciphertext

% preparation
s_box = s_box_foward(); % s-box generation
s_box_0 = s_box_inverse();
% pos = uint8([2,3,1,1;1,2,3,1;1,1,2,3;3,1,1,2]);
neg = uint8([0x0E,0x0B,0x0D,0x09;0x09,0x0E,0x0B,0x0D;0x0D,0x09,0x0E,0x0B;0x0B,0x0D,0x09,0x0E]);
% mul_matrix(pos,neg);

% subkey generation
if(length(key)==16)
    keys = subkey(key,s_box);
else
    keys = key;
end

ciphertext = reshape(uint8(ciphertext),[4,4]);
m = ciphertext;

% 10 rounds
for k = 10:-1:1
%     m
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

message = char(reshape(m, [1,16]));

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

function out = s_box_inverse()
% Output: s-box for AES

out = zeros(1,256);
for k = 0:255
    b = dec2bin(k, 8) - '0';
    s = [0,0,0,0,0,1,0,1];
    for l = [1,3,6]
        s = xor(s, [b(1+l:end),b(1:l)]);
    end
    out(k+1) = inverse(bin2dec(char(s + '0')));
end
out = uint8(out);

end

function keys = subkey(key,s_box)
% Input: an 1x16 char vector of original key
% Output: a 40x4 char array of subkey

rc = [1,2,4,8,0x10,0x20,0x40,0x80,0x1b,0x36];
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