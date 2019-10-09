##################################################################################
# tex.py - Tool for running LaTeX
#
# Copyright (c) 2019, Kenneth P. J. Dyer <kenneth@avoceteditors.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the copyright holder nor the name of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
##################################################################################


# Module Imports
import os
import pathlib
import pkg_resources
import subprocess
from shutil import copyfile

def run_latex(args):
    cwd = pathlib.Path('.')


    # Makedir
    image_target = args.output_latex.joinpath('images') 
    image_source = pathlib.Path('images')
    if image_source.exists():
        if not image_target.exists():
            image_target.mkdir()

        subprocess.run(["cp", "-r", "images/*", str(image_target)])

    # Copy Sty
    sty = args.output_latex.joinpath("dion.sty")
    if not sty.exists() or args.force:
        dpath = pkg_resources.resource_filename('heron', 'data/dion.sty')
        copyfile(dpath, sty)


    # Build Index 
    for path in args.output_latex.glob("*.tex"):
        index = pathlib.Path("%s/%s.ind" % (args.output_latex, path.stem))

        command = ["makeindex", path.stem]
        subprocess.Popen(' '.join(command), shell=True, cwd=path.parent)
        

    # Build Latex
    command = [args.latex, "--output-directory=%s" % str(args.output_latex)]

    if args.target is None:
        for target in args.output_latex.glob("*.tex"):
            subprocess.run(command + [str(target)])
    else:
        subprocess.run(command + [args.output.joinpath("%s.tex" % args.target)])

    for i in args.output_latex.glob("*.pdf"):
        subprocess.run(["cp", i, args.output])




