function k = Ripknoedge_2(x,y,minx,maxx,miny,maxy,testpts,repeat,maxr,numr,X,Y)
k = zeros(repeat,numr);
M = horzcat(X,Y); % X,Y are used in distance calculation
h = waitbar(0,'Calculating Ripley...');
t_s = tic;
for ii = 1:repeat
    d = zeros(length(X)-1,testpts);
    idx = randperm(length(x),testpts);
    for i = 1:testpts
        MM = M;
        MM(M(:,1)==x(idx(i))&M(:,2)==y(idx(i)),:) = [];
        XX = MM(:,1);
        YY = MM(:,2);
        d(:,i) = ((XX-x(idx(i))).^2 + (YY-y(idx(i))).^2).^(0.5);
    end
    for j = 1:numr
        k(ii,j) = abs(maxy-miny)*abs(maxx-minx)*(sum(d(:) <= (j-1)*maxr/numr))/(length(x)*testpts); % (rectangular)data space? ignore edge effect
    end
    t_rem = floor((toc(t_s)/ii)*(repeat-ii));
    msg = ['Calculating Ripley... Remaining time (s) = ' num2str(floor( t_rem ))];
    waitbar(ii / repeat, h, msg)
end
close(h)