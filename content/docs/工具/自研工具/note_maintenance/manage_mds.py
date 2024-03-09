
import os
from constants import *

# 遍历所有markdown文件
mds = []
for dp, dn, filenames in os.walk(rootPATH):
    isExclude = False
    for folder in exclude_folders:
        if folder in dp:
            isExclude = True
            break
    if isExclude:
        continue
    for f in filenames:
        if os.path.splitext(f)[1] == '.md':
            f = os.path.join(dp, f) 
            mds.append(f)

# (\[[^\[\]]+?)\s([^\]]+\])
# $1$2
def remove_space_in_square_bracket(string:file):
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
                f"{img_dirname}/\\2)"
        else:
            relDepthStr = '../' * relDepth
            replacePattern = r"![\1](" + relDepthStr + \
                GitbookFolderName + '/' + f"{img_dirname}/\\2)"
        # 所有引用图片的位置替换为img目录下的图片位置
        filetext = re.sub(matchPatter, replacePattern,
                          filetext, 0, flags=re.I)
        textfile.seek(0)
        textfile.write(filetext)
        textfile.truncate()
    pass