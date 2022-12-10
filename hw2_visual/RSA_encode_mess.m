function out_mess = RSA_encode_mess(input_mess, pub_key, mod_n, mode)

    sub_len = floor(log2(mod_n)); 
    out_len = sub_len; 
    if (mode) % decode
        sub_len = sub_len + 1; 
    else % encode
        out_len = out_len + 1; 
    end

    mess_len = length(input_mess); 
    sub_number = ceil(mess_len / sub_len); 
    out_mess = zeros(1, sub_number*out_len); 

    for iter_sub = 1:sub_number-1 
        temp_mess = input_mess(iter_sub*sub_len-sub_len+1:iter_sub*sub_len); 
        temp_mess = bin2dec(num2str(temp_mess)); 
        temp_encode = RSA_encode(pub_key, mod_n, 1, temp_mess); 
        out_mess(iter_sub*out_len-out_len+1:iter_sub*out_len) = dec2bin(temp_encode, out_len) - '0'; 
    end
    
    temp_mess = input_mess(sub_number*sub_len-sub_len+1:end); 
    if ~mode
        temp_mess = [temp_mess, zeros(1, sub_len - length(temp_mess))]; 
    end
    temp_mess = bin2dec(num2str(temp_mess)); 
    temp_encode = RSA_encode(pub_key, mod_n, 1, temp_mess); 
    out_mess(sub_number*out_len-out_len+1:end) = dec2bin(temp_encode, out_len) - '0'; 

end