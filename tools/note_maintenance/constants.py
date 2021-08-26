import os

rootPATH = os.getcwd()
NoteToolName = ''
NoteToolRootPath = os.path.join(rootPATH, NoteToolName)
GitbookFolderName = "gitbook"
removed_imgs_dirname = 'removed_imgs'
removed_imgs_dir = os.path.join(NoteToolRootPath, removed_imgs_dirname)
img_dirname = 'imgs'
img_dir = os.path.join(NoteToolRootPath, img_dirname)
gitbook_img_dir = os.path.join(
    NoteToolRootPath, GitbookFolderName, img_dirname)
exclude_folders = [".git", "node_modules", ".docs", "_book"]
img_exts = ['.jpg', '.png', '.gif', '.jpeg']