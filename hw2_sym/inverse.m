function out = inverse(in)
% Input: a 0-255 number
% Output: a 0-255 number, multiplicative inverse of Input in GF(2^8) = GF(2) [x]/(x8 + x4 + x3 + x + 1)

in = uint8(in);
% special cases
if(in==0 || in==1)
    out = in;
    return;
end

inb = dec2bin(in,8) - '0';
p = [1,0,0,0,1,1,0,1,1]; % 283
% initialize
dividend = p;
divisor = inb;
q = zeros(8, 8);
r = zeros(8, 8);
x = zeros(10, 8);
x(2,:) = [0,0,0,0,0,0,0,1];
count = 0;
% Euclidean algorithm
while(1) % r > 1
    count = count + 1;
    [q(count,:), r(count,:)] = div(dividend, divisor);
    x(count+2,:) = mod(x(count,:) - mul_vec(x(count+1,:),q(count,:)), 2);
    dividend = divisor;
    divisor = r(count,:);
    if(~any(divisor(1:7)) && divisor(8)) % reaches 1
        break;
    end
end

out = bin2dec(char(x(count+2,:) + '0'));

end

function out = mul_vec(in1, in2)
% Input: two 8-bit vector
% Output: a 8-bit vector, the product

inb1 = zeros(1,8);
inb1(end-length(in1)+1:end) = in1;
inb2 = zeros(1,8);
inb2(end-length(in2)+1:end) = in2;

p = [1,0,0,0,1,1,0,1,1]; % 283
out = boolean(mod(conv(inb1, inb2),2));
for k = 1:7
    if(out(k))
        out(k:k+8) = xor(out(k:k+8), p);
    end
end
out = out(8:15); % adjust format
end