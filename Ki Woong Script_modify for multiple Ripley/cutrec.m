% A function for cutting a square from entire data space
function [cutx,cuty] = cutrec(x,y)% Assume x,y are column vectors, length(x)=length(y)
% minx,maxx,miny,maxy form the desired rectangle
z = horzcat(x,y); 
% horizontal concatenation
disp(['Current [minx, maxx, miny, maxy] is ','[',num2str(min(x)) ', ' num2str(max(x)) ', ' num2str(min(y)) ', ' num2str(max(y)) '].'])
% dsiplay the the current window
while true
    % Select corner points of a rectangular region by clicking the mouse twice
    p = ginput(2);
    % Get the x and y corner coordinates as integers
    minx = min(floor(p(1)), floor(p(2))); %xmin
    maxx = max(ceil(p(1)), ceil(p(2)));   %xmax
    miny = min(floor(p(3)), floor(p(4))); %ymin
    maxy = max(ceil(p(3)), ceil(p(4)));   %ymax
    %minx = input('Enter desired minx: '); % Request user inputs
    %maxx = input('Enter desired maxx: ');
    %miny = input('Enter desired miny: ');
    %maxy = input('Enter desired maxy: ');
    if maxx > minx && maxy > miny ,break,end
    disp('You chose inappropriate values.');
end
z( z(:,1)<minx | z(:,1)>maxx | z(:,2)<miny | z(:,2)>maxy ,:) = [];
% delete row(s) if the first column is smaller than minx or greater than maxx
% or if the second column is smaller than miny or greater than maxy
cutx = z(:,1);
cuty = z(:,2);