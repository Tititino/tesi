LCC=pdflatex
BTX=bibtex

all:
	$(LCC) -shell-escape thesis.tex
	$(BTX) thesis.aux
	$(LCC) -shell-escape thesis.tex
	$(LCC) -shell-escape thesis.tex

draft:
	$(LCC) -shell-escape thesis.tex
