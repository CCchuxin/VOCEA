% function out = estBlockRateInd(hist_out, y_sub_image, repeat_height, repeat_width)
% %     y_sub_dct = reshape(y_sub_image, 8, 8)';
%     y_sub_dct = y_sub_image;
%     nbits = 0;
%     temp = log2(repeat_height*repeat_width);
%     for i = 1:1:8
%         for j = 1:1:8
%             value = y_sub_dct(i,j);
%             nelements = hist_out{i,j}{1,1};
%             ncenters = hist_out{i,j}{1,2};
%             index = value - ncenters(1) + 1;
%             nbits = nbits + (temp - log2(nelements(index)));
%         end
%     end
%     out = nbits;
% end

function out = estBlockRateInd(hist_out, repeat_height, repeat_width)
%     y_sub_dct = reshape(y_sub_image, 8, 8)';
    rate_out = zeros(8,8,255);
    temp = log2(repeat_height*repeat_width);
    for i = 1:1:8
        for j = 1:1:8
            nelements = hist_out{i,j}{1,1};
            ncenters = hist_out{i,j}{1,2};
            len = size(ncenters,2);
            
            for qpstep = 1:255
                rate = 0;
                nquant = round(ncenters/qpstep);
                for m = nquant(1):nquant(end)
                    
                    count = sum(nelements(nquant == m));
                    
                    if count ~= 0
                        bpp = temp - log2(count);
                        if bpp == 0
                            bpp = 3.0/64;
                        end
                        rate = rate + count*bpp;
                    end
                end
                rate_out(i,j,qpstep) = rate;
            end
        end
    end
    out = rate_out;
end