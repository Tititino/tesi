LCC=pdflatex

all:
	texliveonfly tesi.tex
	bibtex tesi.aux
	texliveonfly tesi.tex
	texliveonfly tesi.tex

draft:
	$(LCC) -draftmode tesi.tex
