path = "C:\Users\tjut_\Desktop\coordinates.txt";
fid = fopen(path);
str = fgetl(fid);
str
str = fgetl(fid);
str
str = fgetl(fid);
str

s = regexp(str, '\t', 'split')
%{'roi1'}    {'1'}    {'140'}    {'8496'}    {'4901'}    {'8496'}    {'4901'}    {'3736'}    {'140'}    {'3736'}

x_dis = abs(str2num(char(s{6}))-str2num(char(s{2})) /0.106)
y_dis = abs(str2num(char(s{7}))-str2num(char(s{3})) /0.106)
area = x_dis*y_dis