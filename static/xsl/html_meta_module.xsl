<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dhil="https://dhil.lib.sfu.ca"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 4, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p>Stylesheet for creating the HTML meta tags for a document</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:mode name="meta" on-no-match="shallow-skip"/>
    
    <xd:doc>
        <xd:desc>Simple set of templates to generate various meta tags</xd:desc>
    </xd:doc>
    <xsl:template match="TEI" mode="meta">
        <xsl:variable name="id" select="dhil:basename(.)" as="xs:string"/>
        <xsl:variable name="title" 
            select="normalize-space(//fileDesc/titleStmt/title[1])"
            as="xs:string"/>
        <xsl:variable name="tn" 
            select="(descendant::pb[@facs])[1]/@facs => dhil:facsLink()"
            as="xs:string?"/>
        
        <meta name="DC.type" content="Text"/>
        <meta name="DC.identifier" content="{$id}"/>
        <meta name="twitter:card" content="summary_large_image"/>
        <meta property="og:site_name" content="Lyrical Ballads"/>
        <meta property="og:type" content="article"/>
        <meta property="og:url" content="{$host}/{$id}.html"/>
        <xsl:for-each select="('DC.title', 'twitter:title','og:title')">
            <meta name="{.}" content="{$title}"/>
        </xsl:for-each>
        <xsl:if test="$tn">
            <meta name="twitter:image" content="{$host}/{$tn}"/>
            <meta property="og:image" content="{$host}/{$tn}"/>
            <meta name="docImage" class="staticSearch_docImage" content="{$tn}"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>