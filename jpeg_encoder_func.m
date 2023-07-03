function outData = jpeg_encoder_func (y_image, y_sub_image, y_sub_dct, repeat_height, repeat_width, ~, lumMat, fast_mode, dss_table,w, rate_table)
    fid = 0;
%       mse_est = zeros(8,8);
%         rate_est = zeros(8,8);
   rate_block = zeros(repeat_height, repeat_width);
%     y_bits = 0;
%     rate_block_est = zeros(repeat_height, repeat_width);
%     y_sub_image_iq =  y_sub_image;
%     rate_block =  y_sub_image;
%     mse = 0.0;
%     mse_est = 0.0;
%     rate_est = 0;
    if fast_mode ~= 1
        lastDC(1) = 0;
        lastDC(2) = 0;
        lastDC(3) = 0;
        for i=1:repeat_height
            for j=1:repeat_width 
                y_sub_image{i, j} = quantize(y_sub_image{i, j}, 'lum');
                [lastDC(1), y_bits] = huffman(fid, y_sub_image{i, j}, lastDC(1), 1, 1);
                rate_block(i,j) = rate_block(i,j) + y_bits;
            end
        end
        
  
        
        dss = zeros(8,8);
        lumMat2 = reshape(lumMat, 8, 8)';
        for i = 1:8
            for j = 1:8
%                 mse_est(i,j) = mse_table(i,j, lumMat2(i,j))/(repeat_width*repeat_height);
%                 rate_est(i,j)= rate_table(i,j, lumMat2(i,j))/(repeat_width*repeat_height);
                
                dss(i,j) = dss_table(i,j, lumMat2(i,j));
            end
        end  
       dss_real = 1/sum(sum(dss .* (w/sum(w(:)))));
%           dss = realBlockDss(y_dct_img_iq,y_sub_dct_img,1.55, [1000 300],repeat_height, repeat_width);
%         dss = realBlockDss(y_dct_img_iq,y_image,1.55, [1000 300],repeat_height, repeat_width);
%         dss_new = 1/dss_index(y_dct_img_iq,y_image);
          % %     y_dct_img = round(y_compressed_img);
%         for i = 1:1:8
%             for j = 1:1:8
%                 y_dct{i,j}=y_dct_img(i:8:(8*repeat_height),j:8:(8*repeat_width));
% %                 y_idct{i,j}=y_idct_img(i:8:(8*repeat_height),j:8:(8*repeat_width));
%                 dct = y_sub_dct{i, j};
% %                 idct =  y_sub_image_iq{i, j};
%               
% %                 y_mse(i,j) = sum(sum(((dct - idct ).^2)));
% %                 y_rate{i,j}=y_rate_block(i:8:(8*repeat_height),j:8:(8*repeat_width));
% %                 rate(i,j) = sum(sum(y_rate{i,j}));
%             end
%         end
         rate = sum(sum(rate_block))/(repeat_width*8*repeat_height*8);
         outData = [rate,dss_real];
%          real=reshape(rate_block,repeat_height*repeat_width,1);
%         dlmwrite('real_rate.txt',real);
    else
%         mse_est = 0;
%         rate_est = 0;
        dss = zeros(8,8);
        rate_est = zeros(8,8);
        lumMat2 = reshape(lumMat, 8, 8)';
       
%         for i = 1:8
%             for j = 1:8
%                 mse_est =mse_est + mse_table(i,j, lumMat2(i,j));
%                 rate_est = rate_est + rate_table(i,j, lumMat2(i,j));
%             end
%         end  
        for i = 1:8
            for j = 1:8
%                 mse_est(i,j) = mse_table(i,j, lumMat2(i,j))/(repeat_width*repeat_height);
%                 rate_est(i,j)= rate_table(i,j, lumMat2(i,j))/(repeat_width*repeat_height);
                dss(i,j) = dss_table(i,j, lumMat2(i,j));
                rate_est(i,j)= rate_table(i,j, lumMat2(i,j));
            end
        end  
       dss_est = 1/sum(sum(dss .* (w/sum(w(:)))));
       rate_est = sum(sum(rate_est))/(repeat_width*8*repeat_height*8);    
         outData = [rate_est,dss_est ];
    end
     
%      outData = [ y_mse,rate];
%     outData = [ y_mse,rate,mse_est ,rate_est];
%      outData = [mse,sum(sum(rate_block)), mse_est ,rate_est];
%     outData = [mse/(repeat_width*8*repeat_height*8),sum(sum(rate_block))/(repeat_width*8*repeat_height*8), mse_est/(repeat_width*8*repeat_height*8) ,rate_est/(repeat_width*8*repeat_height*8)];
end
    