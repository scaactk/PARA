import pandas as pd
import os


def mymkdir(path):
    folder = os.path.exists(path)

    if not folder:
        os.makedirs(path)
        print
        "---  new folder...  ---"
        print
        "---  OK  ---"

    else:
        print
        "---  Already have this folder!  ---"


def doFormat(path, name):
    global raw_GRN, raw_RED
    flagRED = 0
    flagGRN = 0
    pathRED = os.path.join(path, "Red.3dlp")
    pathGRN = os.path.join(path, "GRN.3dlp")
    if os.path.exists(pathRED):
        flagRED = 1
    if os.path.exists(pathGRN):
        flagGRN = 1

    color_RED = 4294901760
    color_GRN = 4278255360
    if flagRED == 1:
        raw_RED = pd.read_csv(os.path.join(path, "Red.3dlp"), skiprows=0, header=None, sep='\s+', usecols=[0, 1, 2])
        raw_RED.columns = ['X', 'Y', 'Z']

        raw_RED.insert(3, 'RGB', color_RED)
        raw_RED.astype(float)
        # print(raw_RED.head())

    if flagGRN == 1:
        raw_GRN = pd.read_csv(os.path.join(path, "GRN.3dlp"), skiprows=0, header=None, sep='\s+', usecols=[0, 1, 2])
        raw_GRN.columns = ['X', 'Y', 'Z']

        raw_GRN.insert(3, 'RGB', color_GRN)
        raw_GRN.astype(float)
        # print(raw_GRN.head())

    total = pd.DataFrame()
    if flagRED * flagGRN == 1:
        total = pd.concat([raw_RED, raw_GRN])
    elif flagRED == 1 and flagGRN == 0:
        total = raw_RED
    elif flagRED == 0 and flagGRN == 1:
        total = raw_GRN
    else:
        print("error in find input file")
        exit()

    print(total.head())
    print(total.shape[0])

    # output
    filename = str(name) + '.pcd'
    output_path = os.path.join(path, filename)
    with open(output_path, 'w', encoding='utf-8') as file:
        file.write("# .PCD v0.7 - Point Cloud Data file format\n"
                   "VERSION 0.7\n"
                   "FIELDS x y z rgb\n"
                   "SIZE 4 4 4 4\n"
                   "TYPE F F F F\n"
                   "COUNT 1 1 1 1\n"
                   "WIDTH ")
        file.write(str(total.shape[0]) + "\n"
                   + "HEIGHT 1\n"
                   + "VIEWPOINT 0 0 0 1 0 0 0\n"
                   + "POINTS "
                   + str(total.shape[0]) + "\n"
                   + "DATA ascii\n"
                   )
    total.to_csv(output_path, mode='a', index=None, header=None, sep=' ')
    print("OK")


def format2pcd(base, Range):
    for root, dirs, files in os.walk(base):
        for name in dirs:
            if name.isnumeric() and name in Range:
                print(name)
                print(os.path.join(root, name))
                doFormat(os.path.join(root, name), name)


#  keep the r before '***'
father_path = r"C:/Users/tjut_/Desktop/test"  # now do not need to change '/' and '\' in path,
Range = input("Please input the ID of folder: ")
format2pcd(father_path, Range)
