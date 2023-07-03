function TCSVT()
 for kod = 1:24
% inputName = 'kodak24\kodim20.png';
 inputName = ['kodak24\kodim',num2str(kod),'.png'];
outputName = '01.jpg';
CELL_SIZE = 8; %greater than 4
img = imread(inputName);
%%% MAPPER RGB -> YCbCr
ycbcr_img = rgb2ycbcr(img);
y_image =ycbcr_img(:, :, 1);
cb_image =ycbcr_img(:, :, 2);
cr_image =ycbcr_img(:, :, 3);
%%% Turn into cells 8x8
repeat_height = size(y_image, 1)/CELL_SIZE;
repeat_width = size(y_image, 2)/CELL_SIZE;
repeat_height_mat = repmat(CELL_SIZE, [1 repeat_height]);
repeat_width_mat = repmat(CELL_SIZE, [1 repeat_width]);
y_sub_image = mat2cell(y_image, repeat_height_mat, repeat_width_mat);
cb_sub_image = mat2cell(cb_image, repeat_height_mat, repeat_width_mat);
cr_sub_image = mat2cell(cr_image, repeat_height_mat, repeat_width_mat);

y_sub_dct = y_sub_image;
cb_sub_dct = cb_sub_image;
cr_sub_dct = cr_sub_image;

for i=1:repeat_height
    for j=1:repeat_width
        y_sub_image{i, j} = dcTransform(y_sub_image{i, j});
        y_sub_dct{i,j} = getDCT(y_sub_image{i,j});
    end
end

for i=1:repeat_height
    for j=1:repeat_width
        cb_sub_image{i, j} = dcTransform(cb_sub_image{i, j});
        cb_sub_dct{i,j} = getDCT(cb_sub_image{i,j});
    end
end

for i=1:repeat_height
    for j=1:repeat_width
        cr_sub_image{i, j} = dcTransform(cr_sub_image{i, j});
        cr_sub_dct{i,j} = getDCT(cr_sub_image{i,j});
    end
end

hist_out = GetInvCoffHist(y_sub_dct, repeat_height, repeat_width);
mse_table = estBlockDistortionInd(hist_out);
rate_table = estBlockRateInd(hist_out, repeat_height, repeat_width);

cb_hist_out = GetInvCoffHist(cb_sub_dct, repeat_height, repeat_width);
cb_mse_table = estBlockDistortionInd(cb_hist_out);
cb_rate_table = estBlockRateInd(cb_hist_out, repeat_height, repeat_width);

cr_hist_out = GetInvCoffHist(cr_sub_dct, repeat_height, repeat_width);
cr_mse_table = estBlockDistortionInd(cr_hist_out);
cr_rate_table = estBlockRateInd(cr_hist_out, repeat_height, repeat_width);

%---初始化/参数设定
generations=30;                                %迭代次数
popnum=16;                                     %种群大小(须为偶数)
global poplength
poplength=128;                                            %个体长度
lumMat = [
    16 11 10 16 24 40 51 61 ...
    12 12 14 19 26 58 60 55 ...
    14 13 16 24 40 57 69 56 ...
    14 17 22 29 51 87 80 62 ...
    18 22 37 56 68 109 103 77 ...
    24 35 55 64 81 104 113 92 ...
    49 64 78 87 103 121 120 101 ...
    72 92 95 98 112 100 103 99];
chromMat = [
             17 18 24 47 99 99 99 99 ... 
             18 21 26 66 99 99 99 99 ... 
             24 26 56 99 99 99 99 99 ... 
             47 66 99 99 99 99 99 99 ... 
             99 99 99 99 99 99 99 99 ... 
             99 99 99 99 99 99 99 99 ... 
             99 99 99 99 99 99 99 99 ... 
             99 99 99 99 99 99 99 99];
 Lum_Chro = [ lumMat chromMat]; 
populationlum = zeros(popnum,128);
for i = 1:popnum
   %   out = quantLumMat(lumMat, i);
    out = quantLumMat(Lum_Chro, (50 - ((i) - popnum/2)*5));
    populationlum(i,:) = out;
end
% population = zeros(population1,128);
%  for i = 1:population1%种群1初始化   
%      out = quantLumMat(Lum_Chro, i);
%      population(i,:) = out;
%  end

 basevalue_est = MSE_chrom(populationlum, y_sub_image, y_sub_dct, cb_sub_image, cb_sub_dct, cr_sub_image, cr_sub_dct,repeat_height, repeat_width, outputName, 1, mse_table, rate_table,cb_mse_table, cb_rate_table,cr_mse_table, cr_rate_table);
 % figure
% plot(basevalue_est(:,1),basevalue_est(:,2),'-*b');                 %作图

