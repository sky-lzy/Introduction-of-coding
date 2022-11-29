clear; close all; clc; 

prime_size = 10; 
mess_len = 100; 
output = RSA_generate(prime_size); 
pub_key = output(1); 
pri_key = output(2); 
N_mod = output(3); 

message = randi([2, N_mod - 1], 1, mess_len); 
mess_encode = RSA_encode(pub_key, N_mod, mess_len, message); 
mess_decode = RSA_encode(pri_key, N_mod, mess_len, mess_encode); 
