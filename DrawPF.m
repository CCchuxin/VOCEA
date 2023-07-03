function DrawPF(num)
    switch num
        case 9
            x = 0 : 0.001 : 1;
            y = 1-x.^0.6;
            plot(x,y,'-k');
            [x,y] = meshgrid(0:0.01:2.1);
            T1 = (1-0.64*x.^2-y).*(1-0.36*x.^2-y);
            T2 = 1.35.^2-(x+0.35).^2-y;
            T3 = 1.15.^2-(x+0.15).^2-y;
            c  = min(T1,T2.*T3)<=0;
            z  = zeros(size(x));
            z(~c) = nan;
            hold on;
            surf(x,y,z,'FaceColor',[.8 .8 .8],'EdgeColor','none');
            axis([0 2 0 2]);
        case 11
            x = 0 : 0.001 : sqrt(2);
            y = sqrt(2-x.^2);
            plot(x,y,'-k');
            [x,y] = meshgrid(0:0.01:2.1);
            c1 = (3-x.^2-y).*(3-2*x.^2-y) >= 0;
            c2 = (3-0.625*x.^2-y).*(3-7*x.^2-y) <= 0;
      
            c3 = (1.62-0.18*x.^2-y).*(1.125-0.125*x.^2-y) >= 0;
            c4 = (2.07-0.23*x.^2-y).*(0.63-0.07*x.^2-y) <= 0;
            c  = c1 & c2 & c3 & c4 & (x.^2+y.^2>=2);
            z  = zeros(size(x));
            z(~c) = nan;
            hold on;
            surf(x,y,z,'FaceColor',[.8 .8 .8],'EdgeColor','none');
            axis([0 3 0 3]);
        case 12
            x = 0 : 0.001 : 1;
            y = 0.85 - 0.8*x - 0.08*abs(sin(3.2*pi*x));
            plot(x,y,'-k');
            [x,y] = meshgrid(0:0.01:2.1);
            T1 = 1 - 0.8*x - y + 0.08*sin(2*pi*(y-x/1.5));
            T2 = 1 - 0.625*x - y + 0.08*sin(2*pi*(y-x/1.6));
            T3 = 1.4 - 0.875*x - y + 0.08*sin(2*pi*(y/1.4-x/1.6));
            T4 = 1.8 - 1.125*x - y + 0.08*sin(2*pi*(y/1.8-x/1.6));
            c  = T1.*T4<=0 & T2.*T3>=0 & (0.8*x-0.08*abs(sin(3.2*pi*x))+y>=0.85);
            z  = zeros(size(x));
            z(~c) = nan;
            hold on;
            surf(x,y,z,'FaceColor',[.8 .8 .8],'EdgeColor','none');
            axis([0 2 0 2]);
        case 13
            x = 0 : 0.001 : 1.5;
            y = 5-exp(x)-0.5*abs(sin(3*pi*x));
            j=[];
            for i=1:1500
                for k=i:1500
                    if x(k)>x(i) && y(k)>y(i)
                        j=union(j,k);
                    end
                end
            end
            x(j)=nan;
            y(j)=nan;
            plot(x,y,'-k');
            [x,y] = meshgrid(0:0.001:5.1);
            T1 = 5-exp(x)-0.5*sin(3*pi*x)-y;
            T2 = 5-(1+x+0.5*x.^2)-0.5*sin(3*pi*x)-y;
            T3 = 5-(1+0.7*x)-0.5*sin(3*pi*x)-y;
            T4 = 5-(1+0.4*x)-0.5*sin(3*pi*x)-y;
            c  = T1.*T4<=0 & T2.*T3>=0;
            z  = zeros(size(x));
            z(~c) = nan;
            hold on;
            surf(x,y,z,'FaceColor',[.8 .8 .8],'EdgeColor','none');
            axis([0 2 0 5]);      
        case 1
            x = 0 : 0.001 : 0.5;
            y = 0.5 - x;
            plot(x,y,'-k');
            [x,y] = meshgrid(0:0.001:0.6);
            c = (1-y/0.6-x/0.5) >= 0 & (x+y>=0.5);
            z  = zeros(size(x));
            z(~c) = nan;
            hold on;
            surf(x,y,z,'FaceColor',[.8 .8 .8],'EdgeColor','none');
            axis([0 1 0 1]);
        case 3
            x = 0 : 0.001 : 0.5;
            y = sqrt(1-x.^2);
            plot(x,y,'-k');
            [x,y] = meshgrid(0:0.01:10);
            c = (x.^2+y.^2-16).*(x.^2+y.^2-36) >= 0 & (x.^2+y.^2>=1);
            z  = zeros(size(x));
            z(~c) = nan;
            hold on;
            surf(x,y,z,'FaceColor',[.8 .8 .8],'EdgeColor','none');
            axis([0 9 0 9]);
    end
    grid off;
end