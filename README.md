Put this script in the same directory as your latex file and edit the variables.
Lauch it with make loop.
Open your tex file and the diff.pdf side by side.

How it woks :
It compares the md5 of your file and the last one it generated. If the file are different it generate a new diff.pdf with latexdiff.

You can use the make file to clean the directory and you can even use it with :!make clean inside vim to reset dff.pdf.
