function out = estBlockDistortionInd(hist_out)
%     y_sub_dct = reshape(y_sub_image, 8, 8)';
   
    distortion_out = zeros(8,8,255);
    
%         lumMat1 = [
%         16 11 10 16 24 40 51 61 ...
%         12 12 14 19 26 58 60 55 ...
%         14 13 16 24 40 57 69 56 ...
%         14 17 22 29 51 87 80 62 ...
%         18 22 37 56 68 109 103 77 ...
%         24 35 55 64 81 104 113 92 ...
%         49 64 78 87 103 121 120 101 ...
%         72 92 95 98 112 100 103 99];
%     weight = reshape(lumMat1, 8, 8)';
%     weight = 1.0./weight;
%     weight = weight/(sum(sum(weight)));
    
    for i = 1:1:8
        for j = 1:1:8
            nelements = hist_out{i,j}{1,1};
            ncenters = hist_out{i,j}{1,2};
            len = size(ncenters,2);
            for qpstep=1:255
                distortion = 0;
                for m = 1:len
%                 distortion = distortion + weight(i,j)*nelements(m)*((round(ncenters(m)/qpstep)*qpstep - ncenters(m))^2);

                   distortion = distortion + nelements(m)*((round(ncenters(m)/qpstep)*qpstep - ncenters(m))^2);
                   
                end
%                 distortion_out(i,j,qpstep)=weight(i,j)*distortion;
                distortion_out(i,j,qpstep)=distortion;
            end
        end
    end
    out = distortion_out;
end