function out = getDCT(in)
    aanScale = [1.0 1.387039845 1.306562965 1.175875602 1.0 0.785694958 0.541196100 0.275899379];
   outputData=zeros(8,8);
    for i = 1:8
        for j = 1:8
            outputData(i,j) = in(i, j)/(aanScale(i) * aanScale(j) * 8.0);
        end
    end
   
    out = outputData;
end