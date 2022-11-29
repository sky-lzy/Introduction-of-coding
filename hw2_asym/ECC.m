clear; close all; clc; 

ECC_parameters = ECC_generate(); 
p = ECC_parameters(1); 
n = ECC_parameters(2); 
a = ECC_parameters(3); 
b = ECC_parameters(4); 
pri_key = ECC_parameters(5); 
base_point = [ECC_parameters(6), ECC_parameters(7)]; 
pub_key = [ECC_parameters(8), ECC_parameters(9)]; 

mess_len = 100; 
mess = randi([1, n-1], 1, mess_len); 

[C1, C2] = ECC_encode(p, a, b, base_point(1), base_point(2), pub_key(1), pub_key(2), mess_len, mess); 
mess_decode = ECC_decode(p, a, b, pri_key, mess_len, C1, C2); 
