<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:str="http://exslt.org/strings"
    
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs xsl tei html str"
    version="1.0">
    
    <xsl:param name="dbg">0</xsl:param>
    <xsl:param name="facsBase">datastream</xsl:param>
    
    <xsl:template match="tei:TEI">
        <xsl:apply-templates select="tei:text/*"/>
    </xsl:template>
    
    <xsl:template match="tei:front">
        <div class="front">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:titlePage">
        <div class="titlepage">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:docTitle">
        <div class="docTitle">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:titlePart | tei:titlePart[@type='main']">
        <h1>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </h1>
    </xsl:template>
    
    <xsl:template match="tei:titlePart[@type='sub']">
        <h2>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </h2>
    </xsl:template>
    
    
    <xsl:template match="tei:docImprint">
        <div class='imprint'>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:pubPlace | tei:publisher | tei:docDate">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="tei:body">
        <div class="work">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:argument">
        <div class="argument">
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:lg[@type='poem']">
        <div class='poem'>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>
    
    <xsl:template match="tei:bibl">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="tei:head">
        <div>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:bibl/tei:title">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    
    <xsl:template match="tei:title | tei:title[@type='main']">
        <h1>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </h1>
    </xsl:template>
    
    <xsl:template match="tei:title[@type='sub']">
        <h2>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </h2>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <span class='line'>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates /><br/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br />
    </xsl:template>
    
    <xsl:template match="tei:seg | tei:span | tei:hi | tei:w">
        <span>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </span>
    </xsl:template>
    
    <xsl:template match="tei:figure">
        <hr class="{@type}">
            <xsl:apply-templates select="@*[name()!='type']"/>
        </hr>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</p>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
        <a href="{@target}" class="footnote" id="{@xml:id}"><xsl:value-of select="@n"/></a>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="tg" select="concat('#', $id)"/>
        <xsl:variable name="ptr" select="//tei:ptr[@target=$tg]/@xml:id"/> 
        <p class="footnote" id="{@xml:id}">
            <xsl:apply-templates />
            <xsl:if test="$ptr"><br/><a href="#{$ptr}" class='back'>[back]</a></xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:list">
		<xsl:apply-templates select="tei:head" />
        <ul class="{@type}">
            <xsl:apply-templates select="tei:item" />
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:list[@type='numbered']">
        <ol>
            <xsl:apply-templates />
        </ol>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </li>
    </xsl:template>
    
    <xsl:template match="tei:sp">
        <div class='sp'>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <table class='ballads-tbl'>
            <xsl:apply-templates />
        </table>
    </xsl:template>
    
    <xsl:template match="tei:row">
        <tr>
            <xsl:apply-templates />
        </tr>
    </xsl:template>
    
    <xsl:template match="tei:cell">
        <td>
            <xsl:apply-templates />
        </td>
    </xsl:template>
    
    <xsl:template match="tei:speaker">
        <div class='speaker'>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates />
        </div>
    </xsl:template>
    
    <xsl:template match="tei:list[@type='toc']//tei:ref">
        <a href="{@target}" class="toc-link"><xsl:apply-templates /></a>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <xsl:variable name="pn" select="substring(@facs, 17, 3)"/>
        <div class="pb">
            <span class='spacer'><xsl:text> </xsl:text></span>
        </div>
        <img class='facs' src="{$facsBase}/FACS_{$pn}/view"/>
        <p class='pagenumber'><xsl:value-of select="@n"/></p>
    </xsl:template>
    
    <xsl:template match="@rend">
        <xsl:attribute name="data-rend">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="tei:*">
        <xsl:choose>
            <xsl:when test="$dbg = 1">
                <span class='error'>[<xsl:value-of select='local-name()'/>]</span>
                <xsl:apply-templates/>
                <span class='error'>[/<xsl:value-of select='local-name()'/>]</span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@* | *">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>