from distutils.core import setup
import pathlib
import re

# Configure Package Names
packages = [
    "heron",
    "heron.build",
    "heron.build.xml",
    "heron.stats"
]
package_dirs = {}

for package in packages:
    package_dirs[package] = re.sub("\.", "/", package)

# Configure Scripts
scripts_dir = pathlib.Path("scripts")
scripts =[]

for i in scripts_dir.glob("*"):
    scripts.append(str(i))


# Initialize Library
setup(
    name="heron",
    version="2020.2",
    packages=packages,
    package_dir=package_dirs,
    scripts=scripts,
    package_data={'heron':['data/Makefile', 'data/*.xsl', 'data/*.sty', 'xslt/*.xsl', 'tex/*']},
)
        

