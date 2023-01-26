% h = animatedline;
% axis([0 4*pi -1 1])
% x = linspace(0,4*pi,10000);
% 
% for k = 1:length(x)
%     y = sin(x(k));
%     addpoints(h,x(k),y);
%     drawnow limitrate
% end
% drawnow

c = load("test.mat")
x = c.contour(:,1)
y = c.contour(:,2)
[X,Y] = meshgrid(x,y)
contour(X, Y, 1)