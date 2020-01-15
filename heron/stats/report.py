##################################################################################
# report.py - Functions used to report statistical information to users.
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

# Local Imports
import heron.build.xml

# Configure Logging
from logging import getLogger
logger = getLogger("heron.stats")

# Report Stats Function
def report_stats(doc):

    # Fetch Title
    title = heron.build.xml.xpath(doc, "book:info/book:title/text()|book:title/text()")

    if len(title) > 0:
        title = title[0]
    else:
        title = "__UNTITLED__"

    # Parts
    chps = []

    for part in heron.build.xml.xpath(doc, ".//book:part"):
        cs = heron.build.xml.xpath(part, ".//book:chapter")
        chps.append(len(cs))

    if chps != []:
        #chps_avg = avg(chps)
        pass



    # Chapter Data
    chapters = heron.build.xml.xpath(doc, ".//book:chapter")
    chap_draft = len(heron.build.xml.xpath(doc, ".//book:chapter[@dion:status='draft']"))
    chap_rev = len(heron.build.xml.xpath(doc, ".//book:chapter[@dion:status='review']"))
    chap_done = len(heron.build.xml.xpath(doc, ".//book:chapter[@dion:status='done']"))
    chap_count = len(chapters)

    chap_stats_data = [
        "Chapter Data",
        f"Number of Chapters (total):  {chap_count}",
        f"Number of Chapters (drafts): {chap_draft}",
        f"Number of Chapters (review): {chap_rev}",
        f"Number of Chapters (done):   {chap_done}"
    ]
    chap_stats = '\n - '.join(chap_stats_data)

    contents = [title, '\n', chap_stats, '\n', f"Word Count: {wc}"]

    print('\n'.join(contents))


    

