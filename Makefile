LCC=pdflatex
BTX=bibtex

all:
	latexmk -interaction=nonstopmode -pdf -lualatex -latexoption="-shell-escape" thesis.tex

draft:
	$(LCC) -shell-escape thesis.tex
