<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" 
        include-content-type="no" indent="yes"/>
    <!-- basic XSLT info -->
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>DeCive</title>
                <link rel="stylesheet" type="text/css" href="constitutionstyle.css"/>
       
                
            </head>
            <body>
               
                <h1 style="text-align:center;">DeCive</h1>
                <xsl:apply-templates select="//meta_data"/>
                By: Anna Costello
                <hr/>
                <h2 style="text-align:left;">Table of Contents</h2>
                <hr/>
                <ul>
                    <xsl:apply-templates select="//section" mode="toc">
                        <xsl:sort>
                            <xsl:value-of select="translate('','''', @number)"/>
                        </xsl:sort>
                    </xsl:apply-templates>
                </ul>
                <hr/>
                <xsl:apply-templates select="//section"/>
            </body>
        </html>
    </xsl:template>
    <!-- template for the doc -->
    
    <xsl:template match="//section" mode="toc">
        <li>  
            <h2 style="font-style:italic;">
                <xsl:for-each select="section_name">
                    <a href="#{@number}">
                        <xsl:value-of select="@number"/>
                        <xsl:text>.</xsl:text>
                    </a>
                </xsl:for-each>
            </h2>
        </li>
    </xsl:template>
    <!-- table of contents linkage to chapters -->
    
    <xsl:template match="//meta_data">
        <div class="meta_data">
            <p style="text-align:center; font-family: Lucida Handwriting, cursive">
                <i>
                    <xsl:value-of select="."/>
                </i>
            </p>
        </div>
    </xsl:template> 
    <!-- this is for the metadata text -->
    
    <xsl:template match="//section">
        <div class="section">
            <hr/>
            <h2 style="text-align:center;">
                <xsl:value-of select="section_name"/>
            </h2>
            <xsl:for-each select="section_name">
                <h2 id="{@number}">
                    <xsl:value-of select="section_name[@type='article' or @type='amendment' or @type='preamble']"/>
                </h2>
            </xsl:for-each>
            <div class="sub_section">
                <h3 style="text-align:center;">
                    <xsl:value-of select="subsection_name"/>
                </h3>
                
            </div>
            <p> 
                <xsl:value-of select="text() | (consent_of_governed | inherent_rights | criminal_justice | purposes_of_law | legal_documents | legislative_body | judicial_body | executive_body | limits_of_power)"/>
            </p>
            <hr/>
        </div>
    </xsl:template>
    <!-- this sets the style, layout, and text for all of the DeCive text -->
</xsl:stylesheet>