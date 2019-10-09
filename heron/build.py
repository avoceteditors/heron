##################################################################################
# build.py - Contains functions for building projects
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
import lxml.etree
import pkg_resources
import sys

# Local Imports
from .common import xmlns
from .lex import build_lexica

# Local Imports
from .updates import update

# Configure Logger
from logging import getLogger
logger = getLogger()

def run_build(args):
    logger.info("Called build operation")

    # Update
    logger.debug("Updating cache")
    update(args)

    # Set Quotes
    for quote in args.root.xpath("//book:quote", namespaces=xmlns):
        quote.set("role", args.quotes)

    # Initialize Transformers 
    try:
        if args.type in ["book", "books"]:
            xslt_path = pkg_resources.resource_filename('heron', 'data/book.xsl')
            xslt = lxml.etree.parse(xslt_path)
            transformer = lxml.etree.XSLT(xslt)
            target = "book:book"
            ext = "tex"
        else:
            logger.warn(f"Unknown build type: {args.type}")
            sys.exit(1)
    except Exception as e:
        logger.critical(f"Error initializing XSLT transformer: {e}")
        sys.exit(1)


    # Find Targets
    targets = args.root.xpath("//%s" % target, namespaces=xmlns)

    if args.type in ['book', 'chapter']:
        targets = [targets[0]]
    elif args.target is not None:
        targets = args.root.xpath('//[@xml:id="%s"]' % args.target, namespaces=xmlns)

    # Transform Documents
    for target in targets:

        try:

            # Check for Index Terms
            if len(target.xpath(".//book:indexterm", namespaces=xmlns)) > 0:
                target.set("{%s}index" % xmlns['dion'], "yes")

            # Compile Reference
            for comp in target.xpath(".//dion:compile", namespaces=xmlns):
                build_lexica(args, target, comp)


            # XSLT Process Document
            idref = target.attrib["{%s}id" % xmlns['xml']]
            doc = transformer(target)

            # Write Output
            path = args.output_latex.joinpath(f"{idref}.{ext}")
            if not path.parent.exists():
                path.mkdirs(parents=True)

            with open(path, 'wb') as f:
                f.write(doc)

        except Exception as e:
            logger.error(f"Issue during transform: {e}")

    


