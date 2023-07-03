function outData = chrom_jpeg_encoder_func (cb_sub_image, cb_sub_dct, repeat_height, repeat_width, ~, chroMat, fast_mode, mse_table, rate_table)
    fid = 0;
%     rate_block = zeros(repeat_height, repeat_width);
%     cb_bits = 0;
%     cb_rate_block_est = zeros(repeat_height, repeat_width);
    cb_sub_image_iq =  cb_sub_image;
    rate_block =  cb_sub_image;
%     mse = 0.0;
%     mse_est = 0.0;
%     rate_est = 0;
    if fast_mode ~= 1
        lastDC(1) = 0;
        lastDC(2) = 0;
        lastDC(3) = 0;
        for i=1:repeat_height
            for j=1:repeat_width
                
                cb_sub_image{i, j} = quantize(cb_sub_image{i, j}, 'chrom');
                cb_sub_image_iq{i, j} = iquantize(cb_sub_image{i, j},'chrom');
                [lastDC(1), cb_bits] = huffman(fid, cb_sub_image{i, j}, lastDC(2), 2, 2);
                rate_block{i,j} =  cb_bits;
%                 rate_block(i,j) = rate_block(i,j) + cb_bits;
%                 
%                 dct = cb_sub_dct{i, j};
%                 idct =  cb_sub_image_iq{i, j};
%                 mse = mse + sum(sum(((dct - idct ).^2)));
            end
        end
        cb_dct_img = zeros(8*repeat_height, 8*repeat_width);
        cb_idct_img = zeros(8*repeat_height, 8*repeat_width);
        cb_rate_block = zeros(8*repeat_height, 8*repeat_width);
        for i = 1:repeat_height
            for j = 1:repeat_width
    %             y_compressed_img(((i-1)*8+1):(i*8), ((j-1)*8+1):(j*8)) = (reshape(y_sub_dct{i,j},8,8))';
                    cb_dct_img(((i-1)*8+1):(i*8), ((j-1)*8+1):(j*8)) = cb_sub_dct{i,j};
                    cb_idct_img(((i-1)*8+1):(i*8), ((j-1)*8+1):(j*8)) = cb_sub_image_iq{i, j};
                    cb_rate_block(((i-1)*8+1):(i*8), ((j-1)*8+1):(j*8)) = rate_block{i, j};
            end
        end
%     y_dct_img = round(y_compressed_img);
        for i = 1:1:8
            for j = 1:1:8
                cb_dct{i,j}=cb_dct_img(i:8:(8*repeat_height),j:8:(8*repeat_width));
                cb_idct{i,j}=cb_idct_img(i:8:(8*repeat_height),j:8:(8*repeat_width));
                dct = cb_sub_dct{i, j};
                idct = cb_sub_image_iq{i, j};
                cb_mse(i,j) = sum(sum(((dct - idct ).^2)));
                cb_rate{i,j}=cb_rate_block(i:8:(8*repeat_height),j:8:(8*repeat_width));
                rate(i,j) = sum(sum(cb_rate{i,j}));
            end
        end
        
         outData = [cb_mse,rate];
%          real=reshape(rate_block,repeat_height*repeat_width,1);
%         dlmwrite('real_rate.txt',real);
    else
%         mse_est = 0;
%         rate_est = 0;
        mse_est = zeros(8,8);
        rate_est = zeros(8,8);
        chroMat2 = reshape(chroMat, 8, 8)';
%         for i = 1:8
%             for j = 1:8
%                 mse_est =mse_est + mse_table(i,j, lumMat2(i,j));
%                 rate_est = rate_est + rate_table(i,j, lumMat2(i,j));
%             end
%         end  
        for i = 1:8
            for j = 1:8
                mse_est(i,j) = mse_table(i,j, chroMat2(i,j))/(repeat_width*repeat_height);
                rate_est(i,j)= rate_table(i,j, chroMat2(i,j))/(repeat_width*repeat_height);
            end
        end  

        outData = [ mse_est ,rate_est];
    end
end
%          real=reshape(rate_block,repeat_height*repeat_width,1);
% %         dlmwrite('real_rate.txt',real);
%     else
%         mse_est = 0;
%         rate_est = 0;
%         chroMat2 = reshape(chroMat, 8, 8)';
%         for i = 1:8
%             for j = 1:8
%                 mse_est =mse_est + mse_table(i,j, chroMat2(i,j));
%                 rate_est = rate_est + rate_table(i,j, chroMat2(i,j));
%             end
%         end  
%     end
%     
%     outData = [mse,sum(sum(rate_block)), mse_est,rate_est];
% end
%     