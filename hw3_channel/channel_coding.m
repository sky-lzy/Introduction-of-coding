function output_bits = channel_coding(input_bits, coding_mode, n, k, conv_constrain_length, conv_code_generator, conv_traceback, conv_decision)

    if (coding_mode == "hamming/encode")
        output_bits = encode(input_bits, n, k, 'hamming/binary'); 
    elseif (coding_mode == "hamming/decode")
        output_bits = decode(input_bits, n, k, 'hamming/binary'); 
    elseif (coding_mode == "cyclic/encode") 
        output_bits = encode(input_bits, n, k, 'cyclic/binary'); 
    elseif (coding_mode == "cyclic/decode") 
        output_bits = decode(input_bits, n, k, 'cyclic/binary'); 
    elseif (coding_mode == "repeat/encode") 
        output_bits = kron(input_bits, ones(1, n)); 
    elseif (coding_mode == "repeat/decode")
        output_bits = double(mean(reshape(input_bits, n, []), 1) > 0.5); 
    elseif (coding_mode == "conv/encode")
        output_bits = convenc(input_bits, poly2trellis(conv_constrain_length, conv_code_generator)); 
    elseif (coding_mode == "conv/decode")
        output_bits = vitdec(input_bits, poly2trellis(conv_constrain_length, conv_code_generator), conv_traceback, 'trunc', conv_decision); 
    else
        error('Coding mode can be set as "hamming/encode", "hamming/decode", "cyclic/encode", "cyclic/decode", "repeat/encode", "repeat/decode", "conv/encode", "conv/decode". '); 
    end
    

end