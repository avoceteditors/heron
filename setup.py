from setuptools import setup

setup(
    name="heron",
    version="2019.3",
    packages=['heron'],
    package_data={'heron':['data/Makefile', 'data/*.xsl', 'data/*.sty']},
    scripts=['bin/heron'])
        

