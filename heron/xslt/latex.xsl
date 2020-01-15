<xsl:stylesheet xmlns:book="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dion="http://avoceteditors.com/xml/dion" xml:id="latex" version="1.0" dion:path="heron/xslt/latex" dion:mtime="1578130494.9331427">
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

<xsl:template match="/book:book">
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
\documentclass[<xsl:value-of select="@dion:font"/>, letterhead, onesided]{book}
\usepackage[chapter, hidetitles, gothrubric]{dion}

% Variables
\setTitle{<xsl:value-of select="book:info/dion:booktitle"/>}
\setAuthor{<xsl:value-of select="book:info/book:author"/>}
\setSurname{<xsl:value-of select="book:info/book:author//book:surname"/>}
\setSubtitle{<xsl:value-of select="book:info/book:subtitle"/>}
\setPublisher{<xsl:value-of select="book:info/book:publisher/book:publishername"/>}
\setPubcities{<xsl:for-each select="book:info/book:publisher//book:city"><xsl:value-of select="."/><xsl:if test="position() != last()"> \tiny + \normalsize </xsl:if></xsl:for-each>}

%%%%%%%%%%%%%%%%%%%%%%% BEGIN DOCUMENT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

\begin{titlepage}
\hrule
\begin{flushright}
\large\bfseries <xsl:value-of select="book:info/dion:booktitle"/>: \emph{<xsl:value-of select="book:info/book:title|book:title"/>}

\normalsize <xsl:value-of select="book:info//book:author"/>

\end{flushright}

% Abstract
\hrule

\small
\begin{center}
\textbf{ABSTRACT}
\end{center}

<xsl:apply-templates select="book:info/book:abstract"/>

\vspace{0.15in}
\normalsize

% Document Statistics
\hrule
\begin{center}
\begin{tikzpicture}
\begin{axis}[ybar, enlargelimits=0.2, ylabel=Word Count, xlabel=Chapters, xtick=data,
    height=0.25\textwidth,
    width=\textwidth,
    symbolic x coords = {<xsl:value-of select="book:info/dion:stats[@role='book']/@charttitle"/>  },
   nodes near coords align={vertical}]

\addplot coordinates {
<xsl:for-each select="book:info/dion:stats[@role='book']/dion:stats">
(<xsl:value-of select="@count"/>, <xsl:value-of select="@words"/>)
</xsl:for-each>
};

\end{axis}
\end{tikzpicture}
\end{center}

\footnotesize

\begin{center}
\begin{tabulary}{\textwidth}{lrllrr}
\hline
&amp; &amp; \hspace{1in} &amp; &amp; \emph{Chapter} &amp; \emph{Book} \\
\emph{Created:} &amp; <xsl:value-of select="@dion:created"/>  &amp; &amp; \emph{Lines:} &amp; \numprint{<xsl:value-of select="book:info/dion:stats[@role='section']/@lines"/>} &amp; \numprint{<xsl:value-of select="book:info/dion:stats[@role='book']/@lines"/>} \\
\emph{Updated:} &amp; <xsl:value-of select="@dion:lastedit"/>  &amp; &amp; \emph{Words:} &amp; \numprint{<xsl:value-of select="book:info/dion:stats[@role='section']/@words"/>} &amp; \numprint{<xsl:value-of select="book:info/dion:stats[@role='book']/@words"/>} \\
\emph{Status:} &amp; <xsl:value-of select="@dion:status"/> &amp; &amp; \emph{Chars:} &amp; \numprint{<xsl:value-of select="book:info/dion:stats[@role='section']/@chars"/>} &amp; \numprint{<xsl:value-of select="book:info/dion:stats[@role='book']/@chars"/>} \\
\hline
\end{tabulary}
\end{center}



<!--
\begin{tabulary{0.45\textwidth}{lrr}


\end{tabulary}

\bfseries Document Status: \normalfont\footnotesize

\begin{tabulary}{0.45\textwidth}{lr}
Created:  &amp; <xsl:value-of select="@dion:created"/> \\
Updated: &amp; <xsl:value-of select="@dion:lastedit"/> \\
Chapter Number: &amp; <xsl:value-of select="book:info/dion:stats[@role='section']/@count"/>  \\

\end{tabulary}
-->

\end{titlepage}

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

<xsl:template match="book:chapter">
\chapter*{<xsl:value-of select="book:info/book:title|book:title"/>}
<xsl:if test="@role='novel'">
\titleblock{<xsl:value-of select="book:info/dion:titleblock"/>}
</xsl:if>

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


<dion:include src="sections.xml"/>

<!-- Blocks -->
<xsl:template match="book:info|book:title"/>

<xsl:template match="book:para[@role='noindent']">

\noindent <xsl:apply-templates/>

</xsl:template>


<xsl:template match="book:para">

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="dion:todo">

\todo{<xsl:apply-templates/>}

</xsl:template>



<dion:include src="blocks.xml"/>

<!-- Inline -->
<xsl:template match="book:quote[role='double']">``<xsl:apply-templates/>''</xsl:template>
<xsl:template match="book:quote[role='single']">`<xsl:apply-templates/>'</xsl:template>
<xsl:template match="book:quote[role='emdash']">---<xsl:apply-templates/></xsl:template>
<xsl:template match="book:quote[role='none']"><xsl:apply-templates/></xsl:template>
<xsl:template match="book:quote">``<xsl:apply-templates/>''</xsl:template>
<xsl:template match="book:emphasis">\emph{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="dion:lett"><xsl:choose><xsl:when test="@format">\lettrine[<xsl:value-of select="@format"/>]{}{<xsl:apply-templates/>}</xsl:when><xsl:otherwise>\lettrine{<xsl:value-of select="@rubric"/>}{<xsl:apply-templates/>}</xsl:otherwise></xsl:choose></xsl:template>


<dion:include src="inline.xml"/>

</xsl:stylesheet>