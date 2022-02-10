<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:dhil="https://dhil.lib.sfu.ca"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 30, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="distDir"/>
    
    <xsl:variable name="docs" select="collection('../../public/xml?select=*.xml')"/>
    
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:mode name="raise" on-no-match="shallow-copy"/>
    <xsl:template name="go">
        <xsl:apply-templates select="$docs"/>
        
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:result-document href="{replace(document-uri(.),'/xml/','/flattened/')}" method="xml">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="front | body | back">
        <xsl:copy>
            <xsl:sequence select="node() ! dhil:flatten(.)"/>
        </xsl:copy>
    </xsl:template>
    

    
    <xsl:template match="pb | lb" mode="flatten">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="lg[child::*[1]/self::pb]" mode="flatten">
        <xsl:variable name="firstPb" select="child::*[1]/self::pb" as="element()"/>
        <xsl:apply-templates select="$firstPb" mode="flatten"/>
        <xsl:call-template name="start"/>
        <xsl:apply-templates select="node() except $firstPb" mode="#current"/>
        <xsl:call-template name="end"/>
    </xsl:template>
    
    <xsl:template match="*" mode="flatten">
        <xsl:call-template name="start"/>
        <xsl:apply-templates select="node()" mode="#current"/>
        <xsl:call-template name="end"/>
    </xsl:template>
    
    <xsl:template name="start">
        <xsl:copy>
            <xsl:sequence select="@*"/>
            <xsl:attribute name="sid" select="generate-id(.)"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="end">
        <xsl:copy>
            <xsl:attribute name="eid" select="generate-id(.)"/>
        </xsl:copy>
    </xsl:template>
    
    
    
</xsl:stylesheet>