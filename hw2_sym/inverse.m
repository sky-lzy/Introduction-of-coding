function out = inverse(in)
% Input: a 0-255 number
% Output: a 0-255 number, multiplicative inverse of Input in GF(2^8) = GF(2) [x]/(x8 + x4 + x3 + x + 1)

if(in==0 || in==1)
    out = in;
    return;
end

inb = dec2bin(in,8) - '0';
p = [1,0,0,0,1,1,0,1,1]; % 283
dividend = p;
divisor = inb;
q = zeros(8, 8);
r = zeros(8, 8);
x = zeros(10, 8);
x(2,:) = [0,0,0,0,0,0,0,1];
count = 0;
while(1) % r > 1
    count = count + 1;
    [q(count,:), r(count,:)] = div(dividend, divisor);
    x(count+2,:) = mod(x(count,:) - mul_vec(x(count+1,:),q(count,:)), 2);
    dividend = divisor;
    divisor = r(count,:);
    if(~any(divisor(1:7)) && divisor(8))
        break;
    end
end

% mul_vec(x(count+2,:), inb);
out = bin2dec(char(x(count+2,:) + '0'));

end