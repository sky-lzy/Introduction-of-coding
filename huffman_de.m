function decode = huffman_de(bits_huff,dict)
    decode = [];
    len = length(dict);
    while isempty(bits_huff) == 0
        for m = 1:len-1
            if bits_huff(1,length(dict(m,2))) == dict(m,2)
                decode = [decode,dict(m,1)];
                bits_huff = bits_huff(length(dict(m,2))+1:end);
            else
                decode = [decode,0];
                bits_huff = bits_huff(length(dict(len,2))+1:end);
            end
        end
    end
end

