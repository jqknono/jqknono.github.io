# 此工具完成以下功能:
# 1. 找到所有markdown(md)文件都未使用的图片, 移动到removed_img文件夹中
# 2. 所有在写md中添加的图片, 都移动到img文件夹
# 3. 所有md文件中引用图片的位置, 更新为img中图片的新位置
# 同时有以下限制:
# 1. md文件必须为utf-8编码才能处理

import os
from pathlib import Path
import re
from shutil import move

rootPATH = os.getcwd()

# 获取所有图片
pngDict = {}
for dp, dn, filenames in os.walk(rootPATH):
    for f in filenames:
        ext = os.path.splitext(f)[1].lower()
        if ext == '.png' or ext == '.jpg':
            relpath = os.path.join(dp, f)
            pngDict[f] = [relpath, 0]

# 遍历所有markdown文件
mds = [os.path.join(dp, f) for dp, dn, filenames in os.walk(rootPATH)
       for f in filenames if os.path.splitext(f)[1] == '.md']

# ![](2020-11-02-16-58-35.png)
pattern = re.compile("!\[[^\[\]]*\]\(.*?([^\\\/\)]*\.png)\)")
matchPatter = r"!\[(.*)\]\(.*?([^\\\/\)]+\.png)\)"


def get_depth(path, depth=0):
    if not os.path.isdir(path):
        return depth
    depth = path.count(os.sep)
    return depth


rootPATHDepth = get_depth(rootPATH)

pngRemovedToImg = []
pngRemovedToRemoved = []
nonUtf8Files = []

# 如果文件存在引用则hash标记为1, 复杂度O(m*n), m是文件总行数, n是图片总个数
for file in mds:
    try:
        with open(file, mode='r+', encoding='utf-8') as textfile:
            filetext = textfile.read()
            matches = re.findall(pattern, filetext)
            for match in matches:
                if match in pngDict:
                    pngDict[match][1] += 1
            path = os.path.dirname(file)
            relDepth = get_depth(path) - rootPATHDepth
            relDepthStr = '../' * relDepth
            replacePattern = r"![\1](./" + relDepthStr + r"img/\2)"

            # 所有引用图片的位置替换为img目录下的图片位置
            filetext = re.sub(matchPatter, replacePattern,
                              filetext, 0, flags=re.I)
            textfile.seek(0)
            textfile.write(filetext)
    except Exception as ex:
        nonUtf8Files.append(file)
        continue

for key, value in pngDict.items():
    if value[1] == 0:
        move(value[0], os.path.join('./removed_img', key))
        pngRemovedToRemoved.append(key)
    else:
        # 所有图片移动到img目录
        move(value[0], os.path.join('./img', key))
        pngRemovedToImg.append(key)


print('\n不是utf8编码:')
for item in nonUtf8Files:
    print(item)

print("\nRemove to removed_img:")
for item in pngRemovedToRemoved:
    print(item)

print("\nRemove to img:")
for item in pngRemovedToImg:
    print(item)

print('\n已完成')