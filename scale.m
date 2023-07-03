function out =scale(quant)
    aanScale = [1.0 1.387039845 1.306562965 1.175875602 1.0 0.785694958 0.541196100 0.275899379];
   % index = 1;
    for i = 1:8
        for j = 1:8
            div(i,j) =  quant(i,j) / (aanScale(i) * aanScale(j) * 8.0);
          %  index=index + 1;
        end
    end
    out = div;
end