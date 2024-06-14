LCC=lualatex

.PHONY: all draft
all:
	latexmk -interaction=nonstopmode -pdf -$(LCC) -latexoption="-shell-escape" thesis.tex

draft:
	$(LCC) -shell-escape thesis.tex
