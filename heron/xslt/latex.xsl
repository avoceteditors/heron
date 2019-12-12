<xsl:stylesheet xmlns:book="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dion="http://avoceteditors.com/xml/dion" xml:id="latex" version="1.0" dion:path="heron/xslt/latex" dion:mtime="1576143217.0223749">
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
\Large\bfseries <xsl:value-of select="book:info/dion:booktitle"/>: \emph{<xsl:value-of select="book:info/book:title|book:title"/>}

\normalsize <xsl:value-of select="book:info//book:author"/>

% Document Statistics
\vspace{1.75in}
\begin{center}
\begin{tikzpicture}
\begin{axis}[ybar, enlargelimits=0.2, ylabel=Count, xlabel=Chapters, xtick=data,
    symbolic x coords = { <xsl:value-of select="book:info/dion:stats[@role='book']/@charttitle"/>  },
   nodes near coords align={vertical}]

\addplot coordinates {
<xsl:for-each select="book:info/dion:stats[@role='book']/dion:stats">
(<xsl:value-of select="@count"/>, <xsl:value-of select="@words"/>)
</xsl:for-each>
};

\end{axis}
\end{tikzpicture}
\end{center}

\end{flushright}

\begin{minipage}{0.45\textwidth}
\large\bfseries Document Statistics: \normalfont\small

\begin{itemize}
\item
\numprint{<xsl:value-of select="book:info/dion:stats[@role='section']/@lines"/>} {} 
/
\numprint{<xsl:value-of select="book:info/dion:stats[@role='book']/@lines"/>} {}
\emph{lines}

\item
\numprint{<xsl:value-of select="book:info/dion:stats[@role='section']/@words"/>} {} 
/ 
\numprint{<xsl:value-of select="book:info/dion:stats[@role='book']/@words"/>} {}
\emph{words}

\item
\numprint{<xsl:value-of select="book:info/dion:stats[@role='section']/@chars"/>} {} 
/
\numprint{ <xsl:value-of select="book:info/dion:stats[@role='book']/@chars"/>}{}
\emph{characters}
\end{itemize}
\end{minipage}%
\hfill
\begin{minipage}{0.45\textwidth}
\begin{tabular}{p{\textwidth}}
\large\bfseries Document Status: \normalfont\small 
\begin{itemize}
\item\small <xsl:value-of select="@dion:lastedit"/> 
\item Chapter Number: <xsl:value-of select="book:info/dion:stats[@role='section']/@count"/> 
\end{itemize}
\end{tabular}
\end{minipage}

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