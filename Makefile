
LCC=pdflatex


all:
	$(LCC) tesi.tex
	bibtex tesi.aux
	$(LCC) tesi.tex