% figure
%---开始迭代进化
 for gene=1:generations                      %开始迭代

    px=size(populationlum,1);
    if mod(px,2)~=0
        populationlum(px+1,:)=Lum_Chro;
    end
    newpopulation=ones(size(populationlum,1),poplength);
    for i = 1:2:px-1
        a=rand();
        if(a<=0.2)
            cpoint = 64;
            index = getTopKPostion(mse_table, rate_table,cb_mse_table, cb_rate_table,cr_mse_table,cr_rate_table, populationlum(i,:), populationlum(i+1,:), cpoint);
            newpopulation(i,:) = populationlum(i,:);
            newpopulation(i, index) = populationlum(i+1, index);
            index = getTopKPostion(mse_table, rate_table,cb_mse_table, cb_rate_table,cr_mse_table,cr_rate_table,populationlum(i+1,:), populationlum(i,:), cpoint);
            newpopulation(i+1,:) = populationlum(i+1,:);
            newpopulation(i+1, index) = populationlum(i, index);              %交叉
        else
            b=rand();
            if b<=0.5
                if gene<generations/2
                   temp =round(rand.*127)+1;
                else
                   temp = 16;
                end
                newpopulation(i,:) = populationlum(i,:);
                newpopulation(i+1,:) = populationlum(i+1,:);
                %            [add_index, minus_index] = getTopKPostionForMut(mse_table, rate_table, populationlum(i,:), temp);%lp
                [ minus_index,index_new] = getTopKPostionForMut(mse_table, rate_table,cb_mse_table, cb_rate_table,cr_mse_table,cr_rate_table, populationlum(i,:), temp);
                populationlum(i,index_new(1,:)) = minus_index(1,index_new(1,:));
                [ minus_index,index_new] = getTopKPostionForMut(mse_table, rate_table,cb_mse_table, cb_rate_table,cr_mse_table,cr_rate_table, populationlum(i+1,:), temp);
                populationlum(i+1,index_new(1,:)) = minus_index(1,index_new(1,:));
            else
                newpopulation(i,:) = populationlum(i,:);              %变异二
                newpopulation(i+1,:) = populationlum(i+1,:);
                q=round(rand.*100)+1;
                if q<1
                    q=1;
                    scale=50*100/q;
                end
                if q>100
                    q=100;
                    scale=200-q*2;
                end
                if q<50
                    scale=50*100/q;
                else
                    scale=200-q*2;
                end
                for j=1:128
                    newpopulation(i,j)=round((newpopulation(i,j)*scale+50)/100);
                    if newpopulation(i,j)<1
                        newpopulation(i,j)=1;
                    else
                        if newpopulation(i,j)>255
                            newpopulation(i,j)=255;
                        end
                    end
                end
                for k=1:128
                    newpopulation(i+1,k)=round((newpopulation(i+1,k)*scale+50)/100);
                    if newpopulation(i+1,k)<1
                        newpopulation(i+1,k)=1;
                    else
                        if newpopulation(i+1,k)>255
                            newpopulation(i+1,k)=255;
                        end
                    end
                end
            end
        end
    end
    newpopulation=[populationlum;newpopulation];                               %合并父子种群
%     functionvalue=MSE(newpopulation, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 1, mse_table, rate_table);    
    [functionvalue,y_mse,cbcr_mse]=MSE_chrom(newpopulation, y_sub_image, y_sub_dct, cb_sub_image, cb_sub_dct, cr_sub_image, cr_sub_dct,repeat_height, repeat_width, outputName, 1, mse_table, rate_table,cb_mse_table, cb_rate_table,cr_mse_table, cr_rate_table);   
    cv1 = functionvalue(:,1) - basevalue_est(1,1);
    cv2 = basevalue_est(size(basevalue_est,1),1) - functionvalue(:,1);
    cv1(cv1 < 0)= 0;
    cv2(cv2 < 0) = 0;
    cv = cv1 + cv2;
