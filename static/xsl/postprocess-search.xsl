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
            <xd:p><xd:b>Created on:</xd:b> Feb 11, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p>Small template to postprocess the search page</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!--Identity transform-->
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!--Remove old staticSearch script-->
    <xsl:template match="script[ancestor::div[@id='staticSearch']]"/>
    
    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:sequence select="//script[matches(@src,'search/ssSearch.js')]"/>
            <script src="js/search.js"></script>
        </xsl:copy>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>