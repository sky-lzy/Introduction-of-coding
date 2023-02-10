function [bitnum,bits_huff] = huffman_joint(picture)
    count = zeros(max(max(picture)),max(max(picture)));
    for m = 1:size(picture,1)
        for n = 1:2:size(picture,2)
            count(picture(m,n),picture(m,n+1))  = count(picture(m,n),picture(m,n+1)) + 1;
        end
    end

    symbols = double([]);
    prob = [];
    for m = double(1:max(max(picture)))
        for n = double(1:max(max(picture)))
            if count(m,n) ~= 0
                symbols = [symbols,m*1000+n];
                prob = [prob,count(m,n)];
            end
        end
    end

    
    prob_norm = prob./sum(prob);
    prob_norm = [prob_norm,0];
    nodes = length(prob_norm);
    symbols = [symbols,-1];
    [dict,avglen] = huffmandict(symbols,prob_norm);
    s = size(picture);
    bitnum = s(1)*s(2)*avglen/2;
    
    bits_huff = [];
    for m = 1:s(1)
        for n = 1:2:s(2)
            bits_huff = [bits_huff,dict(symbols==picture(m,n)*1000+picture(m,n+1),2)];
        end
    end
    bits_huff = num2str(bits_huff);

    fid = fopen('table_joint.txt', 'wt');
    for m = 1:size(dict,1)-1
        fprintf(fid, '%d',floor(cell2mat(dict(m,1))/1000));
        fprintf(fid, ' ');
        fprintf(fid, '%d',mod(cell2mat(dict(m,1)),1000));
        fprintf(fid, ' ');
        fprintf(fid, '%s',strrep(num2str(cell2mat(dict(m,2))),' ',''));
        fprintf(fid, '\n');
    end
    fprintf(fid, '%s',strrep(num2str(cell2mat(dict(size(dict,1),2))),' ',''));
    fclose(fid);
end