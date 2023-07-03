function Offspring = GAhalf(Parent,gene,mse_table, rate_table,generations)
        Parent1 = Parent(1:floor(end/2),:);
        Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
        a=rand();
        if(a<=0.2)
            cpoint = 16;
            index = getTopKPostion(mse_table, rate_table, Parent1, Parent2, cpoint); %½»²æ
            Offspring = Parent1;
            Offspring(:, index) = Parent2(:, index);
        else
            b=rand();
            if b<=0.5
                if gene<generations/2
                   temp =round(rand.*63)+1;
                else
                    temp =16;
                end
                Offspring = Parent1;
                [ minus_index,index_new] = getTopKPostionForMut(mse_table, rate_table, Parent1, temp);
                Offspring(:,index_new(1,:)) = minus_index(1,index_new(1,:));         
            else
                Offspring = Parent1;              %±äÒì¶þ
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
        end
end