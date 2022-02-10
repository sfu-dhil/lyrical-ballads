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
            <xd:p>Transformation to convert the TEI encoded texts for the Lyrical Ballads project into a static HTML site.</xd:p>
            <xd:p>Adapted from mjoyce's code for the Lyrical Ballads project.</xd:p>
        </xd:desc>
        <xd:param name="dist">Dist directory, passed as a parameter from ANT.</xd:param>
        <xd:param name="debug">Static flag to output debugging messages. 
            Options: 0 (false; default), 1 (true).</xd:param>
    </xd:doc>
    
    
    <xsl:param name="dist" select="resolve-uri('../../dist')"  as="xs:string"/>
    <xsl:param name="debug" select="'0'" as="xs:string" static="yes"/>
    <xsl:param name="verbose" select="boolean(xs:integer($debug))" 
        as="xs:boolean" static="yes"/>

    <xsl:include href="html_tei_module.xsl"/>
    
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
    
    <xd:doc>
        <xd:desc>Index list</xd:desc>
    </xd:doc>
    <xsl:variable name="index" as="element()*">
        <xsl:apply-templates 
            select="$docs[dhil:basename(.) = 'index']//tei:list[@type='toc']"
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
        <xd:desc>Add the document's title</xd:desc>
        <xd:param name="doc">The TEI document currently being processed.</xd:param>
    </xd:doc>
    <xsl:template match="html/head/title" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:copy>
            <xsl:value-of select="$doc//tei:teiHeader/tei:titleStmt/tei:title[1]"/>
        </xsl:copy>
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
       <xd:desc>Function to retrieve the basename of a document</xd:desc>
       <xd:param name="node">Any node in a document</xd:param>
   </xd:doc>
    <xsl:function name="dhil:basename" as="xs:string" new-each-time="no">
        <xsl:param name="node"/>
        <xsl:variable name="uri" select="document-uri(root($node))" as="xs:anyURI"/>
        <xsl:sequence select="tokenize($uri,'[/\.]')[last() -1]"/>
    </xsl:function>
    
</xsl:stylesheet>