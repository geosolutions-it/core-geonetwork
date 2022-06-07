<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:geonet="http://www.fao.org/geonetwork"
    exclude-result-prefixes="#all">

    <!--
      Usage:
        zamg_anonymizer
        * remove gmd:MD_DataIdentification/gmd:pointOfContact/ with role principalInvestigator
        * remap thesauri URL
        * add a default metadata PoC
    -->

    <!-- Remove all resources contact which have role principalInvestigator -->
    <xsl:template match="gmd:identificationInfo/*/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator']" priority="2"/>

    <!-- Remove individual names -->
    <xsl:template match="gmd:individualName" priority="2"/>

    <!-- Replace the metadata contact to the institutional fixed one -->
    <xsl:template match="gmd:MD_Metadata" priority="2">
        <xsl:copy>
           <xsl:apply-templates select="@*"/>

            <xsl:apply-templates select="gmd:fileIdentifier"/>
            <xsl:apply-templates select="gmd:language"/>
            <xsl:apply-templates select="gmd:characterSet"/>
            <xsl:apply-templates select="gmd:parentIdentifier"/>
            <xsl:apply-templates select="gmd:hierarchyLevel"/>
            <xsl:apply-templates select="gmd:hierarchyLevelName"/>

            <xsl:call-template name="zamg_poc_snippet"/>

            <xsl:apply-templates select="child::* except (gmd:fileIdentifier|gmd:parentIdentifier|gmd:language|gmd:characterSet|gmd:hierarchyLevel|gmd:hierarchyLevelName|gmd:contact)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="zamg_poc_snippet">
          <gmd:contact>
            <gmd:CI_ResponsibleParty>
                <gmd:organisationName>
                    <gco:CharacterString>ZAMG - Zentralanstalt für Meteorologie und Geodynamik</gco:CharacterString>
                </gmd:organisationName>
                <gmd:contactInfo>
                    <gmd:CI_Contact>
                        <gmd:address>
                            <gmd:CI_Address>
                                <gmd:electronicMailAddress>
                                    <gco:CharacterString>inspire-md@zamg.ac.at</gco:CharacterString>
                                </gmd:electronicMailAddress>
                            </gmd:CI_Address>
                        </gmd:address>
                        <gmd:onlineResource>
                            <gmd:CI_OnlineResource>
                                <gmd:linkage>
                                    <gmd:URL>http://www.zamg.ac.at</gmd:URL>
                                </gmd:linkage>
                                <gmd:protocol>
                                    <gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
                                </gmd:protocol>
                            </gmd:CI_OnlineResource>
                        </gmd:onlineResource>
                    </gmd:CI_Contact>
                </gmd:contactInfo>
                <gmd:role>
                    <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
                                     codeListValue="pointOfContact"/>
                </gmd:role>
            </gmd:CI_ResponsibleParty>
          </gmd:contact>
    </xsl:template>


    <!-- Remap URLs for thesauri:
      <gmx:Anchor xlink:href="http://vmetad1/geonetwork/srv/ger/thesaurus.download?ref=external.theme.zamg-variable">geonetwork.thesaurus.external.theme.zamg-variable</gmx:Anchor>
      <gmx:Anchor xlink:href="http://vmetad1/geonetwork/srv/ger/thesaurus.download?ref=external.place.regions">geonetwork.thesaurus.external.place.regions</gmx:Anchor>
    -->
    <xsl:template match="gmx:Anchor[contains(@xlink:href, '/thesaurus.download?ref=')]">
        <xsl:variable name="remapped" select="replace(@xlink:href, 'http://.*?/geonetwork/srv/[a-z]{2,3}/', 'http://catalog.zamg.ac.at/geonetwork/srv/ger/')"/>
        <gmx:Anchor>
            <xsl:attribute name="xlink:href"><xsl:value-of select="$remapped"/></xsl:attribute>
            <xsl:value-of select="text()"/>
        </gmx:Anchor>
    </xsl:template>


    <!-- Do a copy of every nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Always remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
