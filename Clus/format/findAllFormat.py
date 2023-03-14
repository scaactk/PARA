# coding=utf-8

import pandas as pd
import numpy as np
import os


def mymkdir(path):
    folder = os.path.exists(path)

    if not folder:  # 判断是否存在文件夹如果不存在则创建为文件夹
        os.makedirs(path)  # makedirs 创建文件时如果路径不存在会创建这个路径
        print
        "---  new folder...  ---"
        print
        "---  OK  ---"

    else:
        print
        "---  There is this folder!  ---"


def doFormat(path, name):
    # Only read 2 cols
    # check if the file exists
    flagRed = 0
    flagGRN = 0
    pathRed = os.path.join(path, "Red.3dlp")
    pathGRN = os.path.join(path, "GRN.3dlp")
    if os.path.exists(pathRed):
        flagRed = 1
    if os.path.exists(pathGRN):
        flagGRN = 1

    if flagRed == 1 and flagGRN == 1:
        channel_red = 2
        channel_grn = 1
    elif (flagRed * flagGRN) == 0:  # if only one input file, mark its channel as 1
        channel_red = 1
        channel_grn = 1
    if flagRed == 0 and flagGRN == 0:  # cannot find any input file
        print("error in find input file")
        exit()

    if flagRed == 1:  # red exist
        rawRed = pd.read_csv(os.path.join(path, "Red.3dlp"), skiprows=0, header=None, sep='   ', usecols=[0, 1])
        rawRed.columns = ['Position X [nm]', 'Position Y [nm]']
        rawRed.astype(int)

        for i in range(4):
            rawRed.insert(i, i, 0)

        for i in range(6, 11):
            rawRed.insert(i, i, 0)

        rawRed.insert(11, 'Channel', channel_red)
        rawRed.insert(12, 'Z Slice', 1)
        rawRed.columns = ['Index', 'First Frame', 'Number Frames', 'Frames Missing', 'Position X [nm]',
                          'Position Y [nm]', 'Precision [nm]', 'Number Photons', 'Background variance',
                          'Chi square', 'PSF width [nm]', 'Channel', 'Z Slice']
        rawRed.astype(int)

    # Same to GRN

    if flagGRN == 1:  # grn exist
        rawGRN = pd.read_csv(os.path.join(path, "GRN.3dlp"), skiprows=0, header=None, sep='   ', usecols=[0, 1])
        rawGRN.columns = ['Position X [nm]', 'Position Y [nm]']
        rawGRN.astype(int)

        for i in range(4):
            rawGRN.insert(i, i, 0)

        for i in range(6, 11):
            rawGRN.insert(i, i, 0)

        rawGRN.insert(11, 'Channel', channel_grn)
        rawGRN.insert(12, 'Z Slice', 1)
        rawGRN.columns = ['Index', 'First Frame', 'Number Frames', 'Frames Missing', 'Position X [nm]',
                          'Position Y [nm]', 'Precision [nm]', 'Number Photons', 'Background variance',
                          'Chi square', 'PSF width [nm]', 'Channel', 'Z Slice']
        rawGRN.astype(int)

    # --------------------------------------------------------------------
    if flagRed == 1 and flagGRN == 1:
        total = pd.concat([rawGRN, rawRed], axis=0)
    elif flagRed == 1 and flagGRN == 0:
        total = rawRed
    elif flagRed == 0 and flagGRN == 1:
        total = rawGRN
    else:
        print("error in find input file")
        exit()
    # print(total.head())

    filename = str(name) + '.txt'
    clus_doc_file_path = os.path.join(path, 'clus_doc_file')
    mymkdir(clus_doc_file_path)
    output_path = os.path.join(clus_doc_file_path, filename)
    total.to_csv(output_path, index=None, sep='\t')

    with open(os.path.join(clus_doc_file_path, filename), 'a', encoding='utf-8') as file:
        file.write("\n"
                   "VoxelSizeX : 0.106\n\n"
                   "VoxelSizeY : 0.106\n\n"
                   "ResolutionY : 0.1000000000\n\n"
                   "SizeX : 5120\n\n"
                   "SizeY : 5120\n\n"
                   "ROI List : \n"
                   )

    print("OK")


def findAllFile(base, Range):  # 20220911
    for root, dirs, files in os.walk(base):
        for name in dirs:
            if name.isnumeric() and name in Range:
                print(name)
                print(os.path.join(root, name))
                doFormat(os.path.join(root, name), name)


#  keep the r before '***'
father_path = r"C:/Users/tjut_/Desktop/20220911"  # now do not need to change '/' and '\' in path,
Range = input("Please input the ID of folder: ")
findAllFile(father_path, Range)
