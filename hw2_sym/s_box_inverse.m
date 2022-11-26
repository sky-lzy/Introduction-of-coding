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

end