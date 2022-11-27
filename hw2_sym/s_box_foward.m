function out = s_box_foward()
% Output: 1x256 uint8 array, s-box for AES

out = zeros(1,256);
for k = 0:255
    b = inverse(k); % b = k ^ -1
    b = dec2bin(b, 8) - '0'; % bit operation
    s = [0,1,1,0,0,0,1,1]; % constant
    for l = 0:4
        s = xor(s, [b(1+l:end),b(1:l)]); % shift and xor
    end
    out(k+1) = bin2dec(char(s + '0'));
end
out = uint8(out);

end