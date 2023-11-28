import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

df = pd.read_csv("C:/Users/scaactk/Desktop/20230828-1QW_2_crop2.csv", header=None, sep='\t')

for i in np.arange(0.1, 1.0, 0.1):
	print(i)
	X_train, X_test = train_test_split(df, test_size=i)
	print(len(X_train))
	# clustering = DBSCAN(eps=20, min_samples=4).fit(X_train)  # eps 200==20 in CLUS_DOC
	# labels = clustering.labels_
	#
	# n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)
	# n_noise_ = list(labels).count(-1)
	# print("Estimated number of clusters: %d" % n_clusters_)
	# print("Estimated number of noise points: %d" % n_noise_)
	raw = X_train[[0, 1]]
	raw.columns = ['Position X [nm]', 'Position Y [nm]']
	raw.astype(int)
	for j in range(4):
		raw.insert(j, j, 0)

	for j in range(6, 11):
		raw.insert(j, j, 0)

	raw.insert(11, 'Channel', 1)
	raw.insert(12, 'Z Slice', 1)
	raw.columns = ['Index', 'First Frame', 'Number Frames', 'Frames Missing', 'Position X [nm]',
	               'Position Y [nm]', 'Precision [nm]', 'Number Photons', 'Background variance',
	               'Chi square', 'PSF width [nm]', 'Channel', 'Z Slice']
	raw.astype(int)

	file_path = "C:/Users/scaactk/Desktop/data/20230828-1QW_2_crop2_%.1f.txt" % (1 - i)
	print(file_path)
	raw.to_csv(file_path, index=None, sep='\t')

	with open(file_path, 'a', encoding='utf-8') as file:
		file.write("\n"
		           "VoxelSizeX : 0.106\n\n"
		           "VoxelSizeY : 0.106\n\n"
		           "ResolutionY : 0.1000000000\n\n"
		           "SizeX : 5120\n\n"
		           "SizeY : 5120\n\n"
		           "ROI List : \n"
		           )

		print("OK")
