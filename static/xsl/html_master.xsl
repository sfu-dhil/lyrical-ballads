<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dhil="https://dhil.lib.sfu.ca"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 4, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p>Main transformation to convert the TEI encoded texts for the Lyrical 
                Ballads project into a static HTML site. It does so by iterating through
                all of the TEI texts and passing them through the standard HTML template;
                see html_tei_module.xsl for the templates that convert the TEI into HTML.</xd:p>
            <xd:p>Adapted from mjoyce's code for the Lyrical Ballads project.</xd:p>
        </xd:desc>
        <xd:param name="dist">Dist directory, passed as a parameter from ANT.</xd:param>
        <xd:param name="debug">Static flag to output debugging messages. 
            Options: 0 (false; default), 1 (true).</xd:param>
        <xd:param name="host">The host URI</xd:param>
    </xd:doc>
    
    
    <xsl:param name="dist" select="resolve-uri('../../dist')"  as="xs:string"/>
    <xsl:param name="debug" select="'0'" as="xs:string" static="yes"/>
    <xsl:param name="host" select="'https://dhil.lib.sfu.ca/lyrical-ballads'" as="xs:string"/>
    
    <xsl:variable name="verbose" select="boolean(xs:integer($debug))" 
        as="xs:boolean" static="yes"/>

    <xsl:include href="html_tei_module.xsl"/>
    <xsl:include href="html_meta_module.xsl"/>
    
    <xd:doc>
        <xd:desc>Identity transform.</xd:desc>
    </xd:doc>
    <xsl:mode name="html" on-no-match="shallow-copy"/>
    
    <xd:doc>
        <xd:desc>The template we're processing</xd:desc>
    </xd:doc>
    <xsl:variable name="template" select="document('../template.html')" as="document-node()"/>
    
    <xd:doc>
        <xd:desc>Collection of all of the TEI documents to
        process.</xd:desc>
    </xd:doc>
    <xsl:variable name="docs" select="collection($dist || '/xml?select=*.xml')" as="document-node()+"/>
    
    <xsl:variable name="indexList" select="$docs[dhil:basename(.) = 'index']//tei:list[@type='toc']"/>
    
    <xd:doc>
        <xd:desc>Item sequence</xd:desc>
    </xd:doc>
    <xsl:variable name="indexSeq" select="$indexList//tei:ref" as="element(tei:ref)+"/>
    
    <xd:doc>
        <xd:desc>Index list</xd:desc>
    </xd:doc>
    <xsl:variable name="index" as="element()*">
        <xsl:apply-templates 
            select="$indexList"
            mode="tei"/>
    </xsl:variable>

    <xd:doc>
        <xd:desc>Driver template</xd:desc>
    </xd:doc>
    <xsl:template name="go">
        <xsl:for-each select="$docs">
            <xsl:apply-templates select="$template" mode="html">
                <xsl:with-param name="doc" tunnel="yes" select="."/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Root template for matching the html template</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="/" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:result-document href="{$dist}/{dhil:basename($doc)}.html" method="xhtml" html-version="5.0">
            <xsl:message select="'Creating ' || current-output-uri()"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:result-document>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Add the HTML doc's id</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="html/@id" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:attribute name="id" select="dhil:basename($doc)"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Process the head to put in metadata blocks.</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="html/head" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="node()" mode="#current"/>
            <xsl:apply-templates select="$doc" mode="meta"/>
        </xsl:copy>
    </xsl:template>
    
   
    
    <xd:doc>
        <xd:desc>Add the document's title</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="html/head/title" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:copy>
            <xsl:value-of select="$doc//tei:titleStmt/tei:title[1]"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Add link to the source XML</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="aside[contains-token(@class,'source-link')]/a/@href" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:attribute name="href" select="'xml/' || dhil:basename($doc) || '.xml'"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Process the TOC</xd:desc>
    </xd:doc>
    <xsl:template match="*[@id='nav_toc']" mode="html">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:apply-templates select="$index/self::ul/li" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Process the TEI document's content in the content block</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="*[@id='content']" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="$doc" mode="tei"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Processing for navigation: Just process items and links, no pages</xd:desc>
    </xd:doc>
    <xsl:template match="li[parent::ul[@data-type='toc']]" mode="html">
        <xsl:copy>
            <xsl:apply-templates select="@*|a" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Process local links</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="a[matches(@href,'^[^/]+\.html$')]" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:variable name="targId" select="substring-before(@href,'.html')" as="xs:string"/>
        <xsl:variable name="current" select="dhil:basename($doc) = $targId" as="xs:boolean"/>
        <xsl:copy>
            <xsl:attribute name="class" 
                select="string-join((@class, if ($current) then 'current' else ()),' ')"/>
            <xsl:apply-templates select="@*[not(local-name() = 'class')]|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Add the time to the footer</xd:desc>
    </xd:doc>
    <xsl:template match="time" mode="html">
        <time datetime="{current-dateTime()}">
            <xsl:value-of
                select="format-date(current-date(),'[MNn] [D01], [Y0001]')"/>
        </time>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Complicated handling for the next/prev bits; we have to investigate
        the index list, find the element, and then get the preding link. Note that
        we always keep the prev link in the DOM, but hide it if it doesn't
        point to anything.</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="*[@id='prev']" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:variable name="basename" select="dhil:basename($doc)" as="xs:string"/>
        <xsl:variable name="curr"
            select="$indexList//tei:ref[@target = ($basename || '.xml')]" as="element()?"/>
        <xsl:variable name="prev"
            select="$curr/preceding::tei:ref[1]" as="element()?"/>
        <xsl:copy>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="$basename = 'front'">
                        <xsl:value-of select="'index.html'"/>
                    </xsl:when>
                    <xsl:when test="$prev">
                        <xsl:value-of select="replace($prev/@target,'.xml','.html')"/>
                    </xsl:when>
                    <xsl:otherwise>#</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:sequence select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>The same as the previous handling; this should likely be harmonized
            into a single process since the procedure is the same (except for the axis).
            Note that we always keep the next link in the DOM, but hide it if it doesn't
            point to anything.</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="*[@id='next']" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:variable name="basename" select="dhil:basename($doc)" as="xs:string"/>
        <xsl:variable name="curr" select="$indexList//tei:ref[@target = ($basename || '.xml')]" as="element()?"/>
        <xsl:variable name="next" select="$curr/following::tei:ref[1]" as="element()?"/>
        <xsl:copy>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="$basename = 'index'">
                        <xsl:value-of select="'front.html'"/>
                    </xsl:when>
                    <xsl:when test="$next">
                        <xsl:value-of select="replace($next/@target,'.xml','.html')"/>
                    </xsl:when>
                    <xsl:otherwise>#</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:sequence select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

   <xd:doc>
       <xd:desc>Function to retrieve the basename (without extension) of a document</xd:desc>
       <xd:param name="node">Any node in a document</xd:param>
   </xd:doc>
    <xsl:function name="dhil:basename" as="xs:string" new-each-time="no">
        <xsl:param name="node"/>
        <xsl:variable name="uri" select="base-uri(root($node))" as="xs:anyURI"/>
        <xsl:sequence select="tokenize($uri,'[/\.]')[last() -1]"/>
    </xsl:function>
    
</xsl:stylesheet>