function k = Hop_2(x,y,minx,maxx,miny,maxy,testpts,repeat) % Assume x,y are vertical vectors, len(x)=len(y)
z = horzcat(x,y);
I = zeros(1,repeat);
P = zeros(1,repeat);
k = zeros(1,repeat);
ran = horzcat(unifrnd(minx,maxx,length(x),1), unifrnd(miny,maxy,length(x),1));
h = waitbar(0,'Calculating Hopkins...');
t_s = tic;
for j = 1:repeat
    I(j) = 0;
    P(j) = 0;
    idx = randperm(length(x),testpts);
    for i = 1:testpts
        zz = z;
        zz(idx(i),:) = [];
        [~,DI] = knnsearch(zz,z(idx(i),:));
        I(j) = I(j) + DI;
        ranz = ran;
        ranz(idx(i),:) = [];
        [~,DP] = knnsearch(ranz,ran(idx(i),:));
        P(j) = P(j) + DP;
    end
    k(j) = (P(j))^2/((P(j))^2+I(j)^2);
    t_rem = floor((toc(t_s)/j)*(repeat-j));
    msg = ['Calculating Hopkins... Remaining time (s) = ' num2str(floor( t_rem ))];
    waitbar(j / repeat, h, msg)
end
close(h) 