%     [frontvalue, ~] = NDSort(functionvalue, cv, inf);
    [frontvalue, ~] = NDSort(functionvalue, inf);
    newnum=numel(frontvalue,frontvalue<=1);                              %前fnum个面的个体数
    if(newnum <50)
        populationlum(1:newnum,:)=newpopulation(frontvalue<=1,:);
    else
        populationlum_temp(1:newnum,:)=newpopulation(frontvalue<=1,:);
        % convex hull
        point = functionvalue(frontvalue<=1,:);
        point(newnum + 1,:)=[point(1,1)+10, point(size(point,1),2)+10];
        [point, index]=unique( point,'rows');
        populationlum_temp_new(1:size(index,1)-1,:)= populationlum_temp(index(1:size(index,1)-1),:);
        dt = delaunayTriangulation(point(:,1),point(:,2));
        k = convexHull(dt); 
        functionvalue_gen = [dt.Points(k,1) dt.Points(k,2)];   
        populationlum = populationlum_temp(1,:);%初始化populationlum
        populationlum(1:size(k,1)-2,:) = populationlum_temp_new(k(k(1:size(k,1)-1,1)<size(dt.Points,1)),:);
        functionvalue_gen_new = functionvalue_gen(1:size(functionvalue_gen(:,1))-2,:);
        n=size(k,1)-1;
      if gene<20
          for r =1:(size(functionvalue_gen,1)-3)
              c= (functionvalue_gen(r+1,1)- functionvalue_gen(r,1)).^2+(functionvalue_gen(r+1,2)- functionvalue_gen(r,2)).^2;
              if c>15        
                  popolationlum_new= populationlum(r+1,:);
                  ratelow = functionvalue_gen(r+1,1);
                  ratehigh = functionvalue_gen(r,1);
                  quality = 50 - (ratelow - ratehigh)*50/ratelow
                   populationlum(n,:)=quantLumMat(popolationlum_new, quality);  
                   n = n+1;%5.6修改
              end     
          end
      end
    end
    
    [functionvalue,y_mse,cbcr_mse]=MSE_chrom(newpopulation, y_sub_image, y_sub_dct, cb_sub_image, cb_sub_dct, cr_sub_image, cr_sub_dct,repeat_height, repeat_width, outputName, 1, mse_table, rate_table,cb_mse_table, cb_rate_table,cr_mse_table, cr_rate_table);
%      ycbcr_mse(:,1) =y_mse ./cbcr_mse;
     Next = (y_mse ./cbcr_mse)>1;
     index = find(Next);
     dlmwrite(['./NEWKODIM/Qtable/kodim',num2str(kod),'.txt'],newpopulation(index,:),'-append');
     dlmwrite(['./NEWKODIM/fitness/kodim',num2str(kod),'.txt'],functionvalue(index,:),'-append');
     dlmwrite(['./NEWKODIM/mse/kodim',num2str(kod),'.txt'],[y_mse,cbcr_mse],'-append');
%        f=MSE(populationlum, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 0, mse_table, rate_table);
%       dlmwrite(['result/myhigh/kodim24/f',num2str(gene),'.txt'],f);
%       metrics(gene,:) = HV(f,PF);
%       dlmwrite(['result/myhigh/kodim24/HV',num2str(gene),'.txt'],metrics);
%      dlmwrite(['./lena/lenaByte',num2str(j),'.txt'],a);
       %      plot(functionvalue1(:,1),functionvalue1(:,2),'o')       
%     drawnow
 end

%---程序输出
% output=sortrows(functionvalue(frontvalue==1,:));    %最终结果:种群中非支配解的函数值
% output1=functionvalue(frontvalue==1,:);

% figure;
% paretoindex = frontvalue == 1;  
% paretopopulation = newpopulation(paretoindex,:);
% truevalue = MSE(paretopopulation(1,:), y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 0, mse_table, rate_table);
% fprintf('已完成,耗时%4s秒\n',num2str(toc));          %程序最终耗时
% dlmwrite('result/myhigh/kodim02/time.txt',num2str(toc));
% truevalue = MSE(paretopopulation, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 0, mse_table, rate_table);
% % dlmwrite('result/myhigh/kodim01/truevalue.txt',truevalue);
% dlmwrite('result/myhigh/kodim02/population.txt',paretopopulation);
% truevalue_new = sortrows(truevalue);
% PF = [truevalue_new(end,1),truevalue_new(1,2)]
% metrics = HV(truevalue_new,PF)
% dlmwrite('result/myhigh/kodim02/truevalue_new.txt',truevalue_new);
% 
% plot(truevalue_new(:,1),truevalue_new(:,2),'-*g');
% hold on;
% % truevalue_new100 = load('result/myhigh/kodim01/truevalue_new100.txt');
% % plot(truevalue_new100(:,1),truevalue_new100(:,2),'-or');
% plot(output(:,1),output(:,2),'-*b');                 %作图
% xlabel('Rate(bpp)');ylabel('MSE');
% legend('real','estimate');
 end
 kod = kod+1;
end


function out = getTopKPostion(mse_whole, rate_whole,cb_mse_table, cb_rate_table,cr_mse_table,cr_rate_table, lumMat1, lumMat2, k)
value = zeros(128,1);
value(:) = 10000000;
mse_whole = [mse_whole;cb_mse_table;cr_mse_table];
rate_whole = [rate_whole;cb_rate_table;cr_rate_table];
for i = 1:128
   m = floor((i-1)/8)+1;
    n = mod(i-1, 8) + 1;
    q1 = lumMat1(i);
    q2 = lumMat2(i);
    if q1 ~= q2
        if q1 < q2
            dist1 = mse_whole(m,n,q1);
            dist2 = mse_whole(m,n,q2);
            rate1 = rate_whole(m,n,q1);
            rate2 = rate_whole(m,n,q2);
            if rate1 ~= rate2
                slope = (dist2 - dist1)/(rate1 - rate2); %smaller better
                value(i) = slope;
            end
        else
            dist1 = mse_whole(m,n,q1);
            dist2 = mse_whole(m,n,q2);
            rate1 = rate_whole(m,n,q1);
            rate2 = rate_whole(m,n,q2);
            if dist1 ~= dist2
                slope = (rate2 - rate1)/(dist1 - dist2); %smaller better
                value(i) = slope;
            end
        end
    end
