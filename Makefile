
HRN=heron

all: compile-xslt install

install:
	python3 setup.py install --user

compile-xslt:
	$(HRN) xslt heron/xslt/latex/latex.xml heron/xslt/latex.xsl
	$(HRN) xslt heron/xslt/web/web.xml heron/xslt/web.xsl
