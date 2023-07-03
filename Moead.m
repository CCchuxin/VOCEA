function TCSVT()
clc;format compact;tic;
inputName = 'kodak24\kodim02.png';
outputName = '01.jpg';
CELL_SIZE = 8; %greater than 4
img = imread(inputName);
% MAPPER RGB -> YCbCr
ycbcr_img = rgb2ycbcr(img);
y_image =ycbcr_img(:, :, 1);

% Turn into cells 8x8
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
mse_table = estBlockDistortionInd(hist_out);
rate_table = estBlockRateInd(hist_out, repeat_height, repeat_width);

%---初始化/参数设定
generations=200;                                %迭代次数
population=50;                                     %种群1大小(须为偶数)
global poplength
poplength=64;                                            %个体长度
lumMat = [
    16 11 10 16 24 40 51 61 ...
    12 12 14 19 26 58 60 55 ...
    14 13 16 24 40 57 69 56 ...
    14 17 22 29 51 87 80 62 ...
    18 22 37 56 68 109 103 77 ...
    24 35 55 64 81 104 113 92 ...
    49 64 78 87 103 121 120 101 ...
    72 92 95 98 112 100 103 99];
% repeat = 10;
% for run =1:repeat
    populationlum = zeros(population,64);
    for i = 1:population%种群1初始化   
        out = quantLumMat(lumMat, i*2);
        populationlum(i,:) = out;
%         out = quantLumMat(lumMat, (50 - ((i) - population1/2)*5));
%          populationlum(i,:) = out;
    end
%     out = quantLumMat(lumMat, 25);
%     populationlum(1,:) = out;
    basevalue_est1 = MSE(populationlum, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName,1, mse_table, rate_table);
     PF = [basevalue_est1(population,1),basevalue_est1(1,2)];
   [P,C] = GFM(basevalue_est1(:,2),basevalue_est1(:,1));
   
    CVmax = max(basevalue_est1);
    CVmin = min(basevalue_est1);
    basevalue_est = (basevalue_est1-CVmin)./(CVmax - CVmin);
%   lamda = basevalue_est1(:,2);
%     lamda = sort(basevalue_est1(:,1),'descend')
%      lamda  = 3.2003*power(basevalue_est1(:,1),-1.367);
    lamda  =C*power(basevalue_est1(:,1),-P)
 % lamda  =P*power(basevalue_est1(:,1),-C);
