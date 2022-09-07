<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:exslt="http://exslt.org/common"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:xslutil="java:org.fao.geonet.util.XslUtil"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                exclude-result-prefixes="#all">


  <!-- **************************************** -->
  <!-- ********** ZAMG Custom fields ********** -->
  <!-- **************************************** -->

  <!-- ====== Topic catagory code ========== -->
  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode[$tab='zamg_tab_simple1' or $tab='zamg_tab_simple2']" >
      <xsl:message>ZAMG topic cat <xsl:value-of select="text()"/>  </xsl:message>
      <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(..), $labels)"/>
      <xsl:with-param name="value" select="text()" />
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="type" select="'select'"/>
      <xsl:with-param name="listOfValues" select="/root/gui/schemas/iso19139/codelists/codelist[@name='gmd:MD_TopicCategoryCode']"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="false()"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ======== Restrictions ======== -->
  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints[$tab='zamg_tab_simple1' or $tab='zamg_tab_simple2']" >
    <xsl:variable name="selected" select="gmd:MD_RestrictionCode/text()" />
    <xsl:variable name="coderef" select="gmd:MD_RestrictionCode/gn:element/@ref" />
    <br />
    <div class="row">
      <label for="zamg_restriction" class="control-label col-xs-2"><xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_restriction/title"/></label>
      <!--<div class="col-xs-1"/>-->
      <div class="col-sm-9">
        <select id="zamg_restrictions" class="col-xs-4" onchange="setRestrictionZAMG()">
          <xsl:if test="/root/gui/currTab/text()='zamg_tab_simple1'">
            <xsl:attribute name="disabled"/>
          </xsl:if>
          <option value="license" id="zamg_restrictions_license">
            <xsl:if test="$selected = 'license'">
              <xsl:attribute name="selected"/>
            </xsl:if>
            <xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_restriction/license"/>
          </option>
          <option value="restricted" id="zamg_restrictions_restricted">
            <xsl:if test="$selected = 'restricted'">
              <xsl:attribute name="selected"/>
            </xsl:if>
            <xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_restriction/restricted"/>
          </option>
        </select>
      </div>
    </div>
    <br />
    <input type="hidden" id="restrictionId" value="{$selected}" readonly="true">
      <xsl:attribute name="name">_<xsl:value-of select="$coderef"/></xsl:attribute>
    </input>
    <script>
      function setRestrictionZAMG(){
        var hidden = $("#restrictionId");
        if($("#zamg_restrictions_license").is(":selected")){
          hidden.val("license");
        }
        if($("#zamg_restrictions_restricted").is(":selected")){
          hidden.val("restricted");
        }
      }
    </script>
  </xsl:template>

  <!-- ============= Section Extent ============= -->
  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox[$tab='zamg_tab_simple1' or $tab='zamg_tab_simple2']" >
    <br />

    <div class="row">
      <div class="col-xs-6" id="zamg_northBoundLatitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="$labels/element[@name='zamg_short_north']"/>
          <xsl:with-param name="value" select="gmd:northBoundLatitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:northBoundLatitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:northBoundLatitude/gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-6" id="zamg_westBoundLongitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="$labels/element[@name='zamg_short_west']"/>
          <xsl:with-param name="value" select="gmd:westBoundLongitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:westBoundLongitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-6" id="zamg_southBoundLatitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="$labels/element[@name='zamg_short_south']"/>
          <xsl:with-param name="value" select="gmd:southBoundLatitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:southBoundLatitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:southBoundLatitude/gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-6" id="zamg_eastBoundLongitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="$labels/element[@name='zamg_short_east']"/>
          <xsl:with-param name="value" select="gmd:eastBoundLongitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:eastBoundLongitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:eastBoundLongitude/gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>

  <!-- ============= Section CRS ============= -->
  <xsl:template mode="mode-iso19139" priority="2000" match="gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code[$tab='zamg_tab_simple1' or $tab='zamg_tab_simple2']" >

      <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="$labels/element[@name='gmd:referenceSystemIdentifier']"/>
      <xsl:with-param name="value" select="gco:CharacterString/text()"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="'select'"/>
      <xsl:with-param name="listOfValues" select="/root/gui/schemas/iso19139/codelists/codelist[@name='zamgCrs']"/>
      <xsl:with-param name="name" select="gco:CharacterString/gn:element/@ref"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="false()"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ============= Section Resolution ============= -->
  <xsl:template mode="mode-iso19139" priority="2000" match="gmd:MD_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:resolution[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" >
    <div class="row">
      <div class="col-xs-6">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamgTimeResolution.label"/>
          <xsl:with-param name="value" select="gco:Measure/text()"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
          <xsl:with-param name="name" select="gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-6">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamg_uom"/>
          <xsl:with-param name="value" select="gco:Measure/@uom"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
          <xsl:with-param name="name" select="gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>

  <xsl:template mode="mode-iso19139" priority="2000" match="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:distance[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" >
    <div class="row">
      <div class="col-xs-6">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </div>
      <div class="col-xs-6">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamg_uom"/>
          <xsl:with-param name="value" select="gco:Distance/@uom"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
          <xsl:with-param name="name" select="gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>