end

[~, index]=sort(value);
out = index(1:k);
end

function [ minus_index,index_new] = getTopKPostionForMut(mse_whole, rate_whole,cb_mse_table, cb_rate_table,cr_mse_table,cr_rate_table, lumMat1, k)
 minus_value = zeros(1,128);
 minus_index = zeros(1,128);
 mse_whole = [mse_whole;cb_mse_table;cr_mse_table];
rate_whole = [rate_whole;cb_rate_table;cr_rate_table];
 for i = 1:128
     value(1:255) = 0;
     m = floor((i-1)/8)+1;
     n = mod(i-1, 8) + 1;
     q1 = lumMat1(i); 
     q2 = q1 + 1;
     if q1 < 205&&q1>50
         q_high=q1+50;
         for j=q2:q_high
             if q1 < q2
                 dist1 = mse_whole(m,n,q1);
                 dist2 = mse_whole(m,n,j);
                 rate1 = rate_whole(m,n,q1);
                 rate2 = rate_whole(m,n,j);
                 if dist2~=dist1
                     slope = (rate2 - rate1)/(dist1 - dist2); %bigger better
                     value(j) = slope;
                 end
             end
         end
     else
         if q1>205
             for j=q2:255
                 if q1 < q2
                     dist1 = mse_whole(m,n,q1);
                     dist2 = mse_whole(m,n,j);
                     rate1 = rate_whole(m,n,q1);
                     rate2 = rate_whole(m,n,j);
                     if dist2~=dist1
                         slope = (rate2 - rate1)/(dist1 - dist2); %bigger better
                         value(j) = slope;
                     end
                 end
             end
         else
             if q1<50
                 for j=q2:(q1+50)
                     if q1 < q2
                         dist1 = mse_whole(m,n,q1);
                         dist2 = mse_whole(m,n,j);
                         rate1 = rate_whole(m,n,q1);
                         rate2 = rate_whole(m,n,j);
                         if dist2~=dist1
                             slope = (rate2 - rate1)/(dist1 - dist2); %bigger better
                             value(j) = slope;
                         end
                     end
                 end
             end
         end 
       end
         q2 = q1 - 1;
         if q1>50&&q1<205
             q_low=q1-50;
             for j=q_low:q2
                 dist1 = mse_whole(m,n,q1);
                 dist2 = mse_whole(m,n,j);
                 rate1 = rate_whole(m,n,q1);
                 rate2 = rate_whole(m,n,j);
                 if rate2~=rate1
                     slope = (dist1 - dist2)/(rate2 - rate1); %bigger better
                     value(j) = slope;
                 end
             end
         else
             if q1<=50
                 for j=1:q2
                     dist1 = mse_whole(m,n,q1);
                     dist2 = mse_whole(m,n,j);
                     rate1 = rate_whole(m,n,q1);
                     rate2 = rate_whole(m,n,j);
                     if rate2~=rate1
                         slope = (dist1 - dist2)/(rate2 - rate1); %bigger better
                         value(j) = slope;
                     end
                 end
             else
                 if q1>=205
                     q_low=q1-50;
                     for j=q_low:q2
                         dist1 = mse_whole(m,n,q1);
                         dist2 = mse_whole(m,n,j);
                         rate1 = rate_whole(m,n,q1);
                         rate2 = rate_whole(m,n,j);
                         if rate2~=rate1
                             slope = (dist1 - dist2)/(rate2 - rate1); %bigger better
                             value(j) = slope;
                         end
                     end
                 end
             end
         end
    [value_new, index2]=sort(value,'descend');
    minus_value(1,i)=value_new(1,1);
    minus_index(1,i) = index2(1,1); 
end
[~, index1]=sort(minus_value,'descend');
index_new=index1(1:k);
end


function out = quantLumMat(lumMat, quality)

if quality <= 50
    quality = 5000 / quality;
else
    quality = 200 - quality * 2;
end
matr = lumMat;
for i=1:128
    matr(i) = floor((matr(i) * quality + 50) / 100);
    if matr(i) <= 0
        matr(i) = 1;
    elseif matr(i) > 255
        matr(i) = 255;
    end
end
out = matr;
end