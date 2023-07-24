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
        "---  There is this folder!  ---"

def doFormat(path, name):
    flagRed = 0
    flagGRN = 0
    pathRed = os.path.join(path, "Red.3dlp")
    pathGRN = os.path.join(path, "GRN.3dlp")
    if os.path.exists(pathRed):
        flagRed = 1
    if os.path.exists(pathGRN):
        flagGRN = 1

    if flagRed == 1 and flagGRN == 1:
        color_red = 1
        cha_grn = 2



def format2pcd(base, Range):
    for root, dirs, files in os.walk(base):
        for name in dirs:
            if name.isnumeric() and name in Range:
                print(name)
                print(os.path.join(root, name))
                format2pcd(os.path.join(root, name), name)

#  keep the r before '***'
father_path = r"C:/Users/tjut_/Desktop/test"  # now do not need to change '/' and '\' in path,
Range = input("Please input the ID of folder: ")
format2pcd(father_path, Range)