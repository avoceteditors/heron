<xsl:stylesheet xmlns:book="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dion="http://avoceteditors.com/xml/dion" version="1.0">
<xsl:output method="text" omit-xml-declaration="yes" index="no"/>

<xsl:template match="/book:book[@role='novel']">\documentclass[<xsl:value-of select="@dion:font"/>, <xsl:value-of select="@dion:paper"/>, <xsl:value-of select="@dion:sides"/>]{book}
\usepackage[book, hidetitles, gothrubric]{dion} 

\setTitle{<xsl:value-of select="book:title|book:info/book:title"/>}
\setAuthor{<xsl:value-of select="book:info/book:author"/>}

\setSurname{<xsl:value-of select="book:info/book:author/book:personname/book:surname"/>}

\setSubtitle{<xsl:value-of select="book:info/book:subtitle"/>}

\setPublisher{<xsl:value-of select="book:info/book:publisher/book:publishername"/>}

\setPubcities{<xsl:for-each select="book:info/book:publisher//book:city"><xsl:value-of select="."/><xsl:if test="position() != last()"> \tiny + \normalsize </xsl:if></xsl:for-each>}

\begin{document}

\diontitlepage

\tableofcontents

<xsl:apply-templates/>

\end{document}
</xsl:template>



<xsl:template match="/book:book[@role='book']">\documentclass[<xsl:value-of select="@dion:font"/>, <xsl:value-of select="@dion:paper"/>, <xsl:value-of select="@dion:sides"/>]{book}
\usepackage[book, showtitles]{dion} 

<!--
<xsl:value-of select="dion:preamble"/>
\pagestyle{fancy}
\fancyhead[RO]{\footnotesize <xsl:value-of select="book:info/book:author//book:surname"/> \normalsize}
\fancyhead[LE]{\footnotesize \textsc{<xsl:value-of select="book:info/book:title"/>}\normalsize}
\fancyhead[LO, RE, CO, CE]{}
\fancyfoot[LE, RO]{\footnotesize \thepage \normalsize}
\fancyfoot[LO, RE, CO, CE]{}
-->
<xsl:if test="@dion:index='yes'">
\makeindex
</xsl:if>

% Document
\begin{document}

<!--
% Tile Page
\begin{titlepage}
\begin{center}

\vspace{2in}
\bfseries 
\Large\MakeUppercase{<xsl:value-of select="book:info/book:title"/>}

\vspace{1in}
\large\emph{<xsl:value-of select="book:info/book:subtitle"/>}

\vspace{4.4in}
<xsl:value-of select="book:info/book:author/book:personname"/>

\vspace{0.5in}
\rule{0.75\textwidth}{0.4pt}

\normalsize\emph{<xsl:value-of select="book:info/book:publisher/book:publishername"/>}

\small <xsl:for-each select="book:info/book:publisher//book:city"><xsl:value-of select="."/><xsl:if test="position() != last()"> \tiny + \normalsize </xsl:if></xsl:for-each> 
\end{center}
\end{titlepage}

\tableofcontents
-->

<xsl:apply-templates/>

\end{document}
</xsl:template>

<xsl:template match="dion:preamble|dion:titles|book:info"/>


<!-- Compiled Section Matches -->
<xsl:template match="book:part">
\part*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:lexicon">
\chapter*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates select="book:para"/>

\begin{multicols}{<xsl:value-of select="@cols"/>}
<xsl:apply-templates select="book:section">

<xsl:sort select="book:title"/>

</xsl:apply-templates>
\end{multicols}

</xsl:template>


<xsl:template match="book:lexicon//book:section">
<xsl:variable name="title-count"><xsl:value-of select="count(book:title|book:info/book:title)"/></xsl:variable>
<xsl:if test="$title-count &gt; 0">\begin{center}\textbf{\footnotesize <xsl:value-of select="book:title|book:info/book:title"/>}\end{center}</xsl:if>

<xsl:apply-templates select="dion:entry">
<xsl:sort select="book:title[@dion:sort]"/>
</xsl:apply-templates>

</xsl:template>

<xsl:template match="dion:entry">
<xsl:apply-templates select="book:title|dion:definition|book:indexterm"/>
</xsl:template>


<xsl:template match="book:book/book:appendix">
\part*{<xsl:value-of select="title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:part/book:appendix">
\chapter*{<xsl:value-of select="book:title|book:info/book:title"/>}

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


<xsl:template match="book:section">
\subparagraph*{<xsl:value-of select="book:info/book:title|book:title"/>}

<xsl:apply-templates/>

</xsl:template>

<xsl:template match="book:section/book:para[preceding::book:imagedata][1]">

\noindent <xsl:apply-templates/> 

</xsl:template>


<xsl:template match="book:para[@dion:indent='no']">

\noindent <xsl:apply-templates/> 

</xsl:template>

<xsl:template match="book:para[preceding::book:itemizelist][1]">

\noindent <xsl:apply-templates/> 

</xsl:template>


<xsl:template match="book:para">

<xsl:apply-templates/> 

</xsl:template>

<!-- Blocks -->
<xsl:template match="book:index">
\printindex
</xsl:template>

<xsl:template match="dion:titles">

\titleblock{<xsl:value-of select="@all"/>}

</xsl:template>

<!-- Inline -->
<xsl:template match="dion:lett[@rubric]">\lettrine{<xsl:value-of select="@rubric"/>}{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="dion:lett">\lettrine[lines=1]{}{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="dion:entry/book:title">\par\noindent\textbf{\scriptsize <xsl:apply-templates/>} \textsc{\scriptsize <xsl:value-of select="../@dion:lex"/>} \textit{\scriptsize <xsl:value-of select="../@gramm"/>} </xsl:template>

<xsl:template match="book:title|book:para/dion:title"/>


<xsl:template match="dion:definition">\tiny\hspace{2pt} <xsl:value-of select="@counter"/> \scriptsize\hspace{1pt} <xsl:apply-templates/> </xsl:template> 

<xsl:template match="book:quote[@role='double']">``<xsl:apply-templates/>''</xsl:template>
<xsl:template match="book:quote[@role='single']">`<xsl:apply-templates/>'</xsl:template>
<xsl:template match="book:quote[@role='emdash']">---<xsl:apply-templates/></xsl:template>
<xsl:template match="book:quote[@role='none']"><xsl:apply-templates/></xsl:template>

<xsl:template match="book:emphasis">\textit{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="book:indexterm[@dion:type='tertiary']">\index{<xsl:apply-templates select="book:primary"/>!<xsl:apply-templates select="book:secondary"/>}</xsl:template>

<xsl:template match="book:indexterm[@dion:type='secondary']">\index{<xsl:apply-templates select="book:primary"/>!<xsl:apply-templates select="book:secondary"/>}</xsl:template>

<xsl:template match="book:indexterm[@dion:type='primary']">\index{<xsl:apply-templates/>}</xsl:template>

<xsl:template match="book:indexterm">\index{<xsl:value-of select="@dion:sort"/>@<xsl:apply-templates/>}</xsl:template>

<xsl:template match="book:imagedata">
\vspace{0.2in}
\begin{center}
\includegraphics[width=0.75\linewidth]{images/<xsl:value-of select="@fileref"/>}
\end{center}
\vspace{0.2in}


\noindent
</xsl:template>

<xsl:template match="book:itemizedlist">

\begin{itemize}

<xsl:apply-templates/>

\end{itemize}

</xsl:template>

<xsl:template match="book:listitem">
\item <xsl:apply-templates/>
</xsl:template>


</xsl:stylesheet>
