
function out = quantize(in, code)

    global divLumMatrix;
    global divChromMatrix;
    if strcmp(code, 'lum')
       outputData = round(in .*  divLumMatrix);
    elseif strcmp(code, 'chrom')
       outputData = round(in .*  divChromMatrix);
    end     
    out = outputData;
end