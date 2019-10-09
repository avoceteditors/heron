##################################################################################
# project.py - Used to build project.xml for cache
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
import sys

# Local Imports
from .common import xmlns, process_dincs
from .idrefs import evaluate_idrefs
from .titles import preprocess_titles, preprocess_titleblocks
from .lett import preprocess_lettrines
from .latex import compile_latex, set_roles
from .stats import compile_stats
from .index import preprocess_index
from .lex import preprocess_lexica

# Configure Logging
from logging import getLogger
logger = getLogger()


def build_cache(config):
    """Reads the base XML configuration and appends
    all relevant top level XML files to the build"""

    # Integrate Source Documents to Build
    for path in config.source.glob("*.xml"):
        logger.debug(f"Testing path: {path}")

        try:
            doc = lxml.etree.parse(str(path))
            if doc.getroot().tag in [
                "{%s}reference" % xmlns['dion'],
                "{%s}series" % xmlns['book'],
                "{%s}book" % xmlns['book'] ]:

                logger.debug(f"Found target: {path}")

                # Process XIncludes
                doc.xinclude()

                # Process Dincs
                process_dincs(path.parent, doc, False)

                config.root.append(doc.getroot())

        except Exception as e:
            logger.warn(f"Unable to read XML file '{path}': {e}")

    # Check xml:ids
    evaluate_idrefs(config)

    # Titles
    preprocess_titles(config)
    preprocess_titleblocks(config)

    # Index
    preprocess_index(config)

    # Lettrine Entries
    preprocess_lettrines(config)

    # Compile Stats
    compile_stats(config)

    # Process Lexica
    preprocess_lexica(config)

    # Set Roles
    set_roles(config)

    # Compile Latex
    compile_latex(config)

    

