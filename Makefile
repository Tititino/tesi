LCC=pdflatex
OPTIONS=[]

ifeq ($(LCC), lualatex)
	PRETEX="\pdfvariable suppressoptionalinfo 512\relax"
else ifeq ($(LCC), pdflatex)		# i can't find the forum answer with the other pretextes
	PRETEX="\pdftrailerid{}"
else ifeq ($(LCC), xetex)
	PRETEX="\special{pdf:trailerid [\
    <00112233445566778899aabbccddeeff>\
    <00112233445566778899aabbccddeeff>\
	]}"
else
	PRETEX="error"
endif

.PHONY: all draft clean
all: thesis.pdf riassunto.pdf

CHAPTERS=$(addprefix chapters/, $(addsuffix .tex, intro calculus implementation related-work testing conclusion))
APPENDIX=$(addprefix appendix/, $(addsuffix .tex, example))
FIGURES=$(addprefix figures/, $(addsuffix .tex, hp-calculus asy-calculus sync-calculus id-dec-calculus triadic-calculus))

thesis.pdf: thesis.tex thesis.sty $(CHAPTERS) $(APPENDIX) $(FIGURES)
	sed 's/OPTIONS/$(OPTIONS)/' thesis.tex > out.tex
	latexmk -pdf -$(LCC) -latexoption="-shell-escape" 	\
		-pretex=$(PRETEX)				\
		-usepretex					\
		out.tex				
	mv out.pdf thesis.pdf

riassunto.pdf: riassunto.tex
	latexmk -pdf -$(LCC) -latexoption="-shell-escape" 	\
		-pretex=$(PRETEX)				\
		-usepretex					\
		riassunto.tex				

clean:
	rm -f out.*
	latexmk -c
	rm -f *.tex.bak
	rm -f chapters/*.tex.bak
	cd chapters/ && latexmk -c

draft:
	$(LCC) -shell-escape thesis.tex
