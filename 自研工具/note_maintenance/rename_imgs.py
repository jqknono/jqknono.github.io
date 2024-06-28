# 本工具重命名md文件中引用的图片名, 以及对应的图片文件名, 使之仍然一一对应
import os
import hashlib
import re
from typing import Generic
import sys


filename = 'foo.md'
img_folder = './img/media'

img_exts = ['.jpg', '.png', '.gif', '.jpeg']

pngs = {}

def GetImgHash(filename: str) -> str:
    hash_md5 = hashlib.md5()
    with open(filename, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


def RenameImg(dp: str, old_name: str, new_name: str):
    old_name = os.path.join(dp, old_name)
    new_name = os.path.join(dp, new_name)
    os.rename(old_name, new_name)


def GetAllPngs(path: str):
    for node in os.walk(path):
        # dp, dn, filenames
        for file in node[2]:
            ext = os.path.splitext(file)[1].lower()
            if ext in img_exts:
                hash = GetImgHash(os.path.join(node[0], file))
                pngs[file] = hash[:32] + ext
                RenameImg(node[0], file, pngs[file])


def my_replacement(match: re.Match) -> str:
    groups = match.groups()
    origin_name = groups[0]
    new_name = groups[1]
    if groups[1] in pngs:
        new_name = pngs[groups[1]]
    replacement = f"![{origin_name}]({new_name})"
    return replacement


def RenameImgLinkInMd(file: str):
    try:
        matchPatter = r"!\[([^\[\]]*?)\]\(.*?([^\\\/\.]+?\.(png|jpg|gif|jpeg))\)"
        with open(file, mode='r+', encoding='utf-8') as textfile:
            filetext = textfile.read()
            print("open " + filename)

            # 所有引用图片的位置替换为img目录下的图片位置
            filetext = re.sub(matchPatter, my_replacement,
                              filetext, 0, flags=re.I)
            textfile.seek(0)
            textfile.write(filetext)
            textfile.truncate()
    except Exception as ex:
        print(ex.__cause__)


if __name__ == "__main__":
    rootPATH = str(sys.argv[1])
    img_folder = os.path.join(rootPATH, img_folder)
    GetAllPngs(img_folder)
    # filename = os.path.join(rootPATH, filename)
    filename = str(sys.argv[2])
    print(img_folder)
    print(filename)
    RenameImgLinkInMd(filename)