function [pop,aim] = grouping(fitnessvalue,populationlum,basevalue_est,populationlum_chushijie)
center = [0.4,0.8,1.2,1.6];
    X = center - fitnessvalue(:,1);
    X(X(:,1) <=0.4 & X(:,1)>=0 ,1)= 0;
    X(X(:,2) <=0.4 & X(:,2)>=0,2)= 0;
    X(X(:,3) <=0.5 & X(:,3)>=0,3)= 0;
%     X(X(:,4) <=0.4 & X(:,4)>=0,4)= 0;
    pop1 = find(X(:,1)==0);
    pop2 = find(X(:,2)==0);
    pop3 = find(X(:,3)==0)
    
    pop4 = [pop3(end,1)+1:50];
    pop4 = pop4';
    pop=cell(1,4);
    aim=cell(1,4);
    aim{1,1} = fitnessvalue(pop1,:);
    aim{1,2} = fitnessvalue(pop2,:); 
    aim{1,3} = fitnessvalue(pop3,:);
    aim{1,4} = fitnessvalue(pop4,:);
    
    pop{1,1} = populationlum(pop1,:);
    pop{1,2} = populationlum(pop2,:);
    pop{1,3} = populationlum(pop3,:);
    pop{1,4} = populationlum(pop4,:);
    
    pop_temp1 = pop{1,1};
    pop_temp2 = pop{1,2};
    pop_temp3 = pop{1,3};
    pop_temp4 = pop{1,4}; 
    
    if size(pop_temp1,1)==0   
        fitness1 =  basevalue_est - 0.6;
        index  = find(fitness1(:,1)>=0);
%         [f,index] = sort(fitness4(:,1)>0);
        pop{1,1} = populationlum_chushijie(index(1:2,1),:);
    end
    
    if size(pop_temp2,1)==0   
        fitness2 =  basevalue_est - 0.6;
        index  = find(fitness2(:,1)>=0);
%         [f,index] = sort(fitness4(:,1)>0);
        pop{1,2} = populationlum_chushijie(index(1:2,1),:);
    end
    
    if size(pop_temp3,1)==0 
        fitness3 =  basevalue_est - 1;
        index  = find(fitness3(:,1)>=0);
        pop{1,3} = populationlum_chushijie(index(1:2,1),:);

    end
    if size(pop_temp4,1)==0   
        fitness4 =  basevalue_est - 1.4;
        index  = find(fitness4(:,1)>=0);
%         [f,index] = sort(fitness4(:,1)>0);
        pop{1,4} = populationlum_chushijie(index(1:2,1),:);
    end
end