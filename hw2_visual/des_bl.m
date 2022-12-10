function ciphertext = des_bl(message, key, s_box)
% Input: two 1x16 uint8/char vectors, the message to encrypt and the key
% Output: an 1x16 char vector, the ciphertext
% D stands for DIFFERENTIAL

% preparation
if(~exist('s_box','var'))
    s_box = s_box_foward(); % s-box generation
end
pos = uint8([2,3,1,1;1,2,3,1;1,1,2,3;3,1,1,2]); % matrix for MixColumns

% subkey generation
if(length(key)==16) % if need to generate subkey
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
    % D with round key
    c = D(c, keys(:,4*k+1:4*k+4));
end

ciphertext = char(reshape(c, [1,16])); % convert to char

end

function y = D(x, key)
% Input: two 4x4 uint8 array
% Output: a 4x4 uint8 array

xp = uint8(zeros(1,23));
xp(8:23) = uint8(reshape(x,[1,16]));
yp = uint8(zeros(1,23));
key = reshape(key,[2,8]);
key(key==0) = uint8(max(key,[],'all')) + 1;
key_1 = inverse(key(1,1));

for k = 8:23
    for r = 1:8
        yp(k) = bitxor(yp(k), mul(key(2,r), xp(k-r+1)));
    end
    for r = 2:8
        yp(k) = bitxor(yp(k), mul(key(1,r), yp(k-r+1)));
    end
    yp(k) = mul(key_1,yp(k));
end
y = reshape(uint8(yp(8:23)),[4,4]);

end