<!-- ***************************************** -->
<!-- ********* ZAMG CUSTOM keywords   ******** -->
<!-- ***************************************** -->

  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:descriptiveKeywords[$tab='zamg_tab_simple1' or $tab='zamg_tab_simple2']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>

    <xsl:message>ZAMG keyword BOX - tab <xsl:value-of select="$tab"/>  </xsl:message>

    <xsl:call-template name="render-boxed-element-noborder">
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="subTreeSnippet">
        <xsl:apply-templates mode="mode-iso19139" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template mode="XXXmode-iso19139"  priority="3000"
    match="gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()='geonetwork.thesaurus.external.theme.zamg-datatype'] |
           gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()='geonetwork.thesaurus.external.theme.zamg-sourcetype'] |
           gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()='geonetwork.thesaurus.external.theme.zamg-uom']">

    <xsl:variable name="labelName" select="gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()"/>
    <!--<xsl:variable name="labelThesaurus" select="/root/gui/schemas/iso19139/strings/zamgThesaurus/label[@name=$labelName]"/>-->

    <xsl:variable name="thesaurus" select="substring-after($labelName, 'geonetwork.thesaurus.')"/>
    <xsl:variable name="tname" select="substring-after($labelName, 'theme.')"/>
    <!--<xsl:variable name="labelThesaurus" select="/root/gui/schemas/iso19139/strings/zamgThesaurus/*[local-name()=$tname]"/>-->
    <xsl:variable name="labelThesaurus" select="$labels/element[@name=$tname]"/>

    <xsl:message>ZAMG keyword  === tab <xsl:value-of select="$tab"/> === thesaurus <xsl:value-of select="$thesaurus"/> === labelThesaurus <xsl:value-of select="labelThesaurus"/> === labelName <xsl:value-of select="$labelName"/> </xsl:message>
    <xsl:message>ZAMG TLABEL === tname <xsl:value-of select="$tname"/> === labelThesaurus <xsl:value-of select="$labelThesaurus"/> </xsl:message>

    <div class="row">
      <div class="col-xs-2" />
      <xsl:variable name="value" select="gmd:keyword/(gco:CharacterString|gmx:Anchor)/text()"/>
      <xsl:variable name="ref" select="concat('_',gmd:keyword/(gco:CharacterString|gmx:Anchor)/gn:element/@ref)"/>
      <div>
        <xsl:comment>RENDERING KEYWORD CHOOSER FOR <xsl:value-of select="$tname"/> </xsl:comment>
        <xsl:call-template name="render-element">
            <xsl:with-param name="label" select="$labelThesaurus"/>
            <xsl:with-param name="value" select="$value"/>
            <xsl:with-param name="cls" select="local-name()"/>
            <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
            <xsl:with-param name="type" select="'select'"/>
            <xsl:with-param name="listOfValues" select="gn-fn-metadata:getCodeListValues($schema, '', $codelists, .)"/>
            <xsl:with-param name="name" select="gmd:keyword/(gco:CharacterString|gmx:Anchor)/gn:element/@ref"/>
            <xsl:with-param name="editInfo" select="gmd:keyword/(gco:CharacterString|gmx:Anchor)/gn:element"/>
            <xsl:with-param name="parentEditInfo" select="gn:element"/>
            <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <xsl:variable name="id" select="concat('gn-field-',gmd:keyword/(gco:CharacterString|gmx:Anchor)/gn:element/@ref)"/>
      <script>
        $.ajax({
          beforeSend: function(xhr){xhr.setRequestHeader("Accept", "application/json");},
          url: "../api/registries/vocabularies/search?" + 
               $.param(
                    {"type": "CONTAINS",
                     "thesaurus":  "<xsl:value-of select="$thesaurus" />",
                     "rows": "200",
                     "lang": "<xsl:value-of select="$lang" />"}
                )
        }).done(function( json ) {
          var selectElem = $('#<xsl:value-of select="$id" />');
          console.log("CLEAN elem <xsl:value-of select="$id" /> THESAURUS <xsl:value-of select="$thesaurus" />");
          selectElem.children().remove();

          for(id in json){
              var elem = json[id];
              //alert(JSON.stringify(elem));
              //selectElem.append($('&lt;option/&gt;',{}).val(elem.uri.split('#')[1]).text(elem.value));
              selectElem.append(new Option(elem.value, elem.uri.split('#')[1]));
              //selectElem.append($(new Option(elem.value, elem.uri.split('#')[1])));

              //console.log("APPEND " + elem.value + " to  <xsl:value-of select="$id" /> THESAURUS <xsl:value-of select="$thesaurus" />");
            }
            selectElem.val('<xsl:value-of select="$value" />');
            //alert("XXX Added options to <xsl:value-of select="$thesaurus" />");
        });
      </script>
    </div>
  </xsl:template>

  <xsl:template mode="XXXXXmode-iso19139"  priority="3000"
    match="gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()='geonetwork.thesaurus.external.theme.zamg-variable']">

    <xsl:variable name="labelName" select="gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()"/>
