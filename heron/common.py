##################################################################################
# common.py - Common XML functions
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
import pathlib

# Configure Logger
from logging import getLogger
logger = getLogger()



# Namespace Configuration
xmlns = {
    "xml": "http://www.w3.org/XML/1998/namespace",
    "book": "http://docbook.org/ns/docbook",
    "xi": "http://www.w3.org/2001/XInclude",
    "xsl": "http://www.w3.org/1999/XSL/Transform",
    "xlink": "http://www.w3.org/1999/xlink",
    "dion": "http://avoceteditors.com/xml/dion"
}
xmlrns = {v: k for k, v in xmlns.items()}

# Read dion:includes
def read_dincs(element, path, xslt=False):
    """Compiles dion:includes, adding to element"""
    pattern = element.attrib['src']

    # Reading Pattern
    for i in path.glob(pattern):
        try:
            doc = lxml.etree.parse(str(i))
            
            # Process XIncludes
            doc.xinclude()

            doctree = doc.getroot()

            # Process dion:includes
            for dinc in doctree.xpath("//dion:include", namespaces=xmlns):
                read_dincs(dinc, i.parent)


            # Add XSLT Templates
            if xslt:
                templates =  doctree.xpath("xsl:template", namespaces=xmlns)

                for temp in templates:
                    element.addprevious(temp)
            else:
                # Fetch modtime
                mtime = i.stat().st_mtime
                
                doctree.set("{%s}include" % xmlns['dion'], "yes")
                doctree.set("{%s}path" % xmlns['dion'], str(i))
                doctree.set("{%s}mtime" % xmlns['dion'], f'{mtime}')


                element.addnext(doctree)

        except Exception as e:
            logger.warn(f"Unable to read file '{i}': {e}")



# Process dion:include
def process_dincs(path, doc, xslt=False):
    logger.debug("Checking for dion:includes")

    dincs = doc.getroot().xpath("//dion:include", namespaces=xmlns)

    if len(dincs) == 0:
        logger.debug("No dion:includes found")
    else:
        logger.debug("Found dion:includes")
        for dinc in dincs:
            read_dincs(dinc, path, xslt)


def remove_dincs(doc):
    for dinc in doc.getroot().xpath("//dion:include", namespaces=xmlns):
        doc.getroot().remove(dinc)
