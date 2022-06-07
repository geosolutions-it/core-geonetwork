<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exslt="http://exslt.org/common"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                version="2.0"
                exclude-result-prefixes="#all">

    <xsl:import href="../../iso19139/process/process-utility.xsl"/>

        <xsl:template match="/gmd:MD_Metadata">
            <xsl:variable name="qualityofservice">
              <gmd:distributionInfo>
                <gmd:MD_Distribution>
                   <gmd:distributionFormat>
                      <gmd:MD_Format>
                         <gmd:name>
                            <gco:CharacterString></gco:CharacterString>
                         </gmd:name>
                         <gmd:version>
                            <gco:CharacterString></gco:CharacterString>
                         </gmd:version>
                      </gmd:MD_Format>
                   </gmd:distributionFormat>
                   <gmd:transferOptions>
                      <gmd:MD_DigitalTransferOptions>
                         <gmd:transferSize>
                            <gco:Real></gco:Real>
                         </gmd:transferSize>
                      </gmd:MD_DigitalTransferOptions>
                   </gmd:transferOptions>
                </gmd:MD_Distribution>
              </gmd:distributionInfo>
            </xsl:variable>
            <xsl:copy>
              <xsl:copy-of select="@*|node()"/>
              <xsl:copy-of select="$qualityofservice" />
            </xsl:copy>
            
    </xsl:template>

    <!-- Do a copy of every nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>