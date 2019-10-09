##################################################################################
# index.py - Preprocessing functions for indexes
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
import re

# Local Imports
from .common import xmlns

# Configure Logging
from logging import getLogger
logger = getLogger()

def _preprocess_index(config):

    for i in config.root.xpath("//dion:term", namespaces=xmlns):
        index = lxml.etree.Element("{%s}indexterm" % xmlns['book'])
        index.text = i.text

        # Check for Subordinate Entries
        ddefs = i.xpath("..//dion:definition", namespaces=xmlns)
        if len(ddefs) > 1:
            counter = 0
            for ddef in ddefs:
                counter += 1
                ddef.set("counter", f"{counter}.")
        
        i.addnext(index)

    for i in config.root.xpath("//book:indexterm", namespaces=xmlns):
        terms = i.xpath(".//book:primary|.//book:secondary", namespaces=xmlns)

        if len(terms) > 0:
            i.set('{%s}type' % xmlns['dion'], "multi")
            for t in terms:
                text = t.xpath(".//text()")
                if len(text) > 0:
                    text = re.sub("[\*\-\s]", "", re.sub(" -\S+ -\S+$", "", ' '.join(text)))
                    t.set("{%s}sort" % xmlns['dion'], text)
        else:
            i.set('{%s}type' % xmlns['dion'], "single")
            text = i.xpath(".//text()")
            if len(text) > 0:
                text = re.sub("[\*\-\s]", "", ' '.join(text))
                i.set("{%s}sort" % xmlns['dion'], text)
# Process Term
def process_term(term):
    try:
        return ' '.join(term[0].xpath(".//text()", namespaces=xmlns)).lower()
    except:
        return None

# Process Index
def preprocess_index(config):
    """During build process, reads indexterms from document 
    to populate a <dion:compile type="index"/> blocks."""
    logger.debug("Compiling index terms")

    tmp_index = lxml.etree.Element("{%s}tmpindex" % xmlns['dion'])
    for term in config.root.xpath("//book:indexterm", namespaces=xmlns):

        text = term.xpath(".//text()", namespaces=xmlns)
        if len(text) > 0:
            text = re.sub("\*", "", ' '.join(text).lower())
            term.set("{%s}sort" % xmlns['dion'], text)



