# 此工具完成以下功能:
# 1. 找到所有markdown(md)文件都未使用的图片, 移动到removed_img文件夹中
# 2. 所有在写md中添加的图片, 都移动到img文件夹
# 3. 所有md文件中引用图片的位置, 更新为img中图片的新位置
# 同时有以下限制:
# 1. md文件必须为utf-8编码才能处理

import os
import re
from shutil import move
from constants import *

# 获取所有图片
pngs = {}
for dp, dn, filenames in os.walk(rootPATH):
    isExclude = False
    for folder in exclude_folders:
        if folder in dp:
            isExclude = True
            break
    if isExclude:
        dn[:] = []
        continue
    for f in filenames:
        ext = os.path.splitext(f)[1].lower()
        if ext in img_exts:
            relpath = os.path.join(dp, f)
            if f in pngs:
                # 删除重复图片
                os.remove(relpath)
            else:
                pngs[f] = [relpath, 0]

# 遍历所有markdown文件
mds = []
for dp, dn, filenames in os.walk(rootPATH):
    isExclude = False
    for folder in exclude_folders:
        if folder == dp:
            isExclude = True
            break
    if isExclude:
        continue
    for f in filenames:
        if os.path.splitext(f)[1] == '.md':
            f = os.path.join(dp, f)
            mds.append(f)

# ![1](2020-11-02-16-58-35.png)
# ![2](./2020-11-02-16-58-35.png)
# ![3](.\2020-11-02-16-58-35.png)
# ![4](..\2020-11-02-16-58-35.png)
# ![5](../2020-11-02-16-58-35.png)
# ![1](http://2020-11-02-16-58-35.png)
# ![1](https://2020-11-02-16-58-35.png)
# ![2](http:\\2020-11-02-16-58-35.png)
# ![filter example](../attachments/20220427153055.png)
pattern = r"!\[[^\[\]]*?\]\((?:(?!http).)*?([^\\\/\.]+?\.(png|jpg|gif|jpeg))\)"
matchPatter = r"!\[([^\[\]]*?)\]\((?:(?!http).)*?([^\\\/\.]+?\.(png|jpg|gif|jpeg))\)"


def get_depth(path: str):
    depth = 0
    if not os.path.isdir(path):
        return depth
    depth = path.count(os.sep)
    return depth


rootPATHDepth = get_depth(rootPATH)

pngsRemovedToImg = []
pngsRemovedToRemoved = []
nonUtf8Files = []

# 如果文件存在引用则hash标记为1, 复杂度O(m*n), m是文件总行数, n是图片总个数
for file in mds:
    try:
        # 获取编码格式
        # 很难判断, 放弃识别文本编码, 默认使用utf-8
        # with open(file, 'rb') as f:
        #     s = f.read()
        #     chatest = chardet.detect(s)
        #     print(chatest)

        with open(file, mode='r+', encoding='utf-8') as textfile:
            filetext = textfile.read()
            matches = re.findall(pattern, filetext)
            for match in matches:
                if match[0] in pngs:
                    pngs[match[0]][1] += 1
            path = os.path.dirname(file)
            relDepth = get_depth(path) - rootPATHDepth
            relDepthStr = ''
            replacePattern = ''
            if GitbookFolderName in file:
                relDepthStr = '../' * (relDepth - 1)
                replacePattern = r"![\1](" + relDepthStr + \
                    GitbookFolderName + '/' + f"{img_dirname}/\\2)"
            else:
                relDepthStr = '../' * relDepth
                replacePattern = r"![\1](" + relDepthStr + \
                    f"{img_dirname}/\\2)"

            # 所有引用图片的位置替换为img目录下的图片位置
            filetext = re.sub(matchPatter, replacePattern,
                              filetext, 0, flags=re.I)
            textfile.seek(0)
            textfile.write(filetext)
            textfile.truncate()
    except Exception as ex:
        nonUtf8Files.append(file)
        continue

for key, value in pngs.items():
    if value[1] == 0:
        move(value[0], os.path.join(removed_imgs_dir, key))
        pngsRemovedToRemoved.append(key)
    else:
        # 所有图片移动到img目录
        move(value[0], os.path.join(img_dir, key))
        pngsRemovedToImg.append(key)


print("\nRemove to removed_imgs:")
for item in pngsRemovedToRemoved:
    print(item)

print("\nRemove to img:")
for item in pngsRemovedToImg:
    print(item)

print('\n不是utf8编码:')
for item in nonUtf8Files:
    print(item)

print('\n已完成')
