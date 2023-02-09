symbols = 10:20:250;
prob = zeros(size(symbols));
prob = prob+1/length(symbols);
dict1 = huffmandict(symbols,prob);

symbols = 1:6;
prob = zeros(size(symbols));
prob = prob+1/length(symbols);
dict2 = huffmandict(symbols,prob);