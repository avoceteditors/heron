##################################################################################
# lex.py - Functions to preprocess reference
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
import copy
import operator
import lxml.etree
import re

# Local Imports
from .common import xmlns

# Logging Configuration
from logging import getLogger
logger = getLogger()

def fetch_title(titles):
    title = ''
    for t in titles:
        if t.tag == "{%s}titleabbrev" % xmlns['book']:
            return ' '.join(t.xpath(".//text()", namespaces=xmlns))
        else:
          title = ' '.join(t.xpath(".//text()", namespaces=xmlns)) 
    return title 

def preprocess_lexica(config):

    for lex in config.root.xpath("//book:lexicon", namespaces=xmlns):

        # Find Lexicon Title, (favors book:titleabbrev over book:title)
        titles = lex.xpath("book:info/book:titleabbrev|book:info/book:title|book:title", namespaces=xmlns)
        title = fetch_title(titles)

        for entry in lex.xpath(".//dion:entry", namespaces=xmlns):
            entry.set("{%s}lex" % xmlns['dion'], title)

def add(ref, title, entry):
    title_key = title[0].lower()
    if title_key == "*" and len(title) > 1:
        title_key = title[1].lower()

    if title_key not in ref:
        ref[title_key] = []

    ref[title_key].append(entry)



def build_reference(config, target, index):
    logger.info("Building lexica")
    try:
        keys = re.split('\s', target.attrib["ref"])
        try:
            fetch = target.attrib['select']
        except:
            fetch = "*"

        ref = {}
        for key in keys:
            for lex in config.root.xpath("//book:lexicon[@xml:id='%s']" % key, namespaces=xmlns):
                for entry in lex.xpath(".//dion:entry", namespaces=xmlns):
                    titles = entry.xpath(".//book:title", namespaces=xmlns)
                    title = fetch_title(titles)
                    if title != '':
                        if fetch == "*":
                            add(ref, title, entry)
                        elif fetch == "ref":
                            for term in entry.xpath(".//book:indexterm//text()", namespaces=xmlns):
                                if term in index:
                                    add(ref, title, entry)

        return ref 
    except Exception as e:
        logger.warn(f"Error building lexica for reference: {e}")


def build_lexica(config, target, comp):

    # Build Index for Reference
    index = list(set(target.xpath(".//book:indexterm//text()", namespaces=xmlns)))

    # Fetch Reference from Source
    base_refs = []
    for source in target.xpath(".//dion:source", namespaces=xmlns):
        ref = build_reference(config, source, index)

        if ref != {}:
            base_refs.append(ref)

    refs = {}


    # Concatenate Reference Entries
    for ref in base_refs:
        for key, value in ref.items():
            if key in refs:
                refs[key] += value
            else:
                refs[key] = value


    # Build Entries
    for key, entries in refs.items():
        section = lxml.etree.Element("{%s}section" % xmlns['book'])
        title = lxml.etree.Element("{%s}title" % xmlns['book'])
        title.text = f"{key.upper()}."
        section.append(title)

        for entry in entries:
            section.append(copy.deepcopy(entry))



        comp.addprevious(section)









