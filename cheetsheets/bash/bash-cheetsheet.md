# bash cheetsheet

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [bash cheetsheet](#-bash-cheetsheet-)
  - [Recommend](#-recommend-)
  - [Linux Bash Terminal Keyboard Shortcuts](#-linux-bash-terminal-keyboard-shortcuts-)

<!-- /code_chunk_output -->

## Recommend

Recommend to use [bash-cheetsheet](https://devhints.io/bash)

start with `set -euo pipefail` to check error.

- `-e`: Stop execution instantly as a query exits while having a non-zero status
- `-u`: This option causes the bash shell to treat unset variables as an error and exit immediately.
- `-o` pipefail: This option prevents errors in a pipeline from being masked. If any command in a pipeline fails, that return code will be used as the return code of the whole pipeline.

## Linux Bash Terminal Keyboard Shortcuts

| Shortcut                 | Action                                                                            | Shortcut          | Action                                                   |
| ------------------------ | --------------------------------------------------------------------------------- | ----------------- | -------------------------------------------------------- |
| **Bash Control/Process** |                                                                                   | **Bash Editing**  |                                                          |
| `Ctrl + L`               | Similar to clear command, clears the terminal screen                              | `Ctrl + U`        | Deletes before the cursor until the start of the command |
| `Ctrl + S`               | Stops command output to the screen                                                | `Ctrl + K`        | Deletes after the cursor until the end of the command    |
| `Ctrl + Z`               | Suspends current command execution and moves it to the background                 | `Ctrl + W`        | Removes the command/argument before the cursor           |
| `Ctrl + Q`               | Resumes suspended command                                                         | `Ctrl + D`        | Removes the character under the cursor                   |
| `Ctrl + C`               | Sends SIGI signal and kills currently executing command                           | `Ctrl + H`        | Removes character before the cursor                      |
| `Ctrl + D`               | Closes the current terminal                                                       | `Alt + D`         | Removes from the character until the end of the word     |
| **Bash Information**     |                                                                                   | `Alt + Backspace` | Removes from the character until the start of the word   |
| `TAB`                    | Autocompletes the command or file/directory name                                  | `Alt + . / Esc+.` | Uses last argument of previous command                   |
| `~TAB TAB`               | List all Linux users                                                              | `Alt + <`         | Moves to the first line of the bash history              |
| `Ctrl + I`               | Completes the command like TAB                                                    | `Alt + >`         | Moves to the last line of the bash history               |
| `Alt + ?`                | Display files/folders in the current path for help                                | `Esc + T`         | Switch between last two words before cursor              |
| `Alt + *`                | Display files/folders in the current path as parameter                            | `Alt + T`         | Switches current word with the previous                  |
| **Bash Navigation**      |
| `Ctrl + A`               | Move to the start of the command line                                             |
| `Ctrl + E`               | Move to the end of the command line                                               |
| `Ctrl + F`               | Move one character forward                                                        |
| `Ctrl + B`               | Move one character backward                                                       |
| `Ctrl + XX`              | Switch cursor position between start of the command line and the current position |
| `Ctrl + ] + x`           | Moves the cursor forward to next occurrence of x                                  |
| `Alt + F / Esc + F`      | Moves the cursor one word forward                                                 |
| `Alt + B / Esc + B`      | Moves the cursor one word backward                                                |
| `Alt + Ctrl + ] + x`     | Moves cursor to the previous occurrence of x                                      |
| **Bash History**         |
| `Ctrl + R`               | Incremental reverse search of bash history                                        |
| `Alt + P`                | Non-incremental reverse search of bash history                                    |
| `Ctrl + J`               | Ends history search at current command                                            |
| `Ctrl + _`               | Undo previous command                                                             |
| `Ctrl + P / Up arrow`    | Moves to previous command                                                         |
| `Ctrl + N / Down arrow`  | Moves to next command                                                             |
| `Ctrl + S`               | Gets the next most recent command                                                 |
| `Ctrl + O`               | Runs and re-enters the command found via Ctrl + S and Ctrl + R                    |
| `Ctrl + G`               | Exits history search mode                                                         |
| `!!`                     | Runs last command                                                                 |
| `!*`                     | Runs previous command except its first word                                       |
| `!*:p`                   | Displays what !\* substitutes                                                     |
| `!x`                     | Runs recent command in the bash history that begins with x                        |
| `!x:p`                   | Displays the x command and adds it as the recent command in history               |
| `!$`                     | Same as OPTION+., brings forth last argument of the previous command              |
| `!^`                     | Substitutes first argument of last command in the current command                 |
| `!$:p`                   | Displays the word that !$ substitutes                                             |
| `^123^abc`               | Replaces 123 with abc                                                             |
| `!n:m`                   | Repeats argument within a range (i.e, m 2-3)                                      |
| `!fi`                    | Repeats latest command in history that begins with fi                             |
| `!n`                     | Run nth command from the bash history                                             |
| `!n:p`                   | Prints the command !n executes                                                    |
| `!n:$`                   | Repeat arguments from the last command (i.e, from argument n to $)                |

图片下载保存, 可设置为终端背景, [下载链接](http://jn-image-bed-cdn.jqknono.com/bash-cheetsheet_65852d39dfedf41777f7f118dbbfc134ffdeab65869a45b2e291e8b452b3ad01.png)

## bash-completion

命令行自动补全.

https://github.com/scop/bash-completion

bash-completion is a collection of command line command completions for the Bash shell, collection of helper functions to assist in creating new completions, and set of facilities for loading completions automatically on demand, as well as installing them.
