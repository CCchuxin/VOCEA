clc;format compact;tic;
% src='rdoea\kodak24\';
% src1='kodak24\';
% for s=1:24
%     filename=['kodim',num2str(s,'%d'),'_population.txt'];
%     filename1=['kodim',num2str(s,'%d'),'_dss.txt'];
%     filename2=['kodim',num2str(s,'%d'),'.png'];
    imag1 = 'DIV2K_valid_HR\0812.png';
%     imag1=fullfile(src1,filename2);
%     rdoea_dss=fullfile(src,filename1);
%     inputName=fullfile(src,filename);
%    population = load(inputName);
population = load('rdoea\DIV2K_valid_HR\0812_population.txt');
   CELL_SIZE = 8;
   img = imread(imag1);
   outputName = '01.jpg';
ycbcr_img = rgb2ycbcr(img);
y_image =ycbcr_img(:, :, 1);
repeat_height = size(y_image, 1)/CELL_SIZE;
repeat_width = size(y_image, 2)/CELL_SIZE;
repeat_height_mat = repmat(CELL_SIZE, [1 repeat_height]);
repeat_width_mat = repmat(CELL_SIZE, [1 repeat_width]);
y_sub_image = mat2cell(y_image, repeat_height_mat, repeat_width_mat);
 
y_sub_dct = y_sub_image;
for i=1:repeat_height
    for j=1:repeat_width
        y_sub_image{i, j} = dcTransform(y_sub_image{i, j});
        y_sub_dct{i,j} = getDCT(y_sub_image{i,j});
    end
end

hist_out = GetInvCoffHist(y_sub_dct, repeat_height, repeat_width);
[dss_table,w] = estBlockDss(y_sub_dct, y_image, 1.55, [1000 300], repeat_height, repeat_width);
rate_table = estBlockRateInd(hist_out, repeat_height, repeat_width);  
   dss = MSE(population, y_image, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 0, dss_table,w, rate_table);
   dss = sortrows(dss);
%    dlmwrite(rdoea_dss,dss);
dlmwrite('rdoea\DIV2K_valid_HR\0812_dss.txt',dss);
% end