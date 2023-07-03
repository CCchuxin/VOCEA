function TCSVT()
clc;format compact;tic;
% figure;
inputName = 'kodak24\kodim11.png';
outputName = '01.jpg';

CELL_SIZE = 8; %greater than 4
img = imread(inputName);
%%% MAPPER RGB -> YCbCr
ycbcr_img = rgb2ycbcr(img);
y_image =ycbcr_img(:, :, 1);

%%% Turn into cells 8x8
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

%---初始化/参数设定
generations=50;                                %迭代次数
population1=50;                                     %种群1大小(须为偶数)
global poplength
poplength=64;                                            %个体长度
lumMat = [16 11 10 16 24 40 51 61 ...
    12 12 14 19 26 58 60 55 ...
    14 13 16 24 40 57 69 56 ...
    14 17 22 29 51 87 80 62 ...
    18 22 37 56 68 109 103 77 ...
    24 35 55 64 81 104 113 92 ...
    49 64 78 87 103 121 120 101 ...
    72 92 95 98 112 100 103 99];       
 population = zeros(population1,64);
  for i = 1:population1%种群1初始化   
     out = quantLumMat(lumMat, i*2);
     population(i,:) = out;
  end
  pop = 16;
  population2 = zeros(pop,64);
  for i = 1:pop%种群2初始化   
     out = quantLumMat(lumMat, (50 - ((i) - pop/2)*5));
     population2(i,:) = out;
  end 
populationlum1 = population;
populationlum2 = population2;
%---开始迭代进化
 for gene=1:generations                      %开始迭代
    populationlum2 = [populationlum2;populationlum1];
    px=size(populationlum2,1);           %种群2无约束
    if mod(px,2)~=0
        populationlum2(px+1,:)=lumMat;
    end
    newpopulation=ones(size(populationlum2,1),poplength);
    for i = 1:2:px-1
        a=rand();
        if(a<=0.2)
            cpoint = 16;
            index = getTopKPostion(dss_table, rate_table,populationlum2(i,:), populationlum2(i+1,:), cpoint);
            newpopulation(i,:) = populationlum2(i,:);
            newpopulation(i, index) = populationlum2(i+1, index);
            index = getTopKPostion(dss_table, rate_table,populationlum2(i+1,:), populationlum2(i,:), cpoint);
            newpopulation(i+1,:) = populationlum2(i+1,:);
            newpopulation(i+1, index) = populationlum2(i, index);              %交叉
        else
            b=rand();
            if b<=0.5
                if gene<generations/2
                   temp =round(rand.*63)+1;
                else
                   temp = 16;
                end
                newpopulation(i,:) = populationlum2(i,:);
                newpopulation(i+1,:) = populationlum2(i+1,:);
                %            [add_index, minus_index] = getTopKPostionForMut(mse_table, rate_table, populationlum(i,:), temp);%lp
                [ minus_index,index_new] = getTopKPostionForMut(dss_table, rate_table, populationlum2(i,:), temp);
                populationlum2(i,index_new(1,:)) = minus_index(1,index_new(1,:));
                [ minus_index,index_new] = getTopKPostionForMut(dss_table, rate_table,populationlum2(i+1,:), temp);
                populationlum2(i+1,index_new(1,:)) = minus_index(1,index_new(1,:));
            else
                newpopulation(i,:) = populationlum2(i,:);              %变异二
                newpopulation(i+1,:) = populationlum2(i+1,:);
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
                for j=1:64
                    newpopulation(i,j)=round((newpopulation(i,j)*scale+50)/100);
                    if newpopulation(i,j)<1
                        newpopulation(i,j)=1;
                    else
                        if newpopulation(i,j)>255
                            newpopulation(i,j)=255;
                        end
                    end
                end
                for k=1:64
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
    newpopulation = [populationlum2;newpopulation];
    functionvalue = MSE(newpopulation, y_image, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 1, dss_table, w, rate_table);
    [frontvalue, ~] = NDSort(functionvalue, inf);
     newnum=numel(frontvalue,frontvalue<=1);                              %前fnum个面的个体数   
    if(newnum <50)
        populationlum2(1:newnum,:)=newpopulation(frontvalue<=1,:);
    else
        populationlum_temp(1:newnum,:)=newpopulation(frontvalue<=1,:);
