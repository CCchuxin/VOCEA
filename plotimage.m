figure;
% y1 = 60;
% y2 = 15;
% y3 = 5;
% y4 = 3;
% x = [0.2 0.6 1 1.4];
% y = [y1 y2 y3 y4]
% barwidth = [0.02 0.06 0.1 0.14]
% % bar(x,y);
% hold on
% bar(0.2,y1,0.04)
% hold on
% bar(0.6,y2,0.12)
% hold on
% bar(1,y3,0.2)
% hold on
% bar(1.4,y4,0.28)
a = load('100.txt');
b = load('300.txt');
plot(a(:,1),a(:,2),'*g');
hold on;
plot(b(:,1),b(:,2),'ob');
