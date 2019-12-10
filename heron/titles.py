##################################################################################
# titles.py - Contains function to preprocess titles
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
import copy

# Local Imports
from .common import xmlns

# Logger
from logging import getLogger
logger = getLogger()

def fetch_text(title):
    texts = []
    for base_text in title.xpath(".//text()", namespaces=xmlns):
        texts.append(base_text.strip())

    return re.sub("[\*]", "", re.sub('\s-', ' ', re.sub('-', '', ' '.join(texts))))


def preprocess_titles(config):

   # Set Sort title
    for i in config.project.getroot().xpath("//book:title|//dion:term", namespaces=xmlns):
        sort_text = str(fetch_text(i)).lower()
        i.set("{%s}sort" % xmlns['dion'], sort_text)

def preprocess_titleblocks(config):

    for book in config.root.xpath("//book:book", namespaces=xmlns):

        try:
            role = book.get('role')

            # Fetch Book Title
            titles = book.xpath("book:title|book:info/book:title", namespaces=xmlns)

            if len(titles) > 0:
                title = titles[0] 
            else:
                title = lxml.etree.Element("{%s}title" % xmlns['book'])
                title.text = "None"

            book_title = lxml.etree.Element("{%s}bookTitle" % xmlns['dion'])
            book_title.append(copy.deepcopy(title))

            # Fetch Author
            authors = book.xpath("book:info/book:author", namespaces=xmlns)

            if role == 'novel':
                for section in book.xpath(".//book:chapter|.//book:article",
                    namespaces=xmlns):

                    # Fetch Info
                    infos = section.xpath("book:info", namespaces=xmlns)
                    if len(infos) > 0:
                        info = infos[0]
                    else:
                        info = lxml.etree.Element("{%s}info" % xmlns['book'])
                        section.append(info)

                    # Set Book Title
                    new_title = lxml.etree.Element("{%s}title" % xmlns['dion'])
                    new_title.text = book_title.text
                    info.append(new_title)
                    
                    book_author = lxml.etree.Element("{%s}bookAuthor" % xmlns['dion'])
                    for author in authors:
                        book_author.append(copy.deepcopy(author))
                    info.append(book_author)

                    # Initialize dion:titles
                    block = lxml.etree.Element("{%s}titles" % xmlns['dion'])

                    # Fetch Title Elements from Section
                    base_titles = section.xpath(".//book:title|.//book:para/dion:title", namespaces=xmlns)

                    # Build List of Title Strings
                    block_titles = []
                    for base_title in base_titles:
                        block_titles.append(fetch_text(base_title))

                    # Set dion:titles text
                    block.set("all", ', '.join(block_titles) + '.')
                    if len(block_titles) > 1:
                        block.set("sections", ', '.join(block_titles[1:]) + '.')
                    else:
                        block.set("sections", "")


                    # Place dion:titles at start of section
                    section.insert(0, block)
        except Exception as e:
            logger.warn(f"Error processing titles: {e}")

