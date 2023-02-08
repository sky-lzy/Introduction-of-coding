function [bitnum,bits_huff] = huffman_indi(prob,nodes,picture)
    prob_norm = prob./sum(prob);
    prob_norm = [prob_norm,0];
    symbols = (0:nodes);
    [dict,avglen] = huffmandict(symbols,prob_norm);
    s = size(picture);
    bitnum = s(1)*s(2)*avglen;
    
    bits_huff = [];
    for m = 1:s(1)
        for n = 1:s(2)
            if picture(m,n) < nodes
                bits_huff = [bits_huff,dict(picture(m,n),2)];
            else
                bits_huff = [bits_huff,dict(nodes+1,2)];
            end
        end
    end
    bits_huff = num2str(bits_huff);
end