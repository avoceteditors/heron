
all: compile-xslt install

install:
	python3 setup.py install --user

compile-xslt:
	heron -vd compile 
