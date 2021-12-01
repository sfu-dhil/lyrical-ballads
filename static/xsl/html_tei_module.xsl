<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:dhil="https://dhil.lib.sfu.ca"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 30, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:mode name="tei" on-no-match="shallow-skip" _warning-on-no-match="{string($verbose)}"/>
    <xsl:mode name="raise" on-no-match="shallow-copy" _warning-on-no-match="{string($verbose)}"/>
    
    <xsl:mode name="flatten" on-no-match="shallow-copy" _warning-on-no-match="{string($verbose)}"/>
    
    <xsl:template match="TEI" mode="tei">
        <xsl:variable name="flattened" as="document-node()">
            <xsl:apply-templates select="/" mode="flatten"/>
        </xsl:variable>
        <xsl:apply-templates select="$flattened//text" mode="#current"/>
    </xsl:template>
    
    
    <xsl:template match="text" mode="tei">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
     <xsl:template match="front | body | back" mode="tei">
         <section>
             <xsl:call-template name="processAtts"/>
             <xsl:for-each-group select="node()" group-starting-with="self::pb">
                 <xsl:variable name="pb" select="current-group()[1]/self::pb" as="element(pb)?"/>
                 <xsl:if test="exists($pb)">
                     <section class="page">
                         <div class="text">
                             <xsl:where-populated>
                                 <div class="pageNum"><xsl:value-of select="$pb/@n"/></div>
                             </xsl:where-populated>
                            
                             <xsl:apply-templates select="current-group() except $pb" mode="#current"/>
                         </div>
                         <div class="image">
                             <xsl:apply-templates select="$pb" mode="#current"/>
                         </div>
                     </section>
                 </xsl:if>
             </xsl:for-each-group>         
         </section>
     </xsl:template>
     
    
    <xsl:template match="titlePage | docTitle | docImprint" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="titlePart | titlePart[@type='main']" mode="tei">
        <h1>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </h1>
    </xsl:template>
    
    <xsl:template match="titlePart[@type='sub']" mode="tei">
        <h2>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </h2>
    </xsl:template>
    
    
    <xsl:template match="pubPlace | publisher | docDate" mode="tei">
        <xsl:apply-templates  mode="#current"/>
    </xsl:template>


    <xsl:template match="argument" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates  mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="lg | l" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="bibl" mode="tei">
        <xsl:apply-templates  mode="#current"/>
    </xsl:template>
    
    <xsl:template match="head" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="title" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="bibl/title" mode="tei">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    
    <xsl:template match="lb" mode="tei">
        <br/>
    </xsl:template>

    
    <xsl:template match="seg | span | hi | w" mode="tei">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="figure" mode="tei">
        <hr>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </hr>
    </xsl:template>
    
    <xsl:template match="div" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="p" mode="tei">
        <p>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="ptr" mode="tei">
        <a href="{@target}" class="footnote" id="{@xml:id}"><xsl:value-of select="@n"/></a>
    </xsl:template>
    
    <xsl:template match="note" mode="tei">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="tg" select="concat('#', $id)"/>
        <xsl:variable name="ptr" select="//ptr[@target=$tg]/@xml:id"/> 
        <p class="footnote" id="{@xml:id}">
            <xsl:apply-templates  mode="#current"/>
            <xsl:if test="$ptr"><br/><a href="#{$ptr}" class='back'>[back]</a></xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="list" mode="tei">
        <xsl:apply-templates select="head" mode="#current"/>
        <xsl:element name="{if (@type='numbered') then 'ol' else 'ul'}">
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates select="item" mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="item" mode="tei">
        <li>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </li>
    </xsl:template>
    
    <xsl:template match="sp" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="table" mode="tei">
        <table>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </table>
    </xsl:template>
    
    <xsl:template match="row" mode="tei">
        <tr>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </tr>
    </xsl:template>
    
    <xsl:template match="cell" mode="tei">
        <td>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </td>
    </xsl:template>
    
    <xsl:template match="speaker" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="list[@type='toc']//ref" mode="tei">
        <a href="{replace(@target,'\.xml$','.html')}" class="toc-link"><xsl:apply-templates  mode="#current"/></a>
    </xsl:template>
    
    <xsl:template match="pb" mode="tei">
        <img src="facs/{@facs}"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="tei">
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
        <xsl:apply-templates select="@*" mode="#current"/>
    </xsl:template>

    <xsl:template match="@rend" mode="tei">
        <xsl:attribute name="style" separator="; ">
            <xsl:for-each select="tokenize(.)">
                <xsl:sequence select="dhil:translate_rend(.)"/>
            </xsl:for-each>
        </xsl:attribute>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Delete unnecessary attributes, since they're handled elsewhere.</xd:desc>
    </xd:doc>
    <xsl:template match="@*"/>
   
  
    <xd:doc>
        <xd:desc>This is a much cruder version of mjoyce's mm conversion, but it appears to give more-or-less correct results.</xd:desc>
    </xd:doc>
    <xsl:function name="dhil:convert_mm" as="xs:string">
        <xsl:param name="token" as="xs:string"/>
        <!--Ratio taken from looking at existing Islandora rendering:
            3mm => 21.6px
            (21.6px / 3mm) * (1rem / 16px) = 0.45rem/mm -->
        <xsl:variable name="ratio" select="0.45" as="xs:float"/>
        <xsl:variable name="num" 
            select="replace($token,'[^\d\.]','') => xs:float()" 
            as="xs:float"/>
        <xsl:variable name="scaled" select="$num * $ratio"/>
        <xsl:sequence select="$scaled || 'em'"/>
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
    
    <xsl:template match="front | body | back" mode="flatten">
        <xsl:copy>
            <xsl:sequence select="@*"/>
            <xsl:sequence select="node() ! dhil:flatten(.)"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="dhil:flatten">
        <xsl:param name="node"/>
        <xsl:variable name="test" as="node()*">
            <xsl:apply-templates select="$node" mode="raise"/>
        </xsl:variable>
        <xsl:for-each select="$test">
            <xsl:choose>
                <xsl:when test="child::pb">
                    <xsl:sequence select="dhil:flatten(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:template match="*[pb]" mode="raise">
        <xsl:variable name="this" select="."/>
        <xsl:choose>
            <xsl:when test="self::lg and child::*[1]/self::pb">
                <xsl:variable name="pb" select="child::*[1]/self::pb"/>
                <xsl:sequence select="$pb"/>
                <xsl:copy>
                    <xsl:apply-templates select="@* | (node() except $pb)" mode="#current"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each-group select="node()" group-ending-with="self::pb">
                    <xsl:variable name="pb" select="current-group()[last()]"/>
                    <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="{local-name($this)}">
                        <xsl:sequence select="$this/@*"/>
                        <xsl:apply-templates select="current-group() except $pb" mode="#current"/>
                    </xsl:element>
                    <xsl:sequence select="$pb"/>
                </xsl:for-each-group>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    
    
</xsl:stylesheet>