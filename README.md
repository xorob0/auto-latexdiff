This is a script to put on the same directory as your latex file. It keep generating and comparing md5 and when the md5 change it will regenerate a diff.tex and a diff.pdf. Open this and your vim side by side (with vim-auto-save) and you will see realtime edition happen on your pdf.
The makefile is there to clean the directory easier. You can also do :!make clean inside vim to clean the diff.pdf.
