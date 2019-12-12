<xsl:stylesheet xmlns:book="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dion="http://avoceteditors.com/xml/dion" xml:id="web" version="5.0" dion:path="heron/xslt/web" dion:mtime="1576117211.0796423">

<!-- Main Section -->
<xsl:template match="/book:book|/book:chapter|/book:part|/book:section|/book:article">
<section id="content">
<div id="main-section">
<h1><xsl:value-of select="book:info/book:title/book:title"/></h1>
<xsl:apply-templates/>
</div>
</section>
</xsl:template>

<xsl:template match="/*/book:part|/*/book:chapter|/*/book:section|/*/book:article">
<div>
<h2><xsl:value-of select="book:info/book:title"/></h2>
<xsl:apply-templates/>
</div>
</xsl:template>

</xsl:stylesheet>