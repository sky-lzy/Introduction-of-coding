function bitnum = maketable(prob,nodes)
    prob_norm = prob./sum(prob);
    prob_norm = [prob_norm,0];
    symbols = (0:nodes);
    [dict,avglen] = huffmandict(symbols,prob_norm);
    s = size(picture);
    bitnum = s(1)*s(2)*avglen;

    fid = fopen('table.txt', 'wt');
    for m = 1:size(mat1,1)
        fprintf(fid, '%d',cell2mat(dict(m,1)));
        fprintf(fid, ' ');
        fprintf(fid, '%s',strrep(num2str(cell2mat(dict(m,2))),' ',''));
        fprintf(fid, '\n');
    end
    fclose(fid);


end