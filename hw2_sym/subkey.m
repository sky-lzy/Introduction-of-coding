function keys = subkey(key,s_box)
% Input: an 1x16 uint8/char vector of original key, and s-box
% Output: a 40x4 uint8 array of subkey

rc = [1,2,4,8,0x10,0x20,0x40,0x80,0x1B,0x36]; % round constant
keys = zeros(44, 4);
keys(1:4,:) = reshape(uint8(key),[4,4])'; % original key
for k = 1:40
    if(mod(k-1,4) ~= 0) % simple case
        keys(4+k,:) = bitxor(keys(k,:),keys(3+k,:));
    else
        for l = 1:4
            keys(4+k,mod(l-2,4)+1) = s_box(uint16(keys(3+k,l))+1); % substitute and shift
        end
        keys(4+k,1) = bitxor(keys(4+k,1),rc(round((k+3)/4))); % xor round constant
        keys(4+k,:) = bitxor(keys(k,:),keys(4+k,:));
    end
end
keys = uint8(keys'); % adjust format

end