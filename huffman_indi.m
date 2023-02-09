function [bitnum,bits_huff] = huffman_indi(picture)

    count = zeros(1,max(max(picture)));
    for m = 1:size(picture,1)
        for n = 1:size(picture,2)
            count(picture(m,n))  = count(picture(m,n)) + 1;
        end
    end

    symbols = [];
    prob = [];
    for m = 1:max(max(picture))
        if count(m) ~= 0
            symbols = [symbols,m];
            prob = [prob,count(m)];
        end
    end

    prob_norm = prob./sum(prob);
    prob_norm = [prob_norm,0];
    nodes = length(prob_norm);
    symbols = [symbols,-1];
    [dict,avglen] = huffmandict(symbols,prob_norm);
    s = size(picture);
    bitnum = s(1)*s(2)*avglen;
    
    bits_huff = [];
    for m = 1:s(1)
        for n = 1:s(2)
            bits_huff = [bits_huff,dict(picture(m,n),2)];
        end
    end
    bits_huff = num2str(bits_huff);

    fid = fopen('table.txt', 'wt');
    for m = 1:size(dict,1)-1
        fprintf(fid, '%d',cell2mat(dict(m,1)));
        fprintf(fid, ' ');
        fprintf(fid, '%s',strrep(num2str(cell2mat(dict(m,2))),' ',''));
        fprintf(fid, '\n');
    end
    fprintf(fid, '%s',strrep(num2str(cell2mat(dict(size(dict,1),2))),' ',''));
    fclose(fid);
end