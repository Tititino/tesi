LCC=pdflatex

all:
	$(LCC) -shell-escape tesi.tex
	bibtex tesi.aux
	$(LCC) -shell-escape tesi.tex
	$(LCC) -shell-escape tesi.tex

draft:
	$(LCC) -draftmode tesi.tex
