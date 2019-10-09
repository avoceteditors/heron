
from shutil import copyfile
import pkg_resources
import pathlib

def run_init(args):

    make = pkg_resources.resource_filename("heron", "data/Makefile")

    target = pathlib.Path("Makefile")

    if args.force or not target.exists():
        copyfile(make, target)