<!--    <xsl:variable name="labelThesaurus" select="$strings/zamgThesaurus/label[@name=$labelName]"/>-->
    <xsl:variable name="tname" select="substring-after($labelName, 'theme.')"/>
    <xsl:variable name="labelThesaurus" select="$labels/element[@name=$tname]"/>

    <xsl:message>ZAMG keyword VAR === tab <xsl:value-of select="$tab"/> === labelThesaurus <xsl:value-of select="labelThesaurus"/> === labelName <xsl:value-of select="$labelName"/></xsl:message>

    <xsl:variable name="thesaurus" select="substring-after($labelName, 'geonetwork.thesaurus.')"/>
    <xsl:for-each select="gmd:keyword">
      <div class="row">
        <br />
        <xsl:variable name="value" select="(gco:CharacterString|gmx:Anchor)/text()"/>
        <div>
          <xsl:call-template name="render-element">
            <xsl:with-param name="label" select="$labelThesaurus"/>
            <xsl:with-param name="value" select="$value"/>
            <xsl:with-param name="cls" select="local-name()"/>
            <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
            <xsl:with-param name="type" select="'select'"/>
            <xsl:with-param name="listOfValues" select="gn-fn-metadata:getCodeListValues($schema, '', $codelists, .)"/>
            <xsl:with-param name="name" select="(gco:CharacterString|gmx:Anchor)/gn:element/@ref"/>
            <xsl:with-param name="editInfo" select="(gco:CharacterString|gmx:Anchor)/gn:element"/>
            <xsl:with-param name="parentEditInfo" select="gn:element"/>
            <xsl:with-param name="isDisabled" select="false()"/>
          </xsl:call-template>
        </div>
        <xsl:variable name="id" select="concat('gn-field-',(gco:CharacterString|gmx:Anchor)/gn:element/@ref)"/>
        <script>
        $.ajax({
          beforeSend: function(xhr){xhr.setRequestHeader("Accept", "application/json");},
          url: "../api/registries/vocabularies/search?" +
               $.param(
                    {"type": "CONTAINS",
                     "thesaurus":  "<xsl:value-of select="$thesaurus" />",
                     "rows": "200",
                     "lang": "<xsl:value-of select="$lang" />"}
                )
        }).done(function( json ) {
            console.log("CLEAN elem <xsl:value-of select="$id" /> THESAURUS <xsl:value-of select="$thesaurus" />");
            var selectElem = $('#<xsl:value-of select="$id" />');
            selectElem.children().remove();
            for(id in json){
                var elem = json[id];
                selectElem.append(new Option(elem.value, elem.uri.split('#')[1]));
            }
            selectElem.val('<xsl:value-of select="$value" />');
          });
        </script>
      </div>
    </xsl:for-each>

    <div>
      <xsl:if test="position() = 1">
        <p class="text-center">
          <a href="http://vmetad1/mdparams" target="_blank">http://vmetad1/mdparams</a>
        </p>
      </xsl:if>
    </div>
  </xsl:template>



    <!--
    Render a boxed element in a fieldset with no border

    eg.
    <gmd:contact>
      ...
      <geonet:element
        ref="8" parent="1" uuid="gmd:contact_4c081293-de4f-4231-abdc-88952894711d"
        min="1" max="10000" add="true"/>
  -->
  <xsl:template name="render-boxed-element-noborder">
    <xsl:param name="value"/>
    <xsl:param name="errors" required="no"/>
    <xsl:param name="editInfo" required="no"/>
    <!-- The content to put into the box -->
    <xsl:param name="subTreeSnippet" required="yes" as="node()"/>
    <!-- cls may define custom CSS class in order to activate
    custom widgets on client side -->
    <xsl:param name="cls" required="no"/>
    <!-- XPath is added as data attribute for client side references
    to get help or inline editing ? -->
    <xsl:param name="xpath" required="no"/>
    <xsl:param name="attributesSnippet" required="no"><null/></xsl:param>
    <xsl:param name="isDisabled" select="ancestor::node()[@xlink:href]"/>


    <xsl:variable name="hasXlink" select="@xlink:href"/>

    <div id="{concat('gn-el-', $editInfo/@ref)}" >
      <xsl:if test="count($attributesSnippet/*) > 0">
        <div class="well well-sm gn-attr {if ($isDisplayingAttributes) then '' else 'hidden'}">
          <xsl:copy-of select="$attributesSnippet"/>
        </div>
      </xsl:if>

      <xsl:if test="normalize-space($errors) != ''">
        <xsl:for-each select="$errors/errors/error">
          <div class="alert alert-danger">
            <xsl:value-of select="."/>
          </div>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="$subTreeSnippet">
        <xsl:copy-of select="$subTreeSnippet"/>
      </xsl:if>
    </div>
  </xsl:template>


  <!-- ===================================================================== -->
  <!-- gml:TimePeriod (format = %Y-%m-%dThh:mm:ss) -->
  <!-- ===================================================================== -->

  <xsl:template mode="mode-iso19139"
                priority="3000"
                match="*[gml:beginPosition|gml:endPosition|gml:timePosition]">

    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="timenode"           select="gml:beginPosition|gml:endPosition|gml:timePosition"/>

    <xsl:variable name="xpath"              select="gn-fn-metadata:getXPath($timenode)"/>
    <xsl:variable name="isoType"            select="''"/>
    <xsl:variable name="labelConfig"        select="gn-fn-metadata:getLabel($schema, name($timenode), $labels, name($timenode), $isoType, $xpath)"/>
    <xsl:variable name="dateTypeElementRef" select="gn:element/@ref"/>

    <xsl:variable name="isRequired"         select="gn:element/@min = 1 and gn:element/@max = 1"/>

    <div class="form-group gn-field gn-title {if ($isRequired) then 'gn-required' else ''}"
         id="gn-el-{$dateTypeElementRef}"
         data-gn-field-highlight="">

      <label class="col-sm-2 control-label">
        <xsl:value-of select="$labelConfig/label"/>
      </label>

      <div class="col-sm-9 gn-value">
        <div data-gn-date-picker="{$timenode}"
             data-label=""
             data-tag-name="{name($timenode)}"
             data-element-name="{name($timenode)}"
             data-element-ref="{concat('_X', gn:element/@ref)}">
        </div>
      </div>

      <div class="col-sm-1 gn-control">
        <xsl:call-template name="render-form-field-control-remove">
          <xsl:with-param name="editInfo" select="../gn:element"/>
          <xsl:with-param name="parentEditInfo" select="../../gn:element"/>
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:EX_GeographicBoundingBox" priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="subTreeSnippet">
        <div gn-draw-bbox="" data-hleft="{gmd:westBoundLongitude/gco:Decimal}"
          data-hright="{gmd:eastBoundLongitude/gco:Decimal}" data-hbottom="{gmd:southBoundLatitude/gco:Decimal}"
          data-htop="{gmd:northBoundLatitude/gco:Decimal}" data-hleft-ref="_{gmd:westBoundLongitude/gco:Decimal/gn:element/@ref}"
          data-hright-ref="_{gmd:eastBoundLongitude/gco:Decimal/gn:element/@ref}"
          data-hbottom-ref="_{gmd:southBoundLatitude/gco:Decimal/gn:element/@ref}"
          data-htop-ref="_{gmd:northBoundLatitude/gco:Decimal/gn:element/@ref}"
          data-lang="lang"></div>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- gmd:geographicElement -->
  <!-- ===================================================================== -->

    <xsl:template mode="mode-iso19139"  priority="3000"
                match="gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:RS_Identifier[$tab='zamg_tab_simple1' or $tab='zamg_tab_simple2']">

        <xsl:variable name="codenode"  select="gmd:code"/>
        <xsl:variable name="coderef" select="$codenode/gco:CharacterString/gn:element/@ref"/>
        <xsl:variable name="currentcode" select="normalize-space(string($codenode))"/>

        <xsl:variable name="descnode"  select="$codenode/../../../../../gmd:description"/>
        <xsl:variable name="descref" select="$descnode/gco:CharacterString/gn:element/@ref"/>
        <xsl:variable name="currentdesc" select="normalize-space(string($descnode))"/>

        <xsl:message>FOUND GEO IDENTIFIER <xsl:value-of select="$currentcode" /> on ref <xsl:value-of select="$coderef" /> at <xsl:value-of select="$currentdesc" /></xsl:message>

        <xsl:variable name="labelThesaurus" select="/root/gui/schemas/iso19139/strings/zamgRegions.label"/>

        <input class="md" type="hidden" id="zamg_region_code" name="_{$coderef}" value="{$currentcode}" readonly="true"/>
        <input class="md" type="hidden" id="zamg_region_desc" name="_{$descref}" value="{$currentdesc}" readonly="true"/>

        <div class="row">
          <div class="col-xs-2" />
          <label for="zamg_areas" class="control-label col-xs-2"><xsl:value-of select="/root/gui/schemas/iso19139/strings/zamgRegions.label" /></label>
          <select id="zamg_areas" class="col-xs-4"></select>
          <script>
            $.ajax({
              beforeSend: function(xhr){xhr.setRequestHeader("Accept", "application/json");},
              url: "../api/registries/vocabularies/search?" +
                   $.param(
                        {"type": "CONTAINS",
                         "thesaurus":  "external.place.regions",
                         "rows": "200",
                         "lang": "<xsl:value-of select="$lang" />"}
                    )
            }).done(function( json ) {

                var optionTemplate = "WEST|EAST|SOUTH|NORTH|CODE|DESC";
                var sel = false;
                var areas = $('#zamg_areas');

                for(id in json){
                    var el = json[id];
                    var areacode = el.uri.split("#")[1];
                    var desc = el.value;

                    var option = optionTemplate.replace("WEST",el.coordWest);
                    option = option.replace("EAST",el.coordEast);
                    option = option.replace("SOUTH",el.coordSouth);
                    option = option.replace("NORTH",el.coordNorth);
                    option = option.replace("CODE",areacode);
                    option = option.replace("DESC", desc);

                    areas.append(new Option(el.value, option));

                    //$('#zamg_areas').append($("&lt;option/&gt;", {
                    //    value: option,
                    //    text: el.value['#text']
                    //}));

                    if(areacode == $('#zamg_region_code')[0].value) {
                        areas.val(option);
                        sel = true;
                    }
                }

                areas.append(new Option('<xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_custom" />', 'custom'));

                //$('#zamg_areas').append($("&lt;option/&gt;", {
                //    value: "custom",
                //    text: "<xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_custom" />"
                //}));

                if(! sel) {
                    areas.val("custom");
                }
            });

            // =============================================================================================================

            var setCustom = function (){
                $('#zamg_areas').val("custom");

                $("#zamg_region_code").val('custom');
                $("#zamg_region_desc").val('<xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_custom" />');
            }

            $("#zamg_westBoundLongitude").find("input").change(setCustom);
            $("#zamg_eastBoundLongitude").find("input").change(setCustom);
            $("#zamg_southBoundLatitude").find("input").change(setCustom);
            $("#zamg_northBoundLatitude").find("input").change(setCustom);

            $( "#zamg_areas" ).change(function() {
                var choice = $( "#zamg_areas" ).val();
                var id = "";
                var w = "";
                var e = "";
                var s = "";
                var n = "";
                var code = "custom";
                var desc = "<xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_custom" />";

                if (choice != undefined) {
                    coords = choice.split("|");

                    if (coords.length == 6) {
                        w = coords[0];
                        e = coords[1];
                        s = coords[2];
                        n = coords[3];
                        code = coords[4];
                        desc = coords[5];

                        $("#zamg_westBoundLongitude").find("input").val(w);
                        $("#zamg_eastBoundLongitude").find("input").val(e);
                        $("#zamg_southBoundLatitude").find("input").val(s);
                        $("#zamg_northBoundLatitude").find("input").val(n);
                    }
                }

                $("#zamg_region_code").val(code);
                $("#zamg_region_desc").val(desc);
            });
        </script>
      </div>
  </xsl:template>


</xsl:stylesheet>
