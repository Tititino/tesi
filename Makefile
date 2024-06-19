LCC=lualatex
OPTIONS=[]

ifeq ($(LCC), lualatex)
	PRETEX="\pdfvariable suppressoptionalinfo 512\relax"
else ifeq ($(LCC), pdflatex)		# i can't find the forum answer with the other pretextes
	PRETEX="error"
else
	PRETEX="error"
endif

.PHONY: all draft clean
all:
	sed 's/OPTIONS/$(OPTIONS)/' thesis.tex > out.tex
	latexmk -interaction=nonstopmode -pdf -$(LCC) -latexoption="-shell-escape" 	\
		-pretex=$(PRETEX)							\
		-usepretex out.tex
	mv out.pdf thesis.pdf

clean:
	rm out.*
	latexmk -c

draft:
	$(LCC) -shell-escape thesis.tex
