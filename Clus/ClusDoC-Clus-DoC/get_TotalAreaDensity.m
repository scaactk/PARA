% we need to modify the path
path = "C:\Users\tjut_\Desktop\PARA\Clus\20220911\test\DBSCAN Results\Ch1\";
raw_file = load(strcat(path,'DBSCAN_Cluster_Result.mat'));
ROIs = raw_file.ClusterSmoothTable;

TAD = [];
for i = 1:length(ROIs)
    temp = ROIs(i);
    temp = temp{1,1}{1,1};
    TAD(i) = temp.TotalAreaDensity;
end
TAD = TAD'
writematrix(TAD, strcat(path, 'TAD.csv'), Delimiter=',')