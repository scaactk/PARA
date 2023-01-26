import os
import re
import shutil

r = os.walk('./')
root, dirs, files = next(r)  # generator
flag_after = 0
flag_before = 0
while True:
    for folders in dirs:  # 遍历所有文件夹
        x = folders.split('_')  # 分割文件夹名
        if x[0].isnumeric():  # 判断是否数字开头
            if x[1] == 'before' and flag_after == 0:  # 先执行before
                flag_before = 1
                b = os.walk(folders)
                _, _, files = next(b)
                len_b = len(files)
                # rename
                number_before = 0
                for item in files:
                    temp = re.split(r"[_|.]", item)  # regex
                    new_name = x[0] + '_' + str(number_before) + '.' + temp[-1]  # 新文件名
                    number_before = number_before + 1

                    # print(temp2)
                    raw_path = os.path.join('./', folders, item)
                    # print(raw_path)
                    target_path = os.path.join('./', 'target')
                    # print(target_path)

                    target_folder = os.path.exists(target_path)  # 判读文件夹是否存在
                    if not target_folder:  # 判断是否存在文件夹如果不存在则创建为文件夹
                        os.makedirs(target_path)

                    shutil.copy(raw_path, target_path)  # 先复制过去
                    os.rename(os.path.join(target_path, item), os.path.join(target_path, new_name))  # 再改名


            elif x[1] == 'after' and flag_before == 1:  # 先解决before\
                flag_after = 1
                a = os.walk(folders)
                _, _, files = next(a)
                # rename
                number_after = len_b
                for item in files:
                    temp = re.split(r"[_|.]", item)  # regex
                    new_name = x[0] + '_' + str(number_after) + '.' + temp[-1]  # 新文件名
                    print("after   :", new_name)
                    number_after = number_after + 1

                    # print(temp2)
                    raw_path = os.path.join('./', folders, item)
                    # print(raw_path)
                    target_path = os.path.join('./', 'target')
                    # print(target_path))

                    shutil.copy(raw_path, target_path)  # 先复制过去
                    os.rename(os.path.join(target_path, item), os.path.join(target_path, new_name))  # 再改名

    if flag_after == 1 and flag_before == 1:
        break

print("ok")
