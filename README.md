# auto-latexdiff

`auto-latexdiff` compiles your LaTeX file as you are typing and creates a
differential PDF. It can be used to easily spot what you changed in your file
because it uses red and blue to mark the modification.

---

## Installation

All you have to do is to clone the repository and go there:

```
git clone https://github.com/xorob0/auto-latexdiff
cd auto-latexdiff
```

It's not difficult, is it?

---

## Usage

```
Usage: auto-latexdiff.sh [-hw] [-d OUTFILE] [DIR] [-f OUTFILE] [FILE]...
Compiles your LaTeX file as you are typing and creates a differential PDF.

    -d OUTFILE  specify the output directory (default to current)
    -f OUTFILE  specify the output file
    -h          display this help and exit
    -r INTEGER  specify the refresh time
    -w          compile without differential indications
```

The most classic case of use:

```
./auto-latexdiff -f latex_file
```

By default, `auto-latexdiff` will look for the LaTeX file in the current
tree. However, you can change the default folder very simply:

```
./auto-latexdiff -d ~/Documents/LaTeX/ -f latex_file
```

Similarly, you can change the compilation refresh when you make different
changes:

```
./auto-latexdiff -d ~/Documents/LaTeX/ -f latex_file -r 5
```

Finally, you can ignore the differential indicators with:

```
./auto-latexdiff -d ~/Documents/LaTeX/ -f latex_file -r 5 -w
```

---

## Functioning

The script constantly checks the `md5` of the given file. If it detects a
change, it will compile the file again with `xelatex` and `latexdiff`.

 `latexdiff` generates the differential by comparing the edited file
 with a cached version.

**NOTE:** you can guess that it only sees the change when the file is saved. If
you want the changes to appear as you type, enable your text editor's automatic
save function.
