import os

cwd = os.getcwd()
cwd = r"E:\code\jqknono.github.io"
base_wd = os.path.join(cwd, "content")

for root, dirs, files in os.walk(base_wd):
    for file in files:
        if file.endswith(".md"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                lines = f.readlines()

            if len(lines) == 0 or not lines[0].startswith("---"):
                # if the first line is not start with '---', then add title to the file
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write("---\n")
                    f.write("title: " + file[:-3] + "\n")
                    f.write("---\n")
                    f.write("\n")
                    f.writelines(lines)