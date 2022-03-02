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
            <xd:p>This stylesheet handles all of the processing of the Lyrical Ballads
            TEI into HTML. It does so in two passes: the first pass 
            flattens the documents to allow for a page-based hierarchy for 
            viewing (converting from TEI to TEI); the second pass converts
            the flattened TEI into HTML.</xd:p>
        </xd:desc>
    </xd:doc>
    
    
    <xsl:mode name="tei" on-no-match="shallow-skip"
        _warning-on-no-match="{string($verbose)}"/>
    <xsl:mode name="raise" on-no-match="shallow-copy"
        _warning-on-no-match="{string($verbose)}"/>
    <xsl:mode name="flatten" on-no-match="shallow-copy"
        _warning-on-no-match="{string($verbose)}"/>
    
    <xsl:accumulator name="stanza" initial-value="0">
        <xsl:accumulator-rule match="lg[l]" select="$value + 1"/>
    </xsl:accumulator>
    
    <xsl:accumulator name="line" initial-value="0">
        <xsl:accumulator-rule match="lg[l]" select="0"/>
        <xsl:accumulator-rule match="l" select="$value + 1"/>
    </xsl:accumulator>
    
    <xsl:accumulator name="line-id" initial-value="''">
        <xsl:accumulator-rule match="lg/l" 
            select="'l' || accumulator-before('stanza') || '.' || accumulator-after('line')"/>
    </xsl:accumulator>
    
    <xd:doc>
        <xd:desc>Root document handling, which flattens the text first
        and then converts the flattened TEI into HTML.</xd:desc>
    </xd:doc>
    <xsl:template match="TEI" mode="tei">
        <xsl:variable name="flattened" as="document-node()">
            <xsl:apply-templates select="/" mode="flatten"/>
        </xsl:variable>
        <xsl:apply-templates select="$flattened//text" mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Just skip the text</xd:desc>
    </xd:doc>
    <xsl:template match="text" mode="tei">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Create the page-based hierarchy from the front,
        body, and back by grouping by page beginnings.</xd:desc>
    </xd:doc>
     <xsl:template match="front | body | back" mode="tei">
         <section id="{local-name()}">
             <xsl:call-template name="processAtts"/>
             <xsl:choose>
                 <xsl:when test="descendant::pb">
                     <xsl:for-each-group select="node()"
                         group-starting-with="self::pb">
                         <xsl:variable name="pb"
                             select="current-group()[1]/self::pb" as="element(pb)?"/>
                         <!--Create the page and split into two columns-->
                         <xsl:if test="exists($pb)">
                             <section class="page">
                                 <xsl:attribute name="id" 
                                     select="'p' || ($pb/@n, generate-id($pb))[1]"/>
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
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:apply-templates select="node()" mode="#current"/>
                 </xsl:otherwise>
             </xsl:choose>
            
         </section>
     </xsl:template>
     
    <xd:doc>
        <xd:desc>Block bibliographic elements</xd:desc>
    </xd:doc>
    <xsl:template match="titlePage | docTitle | docImprint" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Main titles</xd:desc>
    </xd:doc>
    <xsl:template match="titlePart | titlePart[@type='main']" mode="tei">
        <h1>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </h1>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Headings aren't necessarily styled in any way,
        so we just make these divs.</xd:desc>
    </xd:doc>
    <xsl:template match="head" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Subtitles</xd:desc>
    </xd:doc>
    <xsl:template match="titlePart[@type='sub']" mode="tei">
        <h2>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </h2>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Simple div to div processing</xd:desc>
    </xd:doc>
    <xsl:template match="div" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Just skip inline semantic tagging.</xd:desc>
    </xd:doc>
    <xsl:template match="pubPlace | publisher | docDate | placeName | bibl" mode="tei">
        <xsl:apply-templates  mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Arguments are paragraph like blocks.</xd:desc>
    </xd:doc>
    <xsl:template match="argument" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates  mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Line groups; we have to make these divs since they are often
        nested.</xd:desc>
    </xd:doc>
    <xsl:template match="lg" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Poetic lines</xd:desc>
    </xd:doc>
    <xsl:template match="l" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>

   
   <xd:doc>
       <xd:desc>Most lineation is handled via the line
       elements, but there are some line beginnings in titles,
       arguments, etc.</xd:desc>
   </xd:doc>
    <xsl:template match="lb" mode="tei">
        <br/>
    </xsl:template>
   
    <xd:doc>
        <xd:desc>Most titles are block level headings
        of some sort.</xd:desc>
    </xd:doc>
    <xsl:template match="title" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Except for the special case of a title
        being in a bibl, which is inline</xd:desc>
    </xd:doc>
    <xsl:template match="bibl/title" mode="tei">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>

    <xd:doc>
        <xd:desc>Inline elements that may have some styling 
        added to them.</xd:desc>
    </xd:doc>
    <xsl:template match="seg | span | hi | w" mode="tei">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Figures denote the horizontal rules in the text.</xd:desc>
    </xd:doc>
    <xsl:template match="figure" mode="tei">
        <hr>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </hr>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Special staticSearch div</xd:desc>
    </xd:doc>
    <xsl:template match="div[@xml:id='staticSearch']" mode="tei">
        <div id="staticSearch">
            <!--No content-->
        </div>
    </xsl:template>

    <xd:doc>
        <xd:desc>Paragraphs can be HTML paragraphs.</xd:desc>
    </xd:doc>
    <xsl:template match="p" mode="tei">
        <p>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Inline pointers that refer to anchored notes.</xd:desc>
    </xd:doc>
    <xsl:template match="ptr" mode="tei">
        <a href="{@target}" class="footnote" id="{@xml:id}"><xsl:value-of select="@n"/></a>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Main handling for notes. We have to fork here
        since there are two types: 1) Notes in the original that are anchored
        via pointers; 2) Editorial notes that do not have anchors</xd:desc>
    </xd:doc>
    <xsl:template match="note" priority="2" mode="tei">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="tg" select="concat('#', $id)"/>
        <xsl:variable name="ptr" select="//ptr[@target=$tg]" as="element(ptr)?"/>
        <xsl:variable name="ptrId" 
            select="if ($ptr) then $ptr/@xml:id else (@xml:id || '_ptr')"
            as="xs:string"/>
        <xsl:if test="not($ptr)">
            <a href="#{@xml:id}" class="footnote editorial" id="{$ptrId}">*</a>
        </xsl:if>
        <xsl:next-match>
            <xsl:with-param name="ptrId" select="$ptrId" as="xs:string"/>
            <xsl:with-param name="editorial" select="empty($ptr)" as="xs:boolean"/>
        </xsl:next-match>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Generic note handling</xd:desc>
        <xd:param name="ptrId">The id for the pointer (which may or may not exist
        in the source)</xd:param>
        <xd:param name="editorial">Whether this is an editorial note</xd:param>
    </xd:doc>
    <xsl:template match="note" mode="tei">
        <xsl:param name="ptrId" as="xs:string"/>
        <xsl:param name="editorial" as="xs:boolean"/>
        <p class="footnote{if ($editorial) then ' editorial' else ()}" id="{@xml:id}">
            <xsl:if test="$editorial">
                <xsl:text>*</xsl:text>
            </xsl:if>
            <xsl:apply-templates  mode="#current"/>
            <a href="#{$ptrId}" class="back">[back]</a>
        </p>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Handling for numbered versus unnumbered lists; since
        HTML lists can't have heads, we have to move the head out of the
        regular sequence.</xd:desc>
    </xd:doc>
    <xsl:template match="list" mode="tei">
        <xsl:apply-templates select="head" mode="#current"/>
        <xsl:element name="{if (@type='numbered') then 'ol' else 'ul'}">
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates select="item" mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Basic list items</xd:desc>
    </xd:doc>
    <xsl:template match="item" mode="tei">
        <li>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </li>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Dramatic speeches are usually blocks.</xd:desc>
    </xd:doc>
    <xsl:template match="sp" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Speakers contained within speeches.</xd:desc>
    </xd:doc>
    <xsl:template match="speaker" mode="tei">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Basic table handling; these occur only in the errata.</xd:desc>
    </xd:doc>
    <xsl:template match="table" mode="tei">
        <table>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </table>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Table rows</xd:desc>
    </xd:doc>
    <xsl:template match="row" mode="tei">
        <tr>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </tr>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Table cells</xd:desc>
    </xd:doc>
    <xsl:template match="cell" mode="tei">
        <td>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </td>
    </xsl:template>

    <xd:doc>
        <xd:desc>Special table of contents list, which has references to the poems
        on the homepage.</xd:desc>
    </xd:doc>
    <xsl:template match="list[@type='toc']//ref" mode="tei">
        <a href="{replace(@target,'\.xml$','.html')}" class="toc-link"><xsl:apply-templates  mode="#current"/></a>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Since page beginnings are already handled by the grouping
        mechanism, we can make page beginnings images.</xd:desc>
    </xd:doc>
    <xsl:template match="pb" mode="tei">
        <xsl:variable name="link" select="dhil:facsLink(@facs)" as="xs:string"/>
        <a href="{$link}" target="_blank" rel="noopener noreferrer">
            <img src="{$link}" loading="lazy"/>
        </a>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Just copy out text.</xd:desc>
    </xd:doc>
    <xsl:template match="text()" mode="tei">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Special attribute handling: this template,
        which should be applied on almost every element, handles
        the class name creation (where each TEI element has a corresponding
        tei-{local-name()} class) as well as handling for any other element.</xd:desc>
        <xd:param name="class">A sequence of class names to add, if any additional
        are needed.</xd:param>
    </xd:doc>
    <xsl:template name="processAtts" as="attribute()*">
        <xsl:param name="class" as="xs:string*"/>
        <xsl:variable name="ident" select="'tei-' || local-name()" as="xs:string"/>
        <xsl:attribute name="class" 
            select="string-join(($class, $ident, @type), ' ')"/>
        <xsl:apply-templates select="@*" mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Anything with an id should have one in the output;
        this makes search results much better.</xd:desc>
    </xd:doc>
    <xsl:template match="@xml:id" mode="tei">
        <xsl:attribute name="id" select="."/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Magic rend tokens are converted into inline styles.</xd:desc>
    </xd:doc>
    <xsl:template match="@rend" mode="tei">
        <xsl:attribute name="style" separator="; ">
            <xsl:for-each select="tokenize(.)">
                <xsl:sequence select="dhil:translate_rend(.)"/>
            </xsl:for-each>
        </xsl:attribute>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>Function to create a facsimile link; the facsimiles
        are linked as PNGs in the original, but we create JPG thumbnails.
        This function is simply an alias for the 2 argument dhil:facsLink function.</xd:desc>
        <xd:param name="facs">The string URI for the facsimile.</xd:param>
    </xd:doc>
    <xsl:function name="dhil:facsLink" as="xs:string">
        <xsl:param name="facs"/>
        <xsl:sequence select="'facs/' || replace($facs,'.png', '.jpg')"/>
    </xsl:function>
    
  
    <xd:doc>
        <xd:desc>XSLT adaptation of mjoyce's PHP code for translating rend tokens that may either be a simple string or some sort of instruction (i.e. indent(5mm)).</xd:desc>
        <xd:param name="token">The rend token to process</xd:param>
    </xd:doc>
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
            <!--Don't do anything with left since left is the default
                anyway-->
            <xsl:when test="$ident = ('left')"/>
            <!--Just do nothing with first indent since we don't have the facsimile
                to show for it-->
            <xsl:when test="$ident = ('first-indent')"/>
            <xsl:otherwise>
                <xsl:message>ERROR: UNKNOWN REND TOKEN: <xsl:value-of select="$ident"/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
  
    <xd:doc>
        <xd:desc>This is a much cruder version of mjoyce's mm conversion, but it appears to give more-or-less correct results.</xd:desc>
        <xd:param name="token">The rend token to process</xd:param>
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
    
  
    <xd:doc>
        <xd:desc>Handling for flattening the TEI to create a page-based hierarchy.</xd:desc>
    </xd:doc>
    <xsl:template match="TEI" mode="flatten">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:choose>
                <xsl:when test="descendant::pb">
                    <xsl:apply-templates select="node()" mode="#current"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>For each of the front, body, and back (which we assume
        does not cross page boundaries), flatten the content.</xd:desc>
    </xd:doc>
    <xsl:template match="front | body | back " mode="flatten">
        <xsl:copy>
            <xsl:sequence select="@*"/>
            <xsl:sequence select="node() ! dhil:flatten(.)"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Recursive function to flatten a node to "raise" the page beginnings
        out from the hierarchy. This is inspired by: 
        Birnbaum, David J., Elisa E. Beshero-Bondar and C. M. Sperberg-McQueen.
        “Flattening and unflattening XML markup: a Zen garden of XSLT and other tools.”
        Presented at Balisage: The Markup Conference 2018, Washington, DC, July 31 - August 3,
        2018. In Proceedings of Balisage: The Markup Conference 2018. 
        Balisage Series on Markup Technologies, vol. 21 (2018).
        </xd:desc>
        <xd:param name="node">The node to try and flatten.</xd:param>
    </xd:doc>
    <xsl:function name="dhil:flatten">
        <xsl:param name="node"/>
        <xsl:variable name="test" as="node()*">
            <xsl:apply-templates select="$node" mode="raise"/>
        </xsl:variable>
        <xsl:for-each select="$test">
            <xsl:choose>
                <xsl:when test="descendant::pb">
                    <xsl:sequence select="dhil:flatten(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Add ids to all of the line elements at this stage to retain
            the proper lineation and accurate line numbering in the ids.</xd:desc>
    </xd:doc>
    <xsl:template match="l" mode="raise">
        <xsl:copy>
            <xsl:attribute name="xml:id" select="accumulator-before('line-id')"/>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Lift out the pb from its parent</xd:desc>
    </xd:doc>
    <xsl:template match="*[pb]" mode="raise">
        <xsl:variable name="this" select="."/>
        <xsl:choose>
            <!--If a line group begins with a page beginning, we
                can just simply move the page beginning out
                and process the rest of the contents-->
            <xsl:when test="self::lg and child::*[1]/self::pb">
                <xsl:variable name="pb" select="child::*[1]/self::pb"/>
                <xsl:sequence select="$pb"/>
                <xsl:copy>
                    <xsl:apply-templates select="@* | (node() except $pb)" mode="#current"/>
                </xsl:copy>
            </xsl:when>
            
            <!--Otherwise, we have to do a more complicated grouping where we
                split the containing element around the page beginning -->
            <xsl:otherwise>
                <xsl:for-each-group select="node()" group-ending-with="self::pb">
                    <xsl:variable name="pb" select="current-group()[last()]"/>
                    <xsl:element
                        namespace="http://www.tei-c.org/ns/1.0"
                        name="{local-name($this)}">
                        <xsl:sequence select="$this/@*"/>
                        <xsl:apply-templates 
                            select="current-group() except $pb" mode="#current"/>
                    </xsl:element>
                    <xsl:sequence select="$pb"/>
                </xsl:for-each-group>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    
    
</xsl:stylesheet>