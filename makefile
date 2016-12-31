filename=Latex1

pdf:
	pdflatex ${filename}.tex

read:
	zathura ${filename}.pdf &

clean:
	rm -f ${filename}.{ps,pdf,md5,log,aux,out,dvi,bbl,blg} &
	rm -f .original.{ps,tex,md5,pdf,log,aux,out,dvi,bbl,blg}
	rm -f diff.{ps,tex,md5,pdf,log,aux,out,dvi,bbl,blg}

loop:
	sh latexmaker.sh
	echo "test"
