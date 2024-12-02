<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:my="http://www.example.com/functions"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" 
        include-content-type="no" indent="yes"/>
    
    <!-- Basic XSLT info -->
    <xsl:variable name="rousseauDocument" select="document('/Users/jamespaul/desktop/James-Paul-Repo_1/constitution_thinkers_repo/social_contract.xml')" />
    <xsl:variable name="montesquieuDocument" select="document('/Users/jamespaul/desktop/James-Paul-Repo_1/constitution_thinkers_repo/SOL.xml')" />
    <xsl:variable name="deciveDocument" select="document('/Users/jamespaul/desktop/James-Paul-Repo_1/constitution_thinkers_repo/DeCive_comp.xml')" />
    <xsl:variable name="lockeDocument" select="document('/Users/jamespaul/desktop/James-Paul-Repo_1/constitution_thinkers_repo/Locke_Second-Treatise.xml')" />
    <xsl:variable name="constitutionDocument" select="document('/Users/jamespaul/desktop/James-Paul-Repo_1/constitution_thinkers_repo/new_constitution.xml')" />
    <xsl:variable name="testDocument" select="document('/Users/jamespaul/desktop/digital humanities/thinker_test/Untitled1.xml')" />
    
    <!-- Function to calculate significance -->
    <xsl:function name="my:calculateSignificance" as="xs:decimal">
        <xsl:param name="thinkerDocument" />
        <xsl:param name="elementAttributePair" />
        
        <!-- Count the number of matches in the thinker's document -->
        <xsl:variable name="thinkerCount" select="count($thinkerDocument//*[name() = substring-before($elementAttributePair, ', ') and @type = substring-after($elementAttributePair, ', ')])" />
        
        <!-- Count the number of matches in the constitution document -->
        <xsl:variable name="constitutionCount" select="count($constitutionDocument//*[name() = substring-before($elementAttributePair, ', ') and @type = substring-after($elementAttributePair, ', ')])" />
        
        <!-- Calculate relative significance -->
        <xsl:variable name="significance" select="if ($constitutionCount > 0) then ($thinkerCount div $constitutionCount) else 0" />
        
        <!-- Return the significance -->
        <xsl:value-of select="$significance" />
    </xsl:function>
   
    <!-- Main template -->
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Constitution Document</title>
                <link rel="stylesheet" type="text/css" href="constitutionstyle.css"/>
                <script src="script.js"></script>
            </head>
            <body>
                <h1 style="text-align:center;">The Constitution</h1>
                <img src="american-flag.jpg" alt="flag" class="center" width="350" height="200"/>
                <xsl:apply-templates select="//meta_data"/>
                By: Zellie Winterich, Anna Costello, James Paul, Ryan Pavlone, and Cole Belling
                <hr/>
                <xsl:apply-templates select="//preamble"/>
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
                <select id="thinkerSelector" onchange="changeThinkerSelection()">
                    <option value="None">None</option>
                    <option value="rousseau">Rousseau</option>
                    <option value="montesquieu">Montesquieu</option>
                    <option value="decive">DeCive</option>
                    <option value="locke">Locke</option>
                </select>
                <svg xmlns="http://www.w3.org/2000/svg" width="300" height="200">
                    <rect x="10" y="10" width="280" height="40" fill="white" stroke="black" stroke-width="2" rx="10" ry="10"/>
                    <text x="20" y="30" font-family="Arial" font-size="14" fill="black">Significance Range</text>
                    <!-- Color Bar -->
                    <rect x="10" y="50" width="280" height="40" fill="url(#gradient)" stroke="black" stroke-width="2" rx="10" ry="10"/>
                    <text x="20" y="85" font-family="Arial" font-size="12" fill="black">Low</text>
                    <text x="230" y="85" font-family="Arial" font-size="12" fill="black">High</text>
                    <defs>
                        <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="0%">
                            <stop offset="0%" style="stop-color: #ff9e2c; stop-opacity: 1" />
                            <stop offset="25%" style="stop-color: #eaf200; stop-opacity: 1" />
                            <stop offset="50%" style="stop-color: #2ee400; stop-opacity: 1" />
                            <stop offset="75%" style="stop-color: #0099ff; stop-opacity: 1" />
                            <stop offset="100%" style="stop-color: #8100d0; stop-opacity: 1" />
                        </linearGradient>
                    </defs>
                </svg>
                <hr/>
                <xsl:apply-templates select="//section"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="//section">
        <xsl:variable name="totalRousseauSignificance" select="sum(for $element in .//* return my:calculateSignificance($rousseauDocument, concat(name($element), ', ', $element/@type)))" />
        <xsl:variable name="totalMontesquieuSignificance" select="sum(for $element in .//* return my:calculateSignificance($montesquieuDocument, concat(name($element), ', ', $element/@type)))" />
        <xsl:variable name="totalDeCiveSignificance" select="sum(for $element in .//* return my:calculateSignificance($deciveDocument, concat(name($element), ', ', $element/@type)))" />
        <xsl:variable name="totalLockeSignificance" select="sum(for $element in .//* return my:calculateSignificance($lockeDocument, concat(name($element), ', ', $element/@type)))" />
        <!-- Count the number of element-attribute pairs in this section -->
        <xsl:variable name="pairCount" select="count(.//*)" />
        <!-- Calculate average significance for each thinker -->
        <xsl:variable name="averageRousseauSignificance" select="$totalRousseauSignificance div $pairCount" />
        <xsl:variable name="averageMontesquieuSignificance" select="$totalMontesquieuSignificance div $pairCount" />
        <xsl:variable name="averageDeCiveSignificance" select="$totalDeCiveSignificance div $pairCount" />
        <xsl:variable name="averageLockeSignificance" select="$totalLockeSignificance div $pairCount" />
        <xsl:variable name="sectionName" select="section_name" />
        <div class="section" 
            data-rousseau="{format-number($averageRousseauSignificance, '0.00')}" 
            data-montesquieu="{format-number($averageMontesquieuSignificance, '0.00')}" 
            data-decive="{format-number($averageDeCiveSignificance, '0.00')}"
            data-locke="{format-number($averageLockeSignificance, '0.00')}">
            <hr/>
            <h2 style="text-align:center;">
                <xsl:value-of select="section_name"/>
            </h2>
            <xsl:for-each select="section_name">
                <h2 id="{@number}">
                    <xsl:value-of select="section_name[@type='article' or @type='amendment' or @type='preamble']"/>
                </h2>
            </xsl:for-each>
                <p style="text-align:center;"><strong>Rousseau Significance:</strong> <xsl:value-of select="format-number($averageRousseauSignificance, '0.00')" /></p>
                <p style="text-align:center;"><strong>Montesquieu Significance:</strong> <xsl:value-of select="format-number($averageMontesquieuSignificance, '0.00')" /></p>
                <p style="text-align:center;"><strong>DeCive Significance:</strong> <xsl:value-of select="format-number($averageDeCiveSignificance, '0.00')" /></p>
                <p style="text-align:center;"><strong>Locke Significance:</strong> <xsl:value-of select="format-number($averageLockeSignificance, '0.00')" /></p>
            <p> 
                <xsl:value-of select="text() | (consent_of_governed | inherent_rights | criminal_justice | purposes_of_law | legal_documents | legislative_body | judicial_body | executive_body | limits_of_power)"/>
            </p>
            <!-- Calculate significance for each thinker in this section -->
            <xsl:for-each select="sub_section">
                    <h3 style="text-align:center;">
                        <xsl:value-of select="subsection_name"/>
                    </h3>
                    <xsl:for-each select="subsection_name">
                        <h3 id="{@number}">
                            <xsl:value-of select="subsection_name"/>
                        </h3>
                    </xsl:for-each>
                    <p>
                        <xsl:value-of select="text() | (consent_of_governed | inherent_rights | criminal_justice | purposes_of_law | legal_documents | legislative_body | judicial_body | executive_body | limits_of_power)"/>
                    </p>
            </xsl:for-each>
            <hr/>
        </div>
    </xsl:template>
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
        <xsl:for-each select="sub_section">
            <li>
                <i style="font-weight:bold;">
                    Section:
                </i>
                <xsl:for-each select="subsection_name">
                    <i>
                        <a href="#{@number}">
                            <xsl:value-of select="@number"/>
                        </a>
                    </i>
                </xsl:for-each>
            </li>
        </xsl:for-each>
    </xsl:template>
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
    
    <xsl:template match="preamble//section">
        <div class="preamble">
            <hr/>
            <h2 style="text-align:center;">
                <xsl:value-of select="section_name"/>
            </h2>
            <!-- Only select section names of type 'article', 'amendment', or 'preamble' -->
            <xsl:for-each select="section_name[@type='article' or @type='amendment' or @type='preamble']">
                <h2>
                    <xsl:value-of select="."/>
                </h2>
            </xsl:for-each>
            
            <!-- Loop through sub-sections and display subsection names -->
            <xsl:for-each select="sub_section">
                <div class="sub_section">
                    <h3 style="text-align:center;">
                        <xsl:value-of select="subsection_name"/>
                    </h3>
                    
                    <!-- Display any specific details about the subsection -->
                    <p style="text-align:center; font-style:italic;">
                        <xsl:value-of select="text() | (consent_of_governed | inherent_rights | criminal_justice | purposes_of_law | legal_documents | legislative_body | judicial_body | executive_body | limits_of_power)"/>
                    </p>
                </div> 
            </xsl:for-each>
            <hr/>
        </div>
    </xsl:template>
    
    <!-- this is for the preamble text -->
    

    <!-- this sets the style, layout, and text for all of the constitution text -->
</xsl:stylesheet>