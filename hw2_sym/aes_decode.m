function message = aes_decode(ciphertext, key)
% Input: a char vector, the ciphertext
% Output: a char vector, the message


% subkey generation
s_box = s_box_foward();
keys = subkey(key,s_box);

Nblocks  = length(ciphertext) / 16;
message = zeros(size(ciphertext));
for k = 1:Nblocks
    message(16*k-15:16*k) = aes_bl_decode(ciphertext(16*k-15:16*k),keys);
end
% message = uint8(message);
Npadding = uint8(message(end));
message = char(message(1:end-Npadding));

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