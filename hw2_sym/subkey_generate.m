function keys = subkey_generate(key, s_box)
% Input: 192 bit of original key
% Output: 40x32 bit matrix of subkey

rc = [1,2,4,8,0x10,0x20,0x40,0x80,0x1b,0x36];
keys = zeros(44, 32);
keys(1:4,1:32) = reshape(key,[32,4])';
for k = 1:40
    if(mod(k-1,4) ~= 0)
        keys(4+k,:) = xor(keys(k,:),keys(3+k,:));
    else
        b = zeros(1,4);
        for l = 1:4
            b(l) = bin2dec(char(keys(3+k,8*l-7:8*l) + '0'));
            b(l) = s_box(b(l)+1); % substitute
            keys((4+k),(8*(mod(l-2,4)+1)-7):(8*(mod(l-2,4)+1))) = dec2bin(b(l),8) - '0'; % rotate
        end
        keys(4+k,1:8) = xor(keys(4+k,1:8),(dec2bin(rc(round((k+3)/4)),8) - '0')); % round constant
        keys(4+k,:) = xor(keys(k,:),keys(4+k,:));
    end
    
end

end