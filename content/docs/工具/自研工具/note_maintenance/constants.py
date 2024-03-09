import os

rootPATH = os.getcwd()
NoteToolName = ''
NoteToolRootPath = os.path.join(rootPATH, NoteToolName)
GitbookFolderName = "gitbook"
removed_imgs_dirname = 'removed_imgs'
img_dirname = 'attachments'
removed_imgs_dir = os.path.join(NoteToolRootPath, img_dirname, removed_imgs_dirname)
img_dir = os.path.join(NoteToolRootPath, img_dirname)
gitbook_img_dir = os.path.join(
    NoteToolRootPath, GitbookFolderName, img_dirname)
exclude_folders = [".git-", "node_modules", ".docs", "_book", "images"]
img_exts = ['.jpg', '.png', '.gif', '.jpeg']