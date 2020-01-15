##################################################################################
# __init__.py - Operation to report statistical information on a document
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
import sys

# Local Imports
import heron.build.xml
from .report import report_stats

# Logger Configuration
from logging import getLogger
logger = getLogger("heron.stats")

def run_stats(args):
    """Called from the command-line, reports statistical information
    on the given project."""
    logger.info("Called statistical reporting operation")

    # Set Cache Path
    cache_dir = pathlib.Path(args.cache)
    cache_path = cache_dir.joinpath("manifest.xml")

    # Check that Path Exists
    if not cache_path.exists():
        logger.critical("Unable to locate `manifest.xml`, run heron build -u to create it.") 
        sys.exit(1)

    # Open Project 
    try:
        doc = lxml.etree.parse(str(cache_path))
        project = doc.getroot()

    except Exception as e:
        logger.critical(f"Unable to parse manifest.xml: {e}")
        sys.exit(1)

    # Fetch Documents
    docs = heron.build.xml.fetch_build(project, "//book:book", args.all)

    # Report
    for doc in docs:
        report_stats(doc)


