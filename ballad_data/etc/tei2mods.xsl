<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mods="http://www.loc.gov/mods/v3" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="http://www.loc.gov/mods/v3" 
    exclude-result-prefixes="xsl xs tei mods xsi xlink"
    version="1.0">
    
    <xsl:param name="filename"/>
    
    <xsl:template match="tei:TEI">
        <mods>
            <xsl:apply-templates select='.//tei:titleStmt'/>
            <typeOfResource>text</typeOfResource>
            <identifier type="original_filename"><xsl:value-of select="$filename"/></identifier>
            <identifier type="group_membership">ca.sfu.lib.ballads</identifier>
        </mods>
    </xsl:template>

    <xsl:template match="tei:titleStmt">
        <titleInfo>
            <xsl:apply-templates select='tei:title' />
        </titleInfo>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <title><xsl:apply-templates /></title>
    </xsl:template>

    <xsl:template match="*">
        <xsl:apply-templates />
    </xsl:template>

</xsl:stylesheet>