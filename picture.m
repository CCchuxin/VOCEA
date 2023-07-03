function p() 
figure;
    y1 = 3;
    y2 = 1.5;
    y3 = 1.5;
    y4 = 1.5;
    % bar(x,y);
    hold on
    bar(0.2,y1,0.1)
    hold on
    bar(0.6,y2,0.1)
    hold on
    bar(1,y3,0.1)
    hold on
    bar(1.4,y4,0.1)
    
    RDOEA10 = load('DSSresult/kodim04_10rdoea.txt');
    RDOEA30 = load('DSSresult/kodim04_30rdoea.txt');
    RDOEA50 = load('DSSresult/kodim04_50rdoea.txt');
    CRDOEA10 = load('DSSresult/kodim04_10crdoea.txt');
    CRDOEA30 = load('DSSresult/kodim04_30crdoea.txt');
    CRDOEA50 = load('DSSresult/kodim04_50crdoea.txt');
%     plot(RDOEA10(:,1),RDOEA10(:,2),'^b');
%     hold on;
%     plot(RDOEA30(:,1),RDOEA30(:,2),'*r');
%     hold on;
%     plot(RDOEA50(:,1),RDOEA50(:,2),'og');

  plot(CRDOEA10(:,1),CRDOEA10(:,2),'^b');
    hold on;
    plot(CRDOEA30(:,1),CRDOEA30(:,2),'*r');
    hold on;
    plot(CRDOEA50(:,1),CRDOEA50(:,2),'og');
end