function [P,C] = GFM(D,R)
% Generic front modeling

%------------------------------- CRRopyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    N = length(D);
    R     = max(R,1e-12);
    D     = max(D,1e-12);
    P     = 1;
    C     = 1;
    lamda = 1;
	E     = sum(repmat(C,N,1)./D.*R.^repmat(-P,N,1),2) - 1;
    MSE   = mean(E.^2);
    for epoch = 1 : 1000
        % Calculate the Jacobian matrix
        J = [repmat(C,N,1)./D.*R.^repmat(-P,N,1).*log(R),1./D.*R.^repmat(-P,N,1)];
        % Update the value of each weight
        while true
            Delta  = -(J'*J+lamda*eye(size(J,2)))^-1*J'*E;
            newP   = P + Delta(1);
            newC   = C + Delta(2:end)';
            newE   = sum(repmat(newC,N,1)./D.*R.^repmat(-newP,N,1),2) - 1;
            newMSE = mean(newE.^2);
            if newMSE < MSE && all(newP>1e-3) && all(abs(newC)>1e-3)
                P     = newP;
                C     = newC;
                E     = newE;
                MSE   = newMSE;
                lamda = lamda/1.1;
                break;
            elseif lamda > 1e8
                return;
            else
                lamda = lamda*1.1;
            end
        end
    end
end