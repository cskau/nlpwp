all: html/index.html pdf/nlpwp.pdf

BOOKXML=xml/nlpwp.xml

html/index.html:
	xmlto -o html/ -x xsl/html-chunk.xsl --skip-validation html $(BOOKXML)

pdf/nlpwp.fo:
	xmlto -o pdf/ --skip-validation fo $(BOOKXML)

%.pdf: %.fo
	fop $< $@