%      lamda  =50*power(basevalue_est1(:,1),-0.8);
    lamda1 = [ abs(lamda) (1:1:50)' ];
    
    lamda2 = CalCV(lamda1);

    %% Generate the weight vectors
%     [W,N] = UniformPoint(52,2);
%     W(1,:) = [];
%     W(end,:) = [];
%     N = N-2;
      [W,N] = UniformPoint(50,2);
     
     
      W = lamda2;
    figure
     plot(W(:,1),W(:,2),'*r')
 %   plot(basevalue_est1(:,1),lamda,'*r')
    hold on;
    plot(basevalue_est1(:,1),basevalue_est1(:,2),'^y')
    T = ceil(N/10);
    
     %% Detect the neighbours of each solution
    B = pdist2(W,W);
    [~,B] = sort(B,2);
    B = B(:,1:T);
    
    Z = min(basevalue_est,[],1);
    figure
    pop_basevalue = basevalue_est;
%% 开始迭代进化
 for gene=1:generations                      %开始迭代
    
     for i = 1 : population
        % Choose the parents
        P = B(i,randperm(size(B,2)));
        Parent = populationlum(P(1:2),:);    
        % Generate an offspring
        Parent1 = Parent(1:floor(end/2),:);
        Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
%         Offspring = Parent1;%5.21
%         a=rand();
%         if(a<=0.2)
            cpoint = 16;
            index = getTopKPostion(mse_table, rate_table, Parent1, Parent2, cpoint); %交叉
            Offspring = Parent1;
            Offspring(:, index) = Parent2(:, index);
%         else

            b=rand();
          if b<=0.5
 %            if b <= gene/generations   
                if gene<generations/2
                   temp =round(rand.*63)+1;
                else
                    temp =16;
                end
%                 Offspring = Parent1;
%                 [ minus_index,index_new] = getTopKPostionForMut(mse_table, rate_table, Parent1, temp);
                [ minus_index,index_new] = getTopKPostionForMut(mse_table, rate_table, Offspring, temp);
                Offspring(:,index_new(1,:)) = minus_index(1,index_new(1,:));         
            else
%                 Offspring = Parent1;              %变异二
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
                    Offspring(:,j)=round((Offspring(:,j)*scale+50)/100);
                    if Offspring(:,j)<1
                        Offspring(:,j)=1;
                    else
                        if Offspring(:,j)>255
                            Offspring(:,j)=255;
                        end
                    end
                end
            end
%         end   
       Offspring_functionvalue=MSE(Offspring, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 1, mse_table, rate_table);
        % Update the ideal point
       Offspring_functionvalue = (Offspring_functionvalue-CVmin)./(CVmax - CVmin);
%        Offspring_functionvalue = CalCV(Offspring_functionvalue);
       Z = min(Z,Offspring_functionvalue);
        
        % Update the neighbours
%          % PBI approach
%                     normW   = sqrt(sum(W(P,:).^2,2));
%                     normP   = sqrt(sum((basevalue_est(P,:)-repmat(Z,T,1)).^2,2));
%                     normO   = sqrt(sum((Offspring_functionvalue-Z).^2,2));
%                     CosineP = sum((basevalue_est(P,:)-repmat(Z,T,1)).*W(P,:),2)./normW./normP;
%                     CosineO = sum(repmat(Offspring_functionvalue-Z,T,1).*W(P,:),2)./normW./normO;
%                     g_old   = normP.*CosineP + 5*normP.*sqrt(1-CosineP.^2);
%                     g_new   = normO.*CosineO + 5*normO.*sqrt(1-CosineO.^2);
          % Tchebycheff approach
            g_old = max(abs(pop_basevalue(P,:)-repmat(Z,T,1)).*W(P,:),[],2);
            g_new = max(repmat(abs(Offspring_functionvalue-Z),T,1).*W(P,:),[],2);
            P = P(g_old>=g_new)
            for j = 1:size(P,2)
                populationlum(P(1,j),:) = Offspring;
            end
            
%              [frontvalue, ~] = NDSort(functionvalue, cv, inf);            
   
     end
     populationlumfitness = MSE(populationlum, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 1, mse_table, rate_table);
     populationlumfitness1 = CalCV(populationlumfitness);
     pop_basevalue = populationlumfitness1;
     plot(populationlumfitness(:,1),populationlumfitness(:,2),'or');
    drawnow;
%     if gene > 100
%       W = pop_basevalue;
%     end
 end
truevalue = MSE(populationlum(1,:), y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 0, mse_table, rate_table);
fprintf('已完成,耗时%4s秒\n',num2str(toc));  
truevalue = MSE(populationlum, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 0, mse_table, rate_table);
%     estvalue = MSE(populationlum, y_sub_image, y_sub_dct, repeat_height, repeat_width, outputName, 1, mse_table, rate_table);
truevalue_new = sortrows(truevalue);
PF = [truevalue_new(end,1),truevalue_new(1,2)]
metrics = HV(truevalue_new,PF)
figure;
  
 unCov_truevalue = load('./unCov_truevalue/kodim02_truevalue.txt');
 
 plot(unCov_truevalue(:,1),unCov_truevalue(:,2),'*y');
 hold on;
 plot(truevalue_new(:,1),truevalue_new(:,2),'*r');
%  hold on;
%  plot(output(:,1),output(:,2),'^b');
%  hold on;
%  unCov_basevalue = load('./unCov_truevalue/kodim21_basevalue.txt');
%  plot(unCov_basevalue(:,1),unCov_basevalue(:,2),'*g');
%  hold on;

%  hold on;
%  plot(truevalue_new1(:,1),truevalue_new1(:,2),'*r');
 xlabel('Rate(bpp)');ylabel('MSE');
 legend('nsgaii','moead');
end

% 
function CV = CalCV(CV_Original)
    CVmax = max(CV_Original);
    CVmin = min(CV_Original);
    CV = (CV_Original-CVmin)./(CVmax - CVmin);
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