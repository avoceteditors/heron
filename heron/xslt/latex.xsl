<xsl:stylesheet xmlns:book="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dion="http://avoceteditors.com/xml/dion" xml:id="latex" version="1.0" dion:path="heron/xslt/latex" dion:mtime="1576131245.9350324">
<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>


<!-- Books -->
<xsl:template match="/book:book[@role='novel']">
\documentclass[<xsl:value-of select="@dion:font"/>, <xsl:value-of select="@dion:paper"/>, <xsl:value-of select="@dion:sides"/>]{book}
\usepackage[book, hidetitles, gothrubric]{dion}

% Variables
\setTitle{<xsl:value-of select="book:title|book:info/book:title"/>}
\setAuthor{<xsl:value-of select="book:info/book:author"/>}
\setSurname{<xsl:value-of select="book:info/book:author//book:surname"/>}
\setSubtitle{<xsl:value-of select="book:info/book:subtitle"/>}
\setPublisher{<xsl:value-of select="book:info/book:publisher/book:publishername"/>}
\setPubcities{<xsl:for-each select="book:info/book:publisher//book:city"><xsl:value-of select="."/><xsl:if test="position() != last()"> \tiny + \normalsize </xsl:if></xsl:for-each>}

%%%%%%%%%%%%%%%%%%%%%%% BEGIN DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

\diontitlepage

\tableofcontents

<xsl:apply-templates/>

\end{document}
</xsl:template>

<xsl:template match="/book:book[@role='book']">
\documentclass[<xsl:value-of select="@dion:font"/>, <xsl:value-of select="@dion:paper"/>, <xsl:value-of select="@dion:sides"/>]{book}
\usepackage[book, hidetitles, gothrubric]{dion}

% Variables
\setTitle{<xsl:value-of select="book:title|book:info/book:title"/>}
\setAuthor{<xsl:value-of select="book:info/book:author"/>}
\setSurname{<xsl:value-of select="book:info/book:author//book:surname"/>}
\setSubtitle{<xsl:value-of select="book:info/book:subtitle"/>}
\setPublisher{<xsl:value-of select="book:info/book:publisher/book:publishername"/>}
\setPubcities{<xsl:for-each select="book:info/book:publisher//book:city"><xsl:value-of select="."/><xsl:if test="position() != last()"> \tiny + \normalsize </xsl:if></xsl:for-each>}

%%%%%%%%%%%%%%%%%%%%%%% BEGIN DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

\diontitlepage

\tableofcontents

<xsl:apply-templates/>

\end{document}
</xsl:template>

<!-- Chapters -->
<xsl:template match="/book:chapter">
\documentclass[<xsl:value-of select="@dion:font"/>, letterhead, oneside]{book}
\usepackage[book, hidetitles, gothrubric]{dion}

% Variables
\setTitle{<xsl:value-of select="book:info/dion:booktitle"/>}
\setAuthor{<xsl:value-of select="book:info/book:author"/>}
\setSurname{<xsl:value-of select="book:info/book:author//book:surname"/>}
\setSubtitle{<xsl:value-of select="book:info/book:subtitle"/>}
\setPublisher{<xsl:value-of select="book:info/book:publisher/book:publishername"/>}
\setPubcities{<xsl:for-each select="book:info/book:publisher//book:city"><xsl:value-of select="."/><xsl:if test="position() != last()"> \tiny + \normalsize </xsl:if></xsl:for-each>}

%%%%%%%%%%%%%%%%%%%%%%% BEGIN DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

\chapter*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:if test="@role='novel'">
\titleblock{<xsl:value-of select="book:info/dion:titleblock"/>}
</xsl:if>
<xsl:apply-templates/>

\end{document}
</xsl:template>

<!-- Sections -->
<xsl:template match="book:part">
\part*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:chapter[@role='novel']">
\chapter*{<xsl:value-of select="book:info/book:title|book:title"/>}

\titleblock{<xsl:value-of select="book:info/dion:titleblock"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:chapter">
\chapter*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>



<xsl:template match="book:chapter/book:section">
\section*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:chapter/book:section/book:section">
\subsection*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:chapter/book:section/book:section/book:section">
\subsubsection*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:chapter/book:section/book:section/book:section/book:section">
\paragraph*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:chapter/book:section/book:section/book:section/book:section/book:section">
\subparagraph*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:section">
\textbf{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>


<!-- Blocks -->
<xsl:template match="book:info|book:title"/>

<xsl:template match="book:para">


<xsl:apply-templates/>


</xsl:template>




<!-- Inline -->
<xsl:template match="book:quote[role='double']">``<xsl:apply-templates/>''</xsl:template>
<xsl:template match="book:quote[role='single']">`<xsl:apply-templates/>'</xsl:template>
<xsl:template match="book:quote[role='emdash']">---<xsl:apply-templates/></xsl:template>
<xsl:template match="book:quote[role='none']"><xsl:apply-templates/></xsl:template>
<xsl:template match="book:quote">``<xsl:apply-templates/>''</xsl:template>
<xsl:template match="book:emphasis">\emph{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="dion:lett">\lettrine{<xsl:value-of select="@rubric"/>}{<xsl:apply-templates/>}</xsl:template>


</xsl:stylesheet>