%         % convex hull
        point = functionvalue(frontvalue<=1,:);
        point(newnum + 1,:)=[point(1,1)+10, point(size(point,1),2)+10];
        [point, index]=unique( point,'rows');
        populationlum_temp_new(1:size(index,1)-1,:)= populationlum_temp(index(1:size(index,1)-1),:);
        dt = delaunayTriangulation(point(:,1),point(:,2));
        k = convexHull(dt); 
        functionvalue_gen = [dt.Points(k,1) dt.Points(k,2)];   
        populationlum2 = populationlum_temp(1,:);%初始化populationlum
        populationlum2(1:size(k,1)-2,:) = populationlum_temp_new(k(k(1:size(k,1)-1,1)<size(dt.Points,1)),:);
        functionvalue_gen_new = functionvalue_gen(1:size(functionvalue_gen(:,1))-2,:);
        n=size(k,1)-1;        
       if gene<20
          for r =1:(size(functionvalue_gen,1)-3)
              c= (functionvalue_gen(r+1,1)- functionvalue_gen(r,1)).^2+(functionvalue_gen(r+1,2)- functionvalue_gen(r,2)).^2;
              if c>0.1        
                  popolationlum_new= populationlum2(r+1,:);
                  ratelow = functionvalue_gen(r+1,1);
                  ratehigh = functionvalue_gen(r,1);
%                   quality = 50 - (ratelow - ratehigh)*50/ratelow
                  quality = 50 - (ratelow - ratehigh)*50/ratelow
                  populationlum2(n,:)=quantLumMat(popolationlum_new, quality);  
              end     
          end
       end
    end
%   population2 = populationlum2;
%   populationlum = [newpopulation;populationlum2];
  
  populationlum = [populationlum1;populationlum2];
    px=size(populationlum,1);
    if mod(px,2)~=0
        populationlum(px+1,:)=lumMat;
    end
    newpopulation=ones(size(populationlum,1),poplength);
    for i = 1:2:px-1
        a=rand();
        if(a<=0.2)
            cpoint = 16;
            index = getTopKPostion(dss_table, rate_table,populationlum(i,:), populationlum(i+1,:), cpoint);
            newpopulation(i,:) = populationlum(i,:);
            newpopulation(i, index) = populationlum(i+1, index);
            index = getTopKPostion(dss_table, rate_table,populationlum(i+1,:), populationlum(i,:), cpoint);
            newpopulation(i+1,:) = populationlum(i+1,:);
            newpopulation(i+1, index) = populationlum(i, index);              %交叉
        else
            b=rand();
            if b<=0.5
                if gene<generations/2
                   temp =round(rand.*63)+1;
                else
                   temp = 16;
                end
                newpopulation(i,:) = populationlum(i,:);
                newpopulation(i+1,:) = populationlum(i+1,:);
                %            [add_index, minus_index] = getTopKPostionForMut(mse_table, rate_table, populationlum(i,:), temp);%lp
                [ minus_index,index_new] = getTopKPostionForMut(dss_table, rate_table, populationlum(i,:), temp);
                populationlum(i,index_new(1,:)) = minus_index(1,index_new(1,:));
                [ minus_index,index_new] = getTopKPostionForMut(dss_table, rate_table,populationlum(i+1,:), temp);
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
                for j=1:64
                    newpopulation(i,j)=round((newpopulation(i,j)*scale+50)/100);
                    if newpopulation(i,j)<1
                        newpopulation(i,j)=1;
                    else
                        if newpopulation(i,j)>255
                            newpopulation(i,j)=255;
                        end
                    end
                end
                for k=1:64
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
    newpopulation = [populationlum;newpopulation];  %合并父子种群1
    functionvalue = MSE(newpopulation, y_image, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 1, dss_table, w, rate_table);
     
    X = [0.2,0.6,1,1.4];   %可行域
    Y = abs(X - functionvalue(:,1));
    Y(Y(:,1) <=0.05,1)= 0; % [0.2-0.2*10%,0.2+0.2*10%]
    Y(Y(:,2) <=0.1,2)= 0;  %[0.6-0.6*10%,0.6+0.6*10%]
    Y(Y(:,3) <=0.1,3)= 0;  %[1-1*10%,1+1*10%]
    Y(Y(:,4) <=0.2,4)= 0;  %[1.4-1.4*10%,1.4+1.4*10%]
    [cov,~]=min(Y,[],2);   %每一行选择最小的保存
    CV = CalCV(cov);       %归一化
    Fitness = CalFitness(functionvalue,CV); %计算适应度值
    [populationlum1,Fitness] = EnvironmentalSelection(Fitness,newpopulation,functionvalue,population1);   
