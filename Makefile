all: html/index.html pdf/nlpwp.pdf

XML=xml/nlpwp.xml \
	xml/chap-words.xml \
	xml/chap-ngrams.xml

BOOKXML=xml/nlpwp.xml

html/index.html: $(XML)
	xmlto -o html/ -x xsl/html-chunk.xsl --skip-validation html $(BOOKXML)

pdf/nlpwp.fo: $(XML)
	xmlto -o pdf/ --skip-validation fo $(BOOKXML)

%.pdf: %.fo
	fop $< $@
