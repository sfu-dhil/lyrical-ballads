<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
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
    
    <xsl:mode on-no-match="shallow-skip" _warning-on-no-match="{string($verbose)}"/>
   
    
    <xd:doc>
        <xd:desc>Collection of all of the TEI documents to
        process.</xd:desc>
    </xd:doc>
    <xsl:variable name="docs" select="collection($dist || '/xml?select=*.xml')"/>
    
    <xd:doc>
        <xd:desc>Driver template</xd:desc>
    </xd:doc>
    <xsl:template name="go">
        <xsl:apply-templates select="$docs"/>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:result-document href="{$dist}/{dhil:basename(.)}.html" method="xhtml" html-version="5.0">
            <xsl:message select="'Creating ' || current-output-uri()"/>
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template match="TEI">
       <html id="{dhil:basename(.)}" lang="en" xml:lang="en">
           <xsl:apply-templates/>
       </html>
    </xsl:template>
    
    <xsl:template match="teiHeader">
        <head>
            <title>TEST</title>
        </head>
    </xsl:template>
    
    <xsl:template match="text">
        <body>
            <main>
                <xsl:call-template name="processAtts"/>
                <xsl:apply-templates/>
            </main>
        </body>
    </xsl:template>
    
     <xsl:template match="front | body | back">
         <section>
             <xsl:call-template name="processAtts"/>
             <xsl:apply-templates/>
         </section>
     </xsl:template>
     
    
    <xsl:template match="titlePage | docTitle | docImprint">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="titlePart | titlePart[@type='main']">
        <h1>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    
    <xsl:template match="titlePart[@type='sub']">
        <h2>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    
    
    <xsl:template match="pubPlace | publisher | docDate">
        <xsl:apply-templates />
    </xsl:template>


    <xsl:template match="argument">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="lg | l">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="bibl">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="head">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="title">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="bibl/title">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <xsl:template match="lb">
        <br/>
    </xsl:template>

    
    <xsl:template match="seg | span | hi | w">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="figure">
        <hr>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </hr>
    </xsl:template>
    
    <xsl:template match="div">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="p">
        <p>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="ptr">
        <a href="{@target}" class="footnote" id="{@xml:id}"><xsl:value-of select="@n"/></a>
    </xsl:template>
    
    <xsl:template match="note">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="tg" select="concat('#', $id)"/>
        <xsl:variable name="ptr" select="//ptr[@target=$tg]/@xml:id"/> 
        <p class="footnote" id="{@xml:id}">
            <xsl:apply-templates />
            <xsl:if test="$ptr"><br/><a href="#{$ptr}" class='back'>[back]</a></xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:apply-templates select="head"/>
        <xsl:element name="{if (@type='numbered') then 'ol' else 'ul'}">
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates select="item"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="item">
        <li>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <xsl:template match="sp">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="table">
        <table>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="row">
        <tr>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="cell">
        <td>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    
    <xsl:template match="speaker">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="list[@type='toc']//ref">
        <a href="{replace(@target,'\.xml$','.html')}" class="toc-link"><xsl:apply-templates /></a>
    </xsl:template>
    
    <xsl:template match="pb">
        <hr>
            <xsl:call-template name="processAtts"/>
        </hr>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
    
<!--    <xsl:template match="pb">
        <xsl:variable name="pn" select="substring(@facs, 17, 3)"/>
        <div class="pb">
            <span class='spacer'><xsl:text> </xsl:text></span>
        </div>
        <img class='facs' src="{$facsBase}/FACS_{$pn}/view"/>
        <p class='pagenumber'><xsl:value-of select="@n"/></p>
    </xsl:template>-->
    

    <xsl:template name="processAtts" as="attribute()*">
        <xsl:param name="class" as="xs:string*"/>
        <xsl:attribute name="class" select="
            ($class, 'tei-' || local-name())
            => string-join(' ')"/>
        
        <xsl:for-each select="@*">
            <xsl:attribute name="data-{local-name()}" select="string(.)"/>
        </xsl:for-each>
        <xsl:apply-templates select="@*"/>
    </xsl:template>

    <xsl:template match="@rend">
        <xsl:try>
            <xsl:attribute name="style" separator="; ">
                <xsl:for-each select="tokenize(.)">
                    <xsl:value-of select="dhil:translate_rend(.)"/>
                </xsl:for-each>
            </xsl:attribute>
            <xsl:catch>
                <xsl:message select="parent::*"/>
            </xsl:catch>
        </xsl:try>

    </xsl:template>
    
    <xd:doc>
        <xd:desc>Delete unnecessary attributes, since they're handled elsewhere.</xd:desc>
    </xd:doc>
    <xsl:template match="@*"/>
    
    
    
    <xsl:function name="dhil:basename" as="xs:string" new-each-time="no">
        <xsl:param name="node"/>
        <xsl:variable name="uri" select="document-uri(root($node))" as="xs:anyURI"/>
        <xsl:sequence select="tokenize($uri,'[/\.]')[last() -1]"/>
    </xsl:function>

    <xd:doc>
        <xd:desc>This is a much cruder version of mjoyce's mm conversion, but it appears to give more-or-less correct results.</xd:desc>
    </xd:doc>
    <xsl:function name="dhil:convert_mm" as="xs:string">
        <xsl:param name="token" as="xs:string"/>
        <xsl:variable name="num" 
            select="replace($token,'[^\d\.]','') => xs:float()" 
            as="xs:float"/>
        <xsl:sequence select="$num || 'rem'"/>
    </xsl:function>
    
    <xsl:function name="dhil:translate_rend" as="xs:string?" new-each-time="no">
        <xsl:param name="token" as="xs:string"/>
        <xsl:variable name="bits" 
            select="translate($token,'()', ' ') 
            => normalize-space() 
            => tokenize()" as="xs:string+"/>
        <xsl:variable name="ident" 
            select="$bits[1]" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$ident = ('font-size')">
                <xsl:sequence select="'font-size: ' || dhil:convert_mm($bits[2])"/>
            </xsl:when>
            <xsl:when test="$ident = 'indent'">
                <xsl:sequence select="'margin-left: ' || dhil:convert_mm($bits[2])"/>
            </xsl:when>
            <xsl:when test="$ident = 'length'">
                <xsl:sequence select="'width: ' || dhil:convert_mm($bits[2])"/>
            </xsl:when>
            <xsl:when test="$ident = ('center','centre')">
                <xsl:sequence select="'text-align: center'"/>
            </xsl:when>
            <xsl:when test="$ident = ('italic','italics')">
                <xsl:sequence select="'font-style: italic'"/>
            </xsl:when>
            <xsl:when test="$ident = ('roman')">
                <xsl:sequence select="'font-style: normal'"/>
            </xsl:when>
            <xsl:when test="$ident = ('uppercase')">
                <xsl:sequence select="'text-transform: uppercase'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>ERROR: UNKNOWN REND TOKEN: <xsl:value-of select="$ident"/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    
    
    
    
    
    
</xsl:stylesheet>