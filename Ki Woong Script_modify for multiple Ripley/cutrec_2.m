% A function for cutting a square from entire data space
function [cutx,cuty] = cutrec_2(x,y)% Assume x,y are column vectors, length(x)=length(y)
% minx,maxx,miny,maxy form the desired rectangle
z = horzcat(x,y); 
% horizontal concatenation
disp(['Current [minx, maxx, miny, maxy] is ','[',num2str(min(x)) ', ' num2str(max(x)) ', ' num2str(min(y)) ', ' num2str(max(y)) '].'])
% dsiplay the the current window
while true
    % Select a rectangular section 
    p = getrect;%ginput(2);
    % Get the x and y corner coordinates as integers
    minx = floor(p(1)); %xmin
    maxx = ceil(p(1)+p(3));   %xmax
    miny = floor(p(2)); %ymin
    maxy = ceil(p(2)+p(4));   %ymax
    if maxx > minx && maxy > miny ,break,end
    disp('You chose inappropriate values.');
end
z( z(:,1)<minx | z(:,1)>maxx | z(:,2)<miny | z(:,2)>maxy ,:) = [];
% delete row(s) if the first column is smaller than minx or greater than maxx
% or if the second column is smaller than miny or greater than maxy
cutx = z(:,1);
cuty = z(:,2);