%     functionvalue = MSE(populationlum1, y_image, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 1, dss_table, w, rate_table);
 end
    truevalue = MSE(populationlum1(1,:), y_image, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 0, dss_table,w, rate_table);
    fprintf('已完成,耗时%4s秒\n',num2str(toc));          %程序最终耗时

    truevalue = MSE(populationlum1, y_image, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 0, dss_table,w, rate_table);
%     dlmwrite('DSSresult/kodim11/truevalue.txt',truevalue);
%     dlmwrite('DSSresult/kodim11/QT.txt',populationlum1);

    estvalue = MSE(populationlum1, y_image, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 1, dss_table,w, rate_table);
    X = [0.2,0.6,1,1.4];%可行域
    Y = abs(X - truevalue(:,1));
    Y_est = abs(X - estvalue(:,1));
    Y_est(Y_est(:,1) <=0.05,1)= 0;
    Y_est(Y_est(:,2) <=0.1,2)= 0;
    Y_est(Y_est(:,3) <=0.1,3)= 0;
    Y_est(Y_est(:,4) <=0.1,4)= 0;
    [cov_est,~]=min(Y_est,[],2);
    index_est = find(cov_est==0);
    
    Y(Y(:,1) <=0.05,1)= 0;
    Y(Y(:,2) <=0.1,2)= 0;
    Y(Y(:,3) <=0.1,3)= 0;
    Y(Y(:,4) <=0.1,4)= 0
    [cov,~]=min(Y,[],2);
    Yvalue = X - truevalue(:,1);
    index1 = find(cov==0);
    truevalue_new=truevalue(index1,:);

    Yest = abs(X - estvalue(:,1));
    Yest(Yest(:,1) <=0.05,1)= 0;
    Yest(Yest(:,2) <=0.1,2)= 0;
    Yest(Yest(:,3) <=0.1,3)= 0;
    Yest(Yest(:,4) <=0.1,4)= 0;
    [covest,~]=min(Yest,[],2);
    indexest = find(covest==0);
    output=estvalue(indexest,:);
    
    Ytrue = abs(X - truevalue_new(:,1));
    Ytrue(Ytrue(:,1) <=0.05,1)= 0;
    Ytrue(Ytrue(:,2) <=0.05,2)= 0;
    Ytrue(Ytrue(:,3) <=0.05,3)= 0;
    Ytrue(Ytrue(:,4) <=0.05,4)= 0;
    [covtrue,~]=min(Ytrue,[],2);
    indextrue = find(covtrue==0);
    truevalue_new=truevalue_new(indextrue,:);
    figure;
    y1 = 3;
    y2 = 1.5;
    y3 = 1.5;
    y4 = 1.5;
    % bar(x,y);
    hold on
    bar(0.2,y1,0.1)
    hold on
    bar(0.6,y2,0.1)
    hold on
    bar(1,y3,0.1)
    hold on
    bar(1.4,y4,0.1)
    unCov_truevalue = load('unCov_truevalue/kodim11_truevalue.txt');
     jpeg = load('unCov_truevalue/jpeg_kodim11.txt');
     plot(truevalue_new(:,1),truevalue_new(:,2),'*r');
     hold on;
     plot(output(:,1),output(:,2),'^b');
     hold on;
     plot(jpeg(:,1),jpeg(:,2),'og');
     hold on;
     plot(unCov_truevalue(:,1),unCov_truevalue(:,2),'*m');
     xlabel('Rate(bpp)');ylabel('1/DSS');
     legend('Feasible regions','Feasible regions','Feasible regions','Feasible regions','Obtained solutions','Est with constraints','jpeg','PF without constraints');
 end


function CV = CalCV(CV_Original)
    CVmax = max(CV_Original);
    CVmin = min(CV_Original);
    CV = (CV_Original-CVmin)./(CVmax - CVmin);
%     CV(:,isnan(CV(1,:))) = 0;%12.23
%     CV = mean(CV,2);%12.23
end


function out = getTopKPostion(mse_whole, rate_whole, lumMat1, lumMat2, k)
value = zeros(64,1);
value(:) = 10000000;
for i = 1:64
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

function [ minus_index,index_new] = getTopKPostionForMut(mse_whole, rate_whole, lumMat1, k)
 minus_value = zeros(1,64);
 minus_index = zeros(1,64);
 for i = 1:64
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
for i=1:64
    matr(i) = floor((matr(i) * quality + 50) / 100);
    if matr(i) <= 0
        matr(i) = 1;
    elseif matr(i) > 255
        matr(i) = 255;
    end
end
out = matr;
end