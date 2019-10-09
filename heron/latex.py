##################################################################################
# latex.py - Contains function to configure LaTeX preambles
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

# Local Imports
from .common import xmlns

# Configure Logger
from logging import getLogger
logger = getLogger()

class TEXPreamble:

    def __init__(self, target):

        # Inital Formatting
        self.init_formatting()

        # Initialize Build Type
        try:
            build_type = target.attrib["role"]
            if build_type not in ["book", "novel", "article"]:
                build_type == "book"
        except:
            build_type = "book"

        if build_type == "book":
            self.init_book()

        # Initialize Packages
        self.init_packages(build_type)

        # Set Docclass
        if (target.tag == "{%s}book" % xmlns['book']):
            self.docclass = "\\documentclass[twoside, 10pt, b5paper]{book}"
            self.format += "\n\\linespread{1.25}"
        else:
            self.docclass = "\\documentclass[oneside, 12pt, letterhead]{book}"
            self.format += "\n\\linespread{1.5}"

    def init_book(self):
        titles = []
        
        # Part Format
        part_format = "\\titleformat{\\part}[block]{\\Huge\\bfseries\\center\\MakeUppercase{#1}}{}{}{}"
        titles.append(part_format)

        # Chapter Format
        chapter_format = "\\titleformat{\\chapter}[block]{\\Large\\flushright\\bfseries \\MakeUppercase{#1}}{}{}{}[\\addcontentsline{toc}{chapter}{ #1}]"
        titles.append(chapter_format)
        

        # Section Format
        section_format = "\\titleformat{\\section}[block]{\\large\\bfseries #1}{}{}{}[\\addcontentsline{toc}{section}{ #1}]"
        titles.append(section_format)

        # Subsection
        section_format = "\\titleformat{\\subsection}[block]{\\normalsize\\bfseries \emph{#1}}{}{}{}[\\addcontentsline{toc}{subsection}{#1}]"
        titles.append(section_format)

        self.title_format = '\n'.join(titles)

    def init_formatting(self):
        gen_format = [
            "\\frenchspacing",
        ]

        sectionline = ["% Sectionline Command",
                "\\newcommand{\\sectionline}{%",
                "\\nointerlineskip\\noindent\\vspace{.8\\baselineskip}\\hspace{\\fill}",
                "{\\resizebox{0.5\\linewidth}{2ex}",
                "{{{\\begin{tikzpicture}",
                "\\node  (C) at (0,0) {};",
                "\\node (D) at (5,0) {};",
                "\\path (C) to [ornament=88] (D);",
                "\\end{tikzpicture}}}}}%",
                "\\hspace{\\fill}"
                "\\par\\nointerlineskip \\vspace{0.1in}}"]
        gen_format.append('\n'.join(sectionline))

        

        self.format = '\n'.join(gen_format)

    def init_packages(self, build_type):
        packages_list = [
            ('graphicx', None),
            ('fancyhdr', None),
            ('inputenc', ['utf8']),
            ('hyperref', ['hidelinks']),
            ('setspace', None),
            ('babel', ['english']),
            ('csquotes', ['autostyle', 'english=american']),
            ('lettrine', None),
            ('framed', None),
            ('pifont',None),
            ('appendix', ['toc, page']),
            ('geometry', ['margin=1in']),
            ('pgfornament', ['object=vectorian']),
            ('fontspec', None),
            ('tipa', None),
            ('footmisc', None),
            ('textgreek', ['euler']),
            #('makeidx', None),
            ('imakeidx', None),
            ('multicol', None)]

        packages_list.append(
            ('titlesec', ['noindentafter', 'explicit']))

        packages = []
        for (name, opts) in packages_list:
            if opts is None:
                packages.append("\\usepackage{%s}" % name)
            else:
                packages.append("\\usepackage[%s]{%s}" % (', '.join(opts), name))

        self.packages = "\n".join(packages)

    def fetch(self):
        return '\n'.join([self.docclass, self.packages, self.title_format, self.format])


def set_default(element, key, value):
    try:
        element.attrib[key]
    except:
        element.set(key, value)


def compile_latex(config):

    for target in config.root.xpath("//book:book", namespaces=xmlns):
        set_default(target, "{%s}font" % xmlns['dion'], "12pt")
        set_default(target, "{%s}paper" % xmlns['dion'], "b5paper")
        set_default(target, "{%s}sides" % xmlns['dion'], "twoside")

    for target in config.root.xpath("//book:chapter|//book:article", namespaces=xmlns):
        set_default(target, "{%s}font" % xmlns['dion'], "12pt")
        set_default(target, "{%s}paper" % xmlns['dion'], "letterhead")
        set_default(target, "{%s}sides" % xmlns['dion'], "oneside")



def set_roles(config):

    for book in config.root.xpath("//book:book", namespaces=xmlns):
        try:
            role = book.attrib['role']
            for section in book.xpath(".//book:chapter|.//book:article", namespaces=xmlns):
                try:
                    check = section.attrib['role']
                except:
                    section.set('role', role)

        except Exception as e:
            logger.warn(f"{e}")



