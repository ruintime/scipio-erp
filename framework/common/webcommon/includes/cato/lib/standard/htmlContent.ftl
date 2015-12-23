<#--
* 
* Content element HTML template include, standard Cato markup.
*
* Included by htmlTemplate.ftl.
*
* NOTE: May have implicit dependencies on other parts of Cato API.
*
-->

<#-- 
*************
* Heading
************
  * Usage Example *  
    <@heading>My Title</@heading>         
                                 
  * Parameters *
    elemType       = [heading|h|p|span|div|raw], default heading (note: do not specify h1-h6 here - use level)
                     boolean true means use default, false same as raw (none)
    level          = specific level (1-6). If not specified, current heading level returned by
                     getCurrentHeadingLevel() function is used. 
                     note: does not consume a level.
    relLevel       = for level, uses level of current heading returned by getCurrentHeadingLevel()
                     plus this number of levels. default: 0 (current level)
    class          = heading elem classes (simple)
                     supports prefixes:
                       "+": causes the classes to append only, never replace defaults (same logic as empty string "")
                       "=": causes the class to replace non-essential defaults (same as specifying a class name directly)
    levelClassPrefix = default "heading-level-", prefix for class that will be appended level number
    id             = heading id
    consumeLevel   = boolean, default currently always false (DEV NOTE: could be made to depend on calculated level).
                     if true, the global heading level is set to (calculated level for this heading) + 1.
                     note this is better handled through use of the @section macro. mostly useful for h1.
    containerElemType = [div|] default empty. if present, adds container around title or this elem type
    containerClass    = container elem classes (simple)       
    containerId       = container id  
    attribs              = hash of other legacy h1-h6 attributes (mainly for those with dash in name)
    [inlineAttribs...]   = other legacy h1-h6 attributes, inlined
                           NOTE: camelCase names are automatically converted to dash-separated-lowercase-names.
-->
<#assign heading_defaultArgs = {
  "elemType":true, "level":"", "relLevel":"", "class":"", "id":"", "levelClassPrefix":true, "consumeLevel":"", 
  "containerElemType":false, "containerClass":"", "containerId":"", "attribs":{}, "passArgs":{}
}>
<#macro heading args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.heading_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>
  
  <#if !level?has_content>
    <#local level = getCurrentHeadingLevel()>
  </#if>
  <#if relLevel?has_content>
    <#local level = level + relLevel>
  </#if>
  <#if levelClassPrefix?is_boolean>
    <#local levelClassPrefix = levelClassPrefix?string(styles.heading_level_prefix!"", "")>
  </#if>
  <#if levelClassPrefix?has_content>
    <#local headingLevelClass = levelClassPrefix + level?string>
  <#else>
    <#local headingLevelClass = "">
  </#if>
  <#local class = addClassArgDefault(class, headingLevelClass)>
  <#local containerClass = addClassArgDefault(containerClass, headingLevelClass)>
  <#if (consumeLevel?is_boolean && consumeLevel == true)>
    <#local dummy = setCurrentHeadingLevel(level + 1)>
  </#if>
  <#if (level < 1)>
    <#local level = 1>
  </#if>
  <#if elemType?is_boolean>
    <#if elemType>
      <#local hElem = "h">
    <#else>
      <#local hElem = "">
    </#if>
  <#elseif elemType == "heading" || elemType == "h">
    <#local hElem = "h">
  <#elseif elemType == "container">
    <#local hElem = "div">    
  <#elseif elemType == "raw" || !elemType?has_content>
    <#local hElem = "">
  <#else>
    <#local hElem = elemType>
  </#if>
  <#if containerElemType?is_boolean>
    <#local cElem = "">
  <#elseif containerElemType == "container">
    <#local cElem = "div">
  <#elseif containerElemType == "raw" || !containerElemType?has_content>
    <#local cElem = "">
  <#else>
    <#local cElem = containerElemType> 
  </#if>
  <@heading_markup level=level elem=hElem class=class id=id attribs=attribs
    containerElem=cElem containerClass=containerClass containerId=containerId origArgs=origArgs passArgs=passArgs><#nested></@heading_markup>
</#macro>

<#-- Main markup for @heading (minimal logic; a little needed) - theme override
     This may be overridden by themes to change markup without changing logic.
     Here, elem will contain either the value "h" or a valid html element.
     NOTE: wherever this is overridden, should include "catchArgs..." for compatibility (new args won't break old overrides; remove to identify) -->
<#macro heading_markup level=1 elem="" class="" id="" attribs={} excludeAttribs=[] containerElem="" containerClass="" containerId="" origArgs={} passArgs={} catchArgs...>
  <#local elemLevel = level>
  <#if (elemLevel > 6)>
    <#local elemLevel = 6>
  </#if>
  <#if elem == "h">
    <#local elem = "h" + elemLevel?string>
  </#if>
  <#if containerElem?has_content>
    <${containerElem}<@compiledClassAttribStr class=containerClass /><#if containerId?has_content> id="${containerId}"</#if>>
  </#if>
  <#if elem?has_content><${elem}<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#rt>
    <#lt><#if attribs?has_content><@commonElemAttribStr attribs=attribs exclude=excludeAttribs/></#if>></#if><#nested><#if elem?has_content></${elem}></#if>
  <#if containerElem?has_content>
    </${containerElem}>
  </#if>
</#macro>

<#-- 
*************
* Code Block
************
Creates a very basic wrapper for code blocks

  * Usage Example *  
    <@code type="java">
       // Some java code
    </@code>
                    
  * Parameters *
    type            = (html|java|css|javascript|log) (default:html) 
-->
<#assign code_defaultArgs = {
  "type":"html", "passArgs":{}
}>
<#macro code args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.code_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@code_markup type=type origArgs=origArgs passArgs=passArgs><#nested></@code_markup>
</#macro>

<#-- @code main markup - theme override -->
<#macro code_markup type="" origArgs={} passArgs={} catchArgs...>
  <pre><code data-language="${type!}"><#rt>
    <#nested><#t>
  </code></pre><#lt>
</#macro>

<#-- 
*************
* mapOfbizFormTypeToTableType
************ 
Maps an Ofbiz form widget type to a @table macro type.
-->
<#function mapOfbizFormTypeToTableType formType>
  <#local res = (styles.form_type_tabletypes_ofbiz[formType])!(styles.form_type_tabletypes_ofbiz["default"])!"">
  <#if res?is_boolean>
    <#return res?string(formType, "")>
  </#if>
  <#return res>
</#function>

<#-- 
*************
* Responsive Table Script
************
Creates a responsive tables script (script only - no markup).
    
  * Parameters *
    enabled             = true/false, default true (helper macro arg)
    tableId             = id of table
    tableType           = table type
    tableStyleName      = optimization: table style name (usually based on table type)
                          can be omitted and will determine automatically from table type
    responsive          = if true, will rely on the jquery plugin datatables.js (www.datatables.net) to generate responsive table. 
                          Can be combined with fixed column type.
                          if explicitly set to false, will disable responsive regardless of defaults.
                          default is dependent on table type (global styles).
    responsiveOptions   = a map of options passed directly to responsive tables
    responsiveDefaults  = if true, responsive defaults are looked up, and any option in responsiveOptions overrides the defaults
                          per-option; if false, no defaults are used and only 
                          responsiveOptions, fixedColumnsLeft and fixedColumnsRight are used. 
                          default is true.
    scrollable          = if true, guarantees table will be scrollable horizontally.
                          implementation of scrollable depends on macro and global styles (by default, uses responsive).
                          if explicitly set to false, prevents scrolling.
                          default is dependent on table type (global styles).
                          (convenience and abstractive option; avoids having to specify responsive options; currently alias for responsiveOptions.scrollX)
    fixedColumnsLeft    = int value; number of columns that are fixed on the left-hand side (convenience and abstractive option; currently alias for responsiveOptions.fixedColumns.leftColumns)
    fixedColumnsRight   = int value; number of columns that are fixed on the right hand side (convenience and abstractive option; currently alias for responsiveOptions.fixedColumns.rightColumns) 
-->
<#assign tableResponsiveScript_defaultArgs = {
  "enabled" : true, "tableId" : "", "tableType" : "", "tableStyleName" : "", "responsive" : "", "scrollable" : "",
  "responsiveOptions" : {}, "responsiveDefaults" : true, "fixedColumnsLeft" : 0, "fixedColumnsRight" : 0,
  "htmlwrap" : true, "passArgs":{}
}>
<#macro tableResponsiveScript args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.tableResponsiveScript_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#if enabled>
    <#if !(responsive?is_boolean && responsive == false) && tableId?has_content>
      <#if !tableStyleName?has_content>
        <#local tableStyleName = tableType?replace("-","_")>
        <#if (!tableStyleName?has_content) || (!(styles["table_" + tableStyleName]!false)?is_string)>
          <#local tableStyleName = "default">
        </#if>
      </#if>
  
      <#-- defaults -->
      <#if !responsiveDefaults>
        <#local respOpts = {}>
      <#elseif responsive?is_boolean && responsive == true>
        <#local respOpts = styles["table_" + tableStyleName + "_responsive_options"]!styles["table_default_responsive_options"]!{}>
      <#elseif scrollable?is_boolean && scrollable == true>
        <#local respOpts = styles["table_" + tableStyleName + "_scrollable_options"]!styles["table_default_scrollable_options"]!{}>    
      <#else>
        <#local respOpts = {}>
      </#if>
  
      <#-- aliases/abstractions -->
      <#if (fixedColumnsLeft > 0) || (fixedColumnsRight > 0)>
        <#local respOpts = respOpts + { "fixedColumns" : {
            "leftColumns": fixedColumnsLeft!0,
            "rightColumns": fixedColumnsRight!0
          }
        }>
      </#if>
      <#if scrollable?is_boolean>
        <#local respOpts = respOpts + {"scrollX": scrollable}>
      </#if>
  
      <#-- manual overrides -->
      <#if responsiveOptions?has_content>
        <#local respOpts = respOpts + responsiveOptions>
      </#if>
      
      <@script htmlwrap=htmlwrap>
        $(document).ready(function() {
            $('#${tableId}').DataTable(<@objectAsScript lang="js" object=respOpts />);
        } );
      </@script>
    </#if>
  </#if>
</#macro>

<#-- 
*************
* Table
************
Helps define an HTML table. Required wrapper for all @table sub-element macros.

TODO?: @table macros were made before push/popRequestStack was fully realized, so may be
    overcomplicated at the moment.

  * Usage Example *  
    <@table type="data-list" id="my-table">
      <@thead>
        <@tr>
          <@th width="15%">col 1</@th>
          <@th width="85%">col 2</@th>
        </@tr>
      </@thead>
      <@tbody>
        <@tr class="my-row-class" valign="middle">
          <@td>data value 1</@td>
          <@td>data value 2</@td>
        </@tr>
      </@tbody>
    </@table>
                    
  * Parameters *
    * General *
    type            = [generic|(theme-specific)], default generic
                      * STANDARD TYPES *
                      These types must always be recognized by all styles themes:
                      generic: generic html table (free-form, complex); no features enabled by default.
                          similar to defining an html <table> manually, but more powerful.
                      * DEFAULT STYLES TYPES *
                      WARN: these are WIP types, may not be enough (important part is to label things for easy search)
                      The following are currently recognized by the default cato styles (NOTE: targeted for backend):
                      data-list: record-containing table, one data record per row (but row cells may be complex and may have tfoot)
                          similar to a form widget "list" or "multi" table; intended to resemble these, to unify them.
                      data-list-multiform: virtually same as data-list, but expected to contain a multi-submit form, which
                          could change styling requirements.
                          this makes no real semantic difference from data-list to @table macro, but this type exists as analog
                          to form widget "multi" form type, so possible to style differently.
                      data-complex: record-containing table, but with complex structure (more than one row per record, separators, etc.)
                          there is no form widget equivalent of these and usually need some custom alt-row work.
                      summary: usually table with one or a few set rows of summary totals
                          e.g. order grand totals. 
                          TODO? review need for this type (should be converted?)
                      fields: label-value pairs for display, side-by-side, usually no header, roughly
                          this is especially for legacy Ofbiz code. it is somewhat still valid for display-only fields.
                          legacy Ofbiz code tables may be assigned this for input forms formatted with tables, but they
                          ultimately belong as @field and @row/@cell.
                          TODO: many of these in current templates involving forms and inputs should be converted to @row/@cell (WIP)
    class           = manual classes to add, as string, default depends on table type
                      if specified as string, replaces defaults (class=false prevents class), unless prefixed with "+"
                      supports prefixes:
                        "+": causes the classes to append only, never replace defaults (same logic as empty string "")
                        "=": causes the class to replace non-essential defaults (same as specifying a class name directly)
                      defaults are looked up in the styles hash using:
                      styles["table_" + type?replace("-","_")]
                      where type is the table type above. if the given hash entry does not exist, the default is instead determined by:
                      styles["table_default"]
    id              = table id
    hasHeader       = boolean, this is a hint to indicate that table is expected to have a header, normally a <@thead>
                      element. @table will try to figure this out on its own, but in some cases it may not be possible
                      or not possible to know in advance, in which case caller must specify this flag.
                      currently this affects the following:
                        responsive tables
    autoAltRows     = defaults specified in styles hash, but otherwise false
    firstRowAlt     = default false
    inheritAltRows  = only for nested tables: if true, all rows in nested tables will inherit alt from parent table row
    useFootAltRoots = whether use alt row logic in foot or not
    cellspacing     = cellspacing, defaults specified in styles hash, set to "" to prevent setting.
    open/close      = advanced structure control, for esoteric cases
    attribs         = hash of other legacy <table attributes (mainly for those with dash in name)
    [inlineAttribs...]    = other legacy <table attributes and values, inlined
                            NOTE: camelCase names are automatically converted to dash-separated-lowercase-names.
    
    * Responsive Tables *
    responsive/responsiveOptions/
    responsiveDefaults/scrollable/
    fixedColumnsLeft/fixedColumnsRight  = see @tableResponsiveScript macro for descriptions
                                          NOTE: @table (default @table_markup) will automatically disable
                                              responsive on tables that have no @thead element and hasHeader=true is not specified.
                                              responsive tables break when no header.
                                              in other words, responsive tables required a <@thead> element.
-->
<#assign table_defaultArgs = {
  "type":"", "class":"", "id":"", "hasHeader":"", "cellspacing":true, "responsive":"", "scrollable":"", "responsiveOptions":{}, "responsiveDefaults":"", 
  "fixedColumnsLeft":0, "fixedColumnsRight":0, "autoAltRows":"", "firstRowAlt":"", "inheritAltRows":false, "useFootAltRows":false, 
  "open":true, "close":true, "attribs":{}, "passArgs":{}
  <#-- DEV NOTE: for all table macros, when adding parameters, make sure also pushed on catoTableStack stack below -->
}>
<#macro table args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.table_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <#if open>
    <#local tableIdNum = getRequestVar("catoTableIdNum")!0>
    <#local tableIdNum = tableIdNum + 1 />
    <#local dummy = setRequestVar("catoTableIdNum", tableIdNum)>
    <#if !id?has_content>
      <#local id="table_"+tableIdNum/>
    </#if>
    <#if !type?has_content>
      <#local type = "generic">
    </#if>
    <#-- save previous globals, for nesting -->
    <#local prevTableInfo = getRequestVar("catoCurrentTableInfo")!{}>
    <#local prevHasHeaderFlag = getRequestVar("catoCurrentTableHasHeader")!"">
    <#local prevSectionInfo = getRequestVar("catoCurrentTableSectionInfo")!{}>
    <#local prevRowAltFlag = getRequestVar("catoCurrentTableRowAltFlag")!""> <#-- used to keep track of state (always boolean) -->
    <#local prevCurrentRowAlt = getRequestVar("catoCurrentTableCurrentRowAlt")!""> <#-- the actual alt value of current row (may be empty) -->
    <#local prevLastRowAlt = getRequestVar("catoCurrentTableLastRowAlt")!""> <#-- the actual alt value of "last" row (may be empty) -->
    <#local styleName = type?replace("-","_")>
    <#if (!styleName?has_content) || (!(styles["table_" + styleName]!false)?is_string)>
      <#local styleName = "default">
    </#if>
    <#if !autoAltRows?is_boolean>
      <#if inheritAltRows>
        <#local autoAltRows = true>
      <#else>
        <#local autoAltRows = styles["table_" + styleName + "_autoaltrows"]!styles["table_default_autoaltrows"]!false>
      </#if>
    </#if>
    <#local defaultClass = styles["table_" + styleName]!styles["table_default"]!"">
    <#local class = addClassArgDefault(class, defaultClass)>
    <#if cellspacing?is_boolean>
      <#if cellspacing>
        <#local cellspacing = styles["table_" + styleName + "_cellspacing"]!styles["table_default_cellspacing"]!"">
      <#else>
        <#local cellspacing = "">
      </#if>
    </#if>
    <#if !responsive?is_boolean>
      <#local responsive = styles["table_" + styleName + "_responsive"]!styles["table_default_responsive"]!"">
    </#if>
    <#if !scrollable?is_boolean>
      <#local scrollable = styles["table_" + styleName + "_scrollable"]!styles["table_default_scrollable"]!"">
    </#if>
    <#if !responsiveDefaults?is_boolean>
      <#local responsiveDefaults = true>
    </#if>
    <#-- NOTE: there's currently some duplication between catoCurrentTableInfo and catoTableStack below; do not confuse
            (this was written before the stack functions were fully written) -->
    <#local catoCurrentTableInfo = {"type": type, "styleName": styleName, "autoAltRows": autoAltRows,
      "inheritAltRows": inheritAltRows, "parentRowAlt": prevCurrentRowAlt, "useFootAltRows": useFootAltRows}>
    <#local dummy = setRequestVar("catoCurrentTableInfo", catoCurrentTableInfo)!>
    <#local catoCurrentTableSectionInfo = {"type": "body", "cellElem": "td"}>
    <#local dummy = setRequestVar("catoCurrentTableSectionInfo", catoCurrentTableSectionInfo)!>
    <#-- also set in @thead -->
    <#local dummy = setRequestVar("catoCurrentTableHasHeader", hasHeader)!>
    <#-- note: catoCurrentTableRowAltFlag should always be boolean
         note: catoCurrentTableCurrentRowAlt probably doesn't need to be set here, but playing it safe -->
    <#if firstRowAlt?is_boolean>
      <#local dummy = setRequestVar("catoCurrentTableRowAltFlag", firstRowAlt)!>
      <#local dummy = setRequestVar("catoCurrentTableCurrentRowAlt", firstRowAlt)!>
    <#elseif inheritAltRows>
      <#if prevCurrentRowAlt?is_boolean>
        <#local dummy = setRequestVar("catoCurrentTableRowAltFlag", prevCurrentRowAlt)!>
      <#else>
        <#local dummy = setRequestVar("catoCurrentTableRowAltFlag", false)!>
      </#if>
      <#local dummy = setRequestVar("catoCurrentTableCurrentRowAlt", prevCurrentRowAlt)!>
    <#else>
      <#local dummy = setRequestVar("catoCurrentTableRowAltFlag", false)!>
      <#local dummy = setRequestVar("catoCurrentTableCurrentRowAlt", false)!>
    </#if>
    <#-- note: this var may be empty string (none) -->
    <#local dummy = setRequestVar("catoCurrentTableLastRowAlt", prevCurrentRowAlt)!>
    <#local style = "">
    <#local useResponsive = ((responsive?is_boolean && responsive == true) || responsiveOptions?has_content || (scrollable?is_boolean && scrollable == true))
      && !(responsive?is_boolean && responsive == false)>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#-- TODO? this stack push is duplicating catoCurrentTableInfo above;
           could instead always push a stack and have child elems use readRequestStack instead of
           catoCurrentTableInfo; but requires change all the macros, and as-is this optimizes
           for FTLs somewhat, though also more error-prone... -->
      <#local prevHasHeaderFlag = getRequestVar("catoCurrentTableHasHeader")!"">
      <#local dummy = pushRequestStack("catoTableStack", {
        <#-- save prev values -->
        "prevTableInfo":prevTableInfo, 
        "prevSectionInfo":prevSectionInfo, 
        "prevHasHeaderFlag":prevHasHeaderFlag, 
        "prevRowAltFlag":prevRowAltFlag, 
        "prevCurrentRowAlt":prevCurrentRowAlt, 
        "prevLastRowAlt":prevLastRowAlt, 
        
        <#-- save parameters (including local changes) -->
        "type":type, 
        "class":class, 
        "id":id, 
        "hasHeader":hasHeader,
        "cellspacing":cellspacing,
        "responsive":responsive, 
        "scrollable":scrollable, 
        "responsiveOptions":responsiveOptions,
        "responsiveDefaults":responsiveDefaults, 
        "fixedColumnsLeft":fixedColumnsLeft, 
        "fixedColumnsRight":fixedColumnsRight,
        "autoAltRows":autoAltRows, 
        "firstRowAlt":firstRowAlt, 
        "inheritAltRows":inheritAltRows, 
        "useFootAltRows":useFootAltRows, 
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs,
        
        <#-- save local variables -->
        "tableIdNum":tableIdNum, 
        "styleName":styleName, 
        "useResponsive":useResponsive
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("catoTableStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#-- needed so no undefined vars -->
    <#local styleName = "">
    <#local cellspacing = "">
    <#local useResponsive = false>
    <#local tableIdNum = 0>
  </#if>     
  <#-- having this as map simplifies the args the markup has to pass along, much easier -->
  <#local responsiveArgs = {
    "tableId" : id,
    "tableType" : type,
    "tableStyleName" : styleName,
    "responsive" : responsive,
    "scrollable" : scrollable,
    "responsiveOptions" : responsiveOptions,
    "responsiveDefaults" : responsiveDefaults,
    "fixedColumnsLeft" : fixedColumnsLeft,
    "fixedColumnsRight" : fixedColumnsRight
  }>
  <@table_markup open=open close=close type=type styleName=styleName class=class id=id cellspacing=cellspacing 
      useResponsive=useResponsive responsiveArgs=responsiveArgs autoAltRows=autoAltRows firstRowAlt=firstRowAlt 
      inheritAltRows=inheritAltRows useFootAltRows=useFootAltRows tableIdNum=tableIdNum attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@table_markup>
  <#if close>
    <#local dummy = setRequestVar("catoCurrentTableInfo", prevTableInfo)!>
    <#local dummy = setRequestVar("catoCurrentTableSectionInfo", prevSectionInfo)!>
    <#local dummy = setRequestVar("catoCurrentTableHasHeader", prevHasHeaderFlag)!>
    <#local dummy = setRequestVar("catoCurrentTableRowAltFlag", prevRowAltFlag)!>
    <#local dummy = setRequestVar("catoCurrentTableCurrentRowAlt", prevCurrentRowAlt)!>
    <#local dummy = setRequestVar("catoCurrentTableLastRowAlt", prevLastRowAlt)!>
  </#if>
</#macro>

<#-- @table main markup - theme override -->
<#macro table_markup open=true close=true type="" styleName="" class="" id="" cellspacing="" useResponsive=false responsiveArgs={} 
  autoAltRows="" firstRowAlt="" inheritAltRows=false useFootAltRows=false tableIdNum=0 attribs={} excludeAttribs=[] origArgs={} passArgs={} catchArgs...>
  <#if open>
    <table<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#rt>
      <#lt><#if cellspacing?has_content> cellspacing="${cellspacing}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs exclude=excludeAttribs/></#if>>  
  </#if>
      <#nested>
  <#if close>
    </table>
    <#if useResponsive>
      <#-- Responsive tables bug workaround: responsive tables break if table has no header, 
          so only enable if a header was present during rendering -->
      <#local tableHasHeader = getRequestVar("catoCurrentTableHasHeader")!"">
      <#if tableHasHeader?is_boolean && tableHasHeader == true>
        <@tableResponsiveScript args=responsiveArgs htmlwrap=true passArgs=passArgs />
      </#if>
    </#if>  
  </#if>
</#macro>

<#assign thead_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro thead args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.thead_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>
  
  <#if open>
    <#-- inform the parent table (and anything else) that this table has a header -->
    <#local dummy = setRequestVar("catoCurrentTableHasHeader", true)!>
    <#local prevTableSectionInfo = getRequestVar("catoCurrentTableSectionInfo")!{}>
    <#local catoCurrentTableSectionInfo = {"type": "head", "cellElem": "th"}>
    <#local dummy = setRequestVar("catoCurrentTableSectionInfo", catoCurrentTableSectionInfo)!>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#local dummy = pushRequestStack("catoTableHeadStack", {
        "prevTableSectionInfo":prevTableSectionInfo, 
        
        "class":class, 
        "id":id, 
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("catoTableHeadStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#-- (no missing values yet) -->
  </#if>
  <@thead_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@thead_markup>
  <#if close>
    <#local dummy = setRequestVar("catoCurrentTableSectionInfo", prevTableSectionInfo)!>
  </#if>
</#macro>

<#-- @thead main markup - theme override -->
<#macro thead_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open>
    <thead<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>>
  </#if>
      <#nested>
  <#if close>
    </thead>
  </#if>
</#macro>

<#assign tbody_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro tbody args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.tbody_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <#if open>
    <#local prevTableSectionInfo = getRequestVar("catoCurrentTableSectionInfo")!{}>
    <#local catoCurrentTableSectionInfo = {"type": "body", "cellElem": "td"}>
    <#local dummy = setRequestVar("catoCurrentTableSectionInfo", catoCurrentTableSectionInfo)!>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#local dummy = pushRequestStack("catoTableBodyStack", {
        "prevTableSectionInfo":prevTableSectionInfo,
        
        "class":class, 
        "id":id, 
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("catoTableBodyStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#-- (no missing values yet) -->
  </#if>
  <@tbody_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@tbody_markup>
  <#if close>
    <#local dummy = setRequestVar("catoCurrentTableSectionInfo", prevTableSectionInfo)!>
  </#if>
</#macro>

<#-- @tbody main markup - theme override -->
<#macro tbody_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open>
    <tbody<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>>
  </#if>
      <#nested>
  <#if close>
    </tbody>
  </#if>
</#macro>


<#assign tfoot_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro tfoot args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.tfoot_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <#if open>
    <#local prevTableSectionInfo = getRequestVar("catoCurrentTableSectionInfo")!{}>
    <#local catoCurrentTableSectionInfo = {"type": "foot", "cellElem": "td"}>
    <#local dummy = setRequestVar("catoCurrentTableSectionInfo", catoCurrentTableSectionInfo)!>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#local dummy = pushRequestStack("catoTableFootStack", {
        "prevTableSectionInfo":prevTableSectionInfo,
        
        "class":class, 
        "id":id, 
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("catoTableFootStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#-- (no missing values yet) -->
  </#if>
  <@tfoot_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@tfoot_markup>
  <#if close>
    <#local dummy = setRequestVar("catoCurrentTableSectionInfo", prevTableSectionInfo)!>
  </#if>
</#macro>

<#-- @tfoot main markup - theme override -->
<#macro tfoot_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open>
    <tfoot<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>>
  </#if>
      <#nested>
  <#if close>
    </tfoot>
  </#if>
</#macro>

<#-- 
*************
* Table Row
************
Helps define table rows. takes care of alt row styles. must have a parent @table wrapper. 
                     
  * Parameters *
    type            = [generic|content|meta|util], default depends on table type and styles hash; 
                          in complete absence of styles hash, default is "generic";
                          in default cato styles, default is "generic" for "generic" tables, and "content" for all other table types.
                      generic: free-form row with no assumptions on content.
                      content: normal data or content row. exact meaning depends on table type.
                               note that for "data-complex" this definition is currently relaxed.
                      meta: indicates this is a special info/status row (e.g. "No Records Found" message), not an actual content row.
                            meta rows are treated differently by default as are thead and tfoot rows.
                            exact meaning depends on table type.
                      util: indicates this is a special utility-only row meant to hold no real data, 
                            such as: spacer rows (<@tr type="util"><@td colspan=3><hr /></@td></@tr>)
                            TODO: this isn't handled yet but SHOULD be used in templates anyhow.
    class           = css classes
                      supports prefixes:
                        "+": causes the classes to append only, never replace defaults (same logic as empty string "")
                        "=": causes the class to replace non-essential defaults (same as specifying a class name directly)
    id              = row id
    useAlt          = boolean, if specified, can manually enable/disable whether alternate row code runs per-row
    alt             = boolean, if specified, override the automatic auto-alt styling to specific value true or false (manual mode)
                      note: at current time, alt on non-body rows (except foot rows if enabled in @table) does not affect
                            next row's alt (unless groupLast used explicit on next) logic
    groupLast       = boolean, if specified, considers row logically grouped with last row;
                      sets alt to exact same as last row
    groupParent     = boolean, nested tables only, if specified, considers row logically grouped with parent row;
                      sets alt to exact same as parent row
    selected        = boolean, if specified and true marked as selected
    open/close      = advanced structure control, for esoteric cases
    attribs               = hash of other legacy <tr attributes (mainly for those with dash in name)
    [inlineAttribs...]    = other legacy <tr attributes and values, inlined
-->
<#assign tr_defaultArgs = {
  "type":"", "class":"", "id":"", "useAlt":"", "alt":"", "groupLast":"", "groupParent":"", "selected":"", 
  "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro tr args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.tr_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <#local catoCurrentTableInfo = getRequestVar("catoCurrentTableInfo")!{}>
  <#local catoCurrentTableSectionInfo = getRequestVar("catoCurrentTableSectionInfo")!{}>
  <#local catoCurrentTableRowAltFlag = getRequestVar("catoCurrentTableRowAltFlag")!false>
  <#local catoCurrentTableLastRowAlt = getRequestVar("catoCurrentTableLastRowAlt")!"">
  <#if open>
    <#local tableType = (catoCurrentTableInfo.type)!"generic">
    <#local tableStyleName = (catoCurrentTableInfo.styleName)!tableType>
    <#local sectionType = (catoCurrentTableSectionInfo.type)!"body">
    <#if !type?has_content>
      <#local type = styles["table_" + tableStyleName + "_rowtype"]!styles["table_default_rowtype"]!"generic">
    </#if>
    <#local metaRow = (type == "meta")>
    <#local isRegAltRow = !metaRow && ((sectionType == "body") || (sectionType == "foot" && ((catoCurrentTableInfo.useFootAltRows)!)==true))>
    <#if !(useAlt?is_boolean && useAlt == false)>
      <#if !alt?is_boolean>
        <#if groupLast?is_boolean && groupLast == true>
          <#local alt = catoCurrentTableLastRowAlt!""> <#-- may be empty string (none) -->
        <#elseif groupParent?is_boolean && groupParent == true>
          <#local alt = (catoCurrentTableInfo.parentRowAlt)!"">
        <#elseif (isRegAltRow && ((catoCurrentTableInfo.autoAltRows)!false)==true)>
          <#if ((catoCurrentTableInfo.inheritAltRows)!false)==true>
            <#local alt = (catoCurrentTableInfo.parentRowAlt)!"">
          <#else>
            <#local alt = catoCurrentTableRowAltFlag!false> <#-- always boolean -->
          </#if>
        <#elseif useAlt?is_boolean && useAlt == true>
          <#-- forced -->
          <#local alt = catoCurrentTableRowAltFlag!false>
        </#if>
      </#if>
    </#if>
    <#-- save the "effective" or "real" current row alt -->
    <#local catoCurrentTableCurrentRowAlt = alt>
    <#local dummy = setRequestVar("catoCurrentTableCurrentRowAlt", catoCurrentTableCurrentRowAlt)!>
    <#if alt?is_boolean>
      <#local class = addClassArg(class, alt?string(styles.row_alt!, styles.row_reg!))>
    </#if>
    <#if selected?is_boolean && selected == true>
      <#local class = addClassArg(class, styles.row_selected!)>
    </#if>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#local dummy = pushRequestStack("catoTableRowStack", {
        "type":type, 
        "class":class, 
        "id":id, 
        "useAlt":useAlt, 
        "alt":alt, 
        "groupLast":groupLast, 
        "groupParent":groupParent, 
        "selected":selected,
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs,
        
        "isRegAltRow":isRegAltRow
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("catoTableRowStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#local isRegAltRow = false>
  </#if>    
  <@tr_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@tr_markup>
  <#if close>
    <#if !(useAlt?is_boolean && useAlt == false)>
      <#-- note: isRegAltRow check here could be removed but maybe better to keep? only auto-toggle for regular rows... -->
      <#if alt?is_boolean && isRegAltRow> <#-- not needed:  && ((catoCurrentTableInfo.inheritAltRows)!)==false -->
        <#local catoCurrentTableRowAltFlag = !alt>
        <#local dummy = setRequestVar("catoCurrentTableRowAltFlag", catoCurrentTableRowAltFlag)!>
      </#if>
    </#if>
    <#-- note: may be empty string, that's ok, will record if last was disabled so groupLast always makes sense -->
    <#local catoCurrentTableLastRowAlt = alt>
    <#local dummy = setRequestVar("catoCurrentTableLastRowAlt", catoCurrentTableLastRowAlt)!>
  </#if>
</#macro>

<#-- @tr main markup - theme override -->
<#macro tr_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open>
    <tr<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>>
  </#if>
      <#nested>
  <#if close>
    </tr>
  </#if>
</#macro>

<#-- 
*************
* Table Cell
************
Helps define table cells.
                    
  * Parameters *
    class           = css classes 
                      supports prefixes:
                        "+": causes the classes to append only, never replace defaults (same logic as empty string "")
                        "=": causes the class to replace non-essential defaults (same as specifying a class name directly)
    id              = cell id
    open/close      = advanced structure control, for esoteric cases
    attribs               = hash of other legacy <th and <td attributes (mainly for those with dash in name)
    [inlineAttribs...]    = other legacy <th and <td attributes and values
-->
<#assign th_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro th args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.th_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <@th_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs><#nested></@th_markup>
</#macro>

<#-- @th main markup - theme override -->
<#macro th_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open><th<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>></#if><#nested><#if close></th></#if>
</#macro>

<#assign td_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro td args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.td_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <@td_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs><#nested></@td_markup>
</#macro>

<#-- @td main markup - theme override -->
<#macro td_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open><td<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>></#if><#nested><#if close></td></#if>
</#macro>

<#-- 
*************
* Table Row Class Attribute String
************
Helps build common data/table row class string (odd, even, etc.). Common pattern (in stock Ofbiz templates).
Usage discouraged: use @table, @tr macros instead.

  * Usage Example *  
    <tr<@tableRowClassAttribStr class="myClass" alt=false/>>
                    
  * Parameters *
    class           = css classes 
                      supports prefixes:
                        "+": causes the classes to append only, never replace defaults (same logic as empty string "")
                        "=": causes the class to replace non-essential defaults (same as specifying a class name directly)
    alt             = boolean, if true is alternate row (odd), if false regular (even)
    selected        = boolean, if true marked as selected
-->
<#assign tableRowClassAttribStr_defaultArgs = {
  "class":"", "alt":"", "selected":"", "passArgs":{}
}>
<#macro tableRowClassAttribStr args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.tableRowClassAttribStr_defaultArgs)>
  <#local dummy = localsPutAll(args)>

  <#if alt?is_boolean>
    <#local class = addClassArg(class, alt?string(styles.row_alt!, styles.row_reg!))>
  </#if>
  <#if selected?is_boolean && selected == true>
    <#local class = addClassArg(class, styles.row_selected!)>
  </#if>
  <@compiledClassAttribStr class=class /><#t>
</#macro>

<#-- 
*************
* Pricing Table
************
Since this is very foundation specific, this function may be dropped in future installations.

  * Usage Example *  
    <@pul >
        <@pli>Text or <a href="">Anchor</a></@pli>
    </@pul>            
                    
  * Parameters *
    title           = fieldset-title
    
-->
<#assign pul_defaultArgs = {
  "title":"", "passArgs":{}
}>
<#macro pul args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.pul_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@pul_markup title=title origArgs=origArgs passArgs=passArgs><#nested></@pul_markup>
</#macro>

<#-- @pul main markup - theme override -->
<#macro pul_markup title="" origArgs={} passArgs={} catchArgs...>
  <ul class="${styles.pricing_wrap!}">
    <@pli type="title">${title!}</@pli>
    <#nested>
  </ul>
</#macro>

<#assign pli_defaultArgs = {
  "type":"", "passArgs":{}
}>
<#macro pli args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.pli_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@pli_markup type=type origArgs=origArgs passArgs=passArgs><#nested></@pli_markup>
</#macro>

<#-- @pli main markup - theme override -->
<#macro pli_markup type="" origArgs={} passArgs={} catchArgs...>
  <#switch type>
    <#case "price">
      <li class="${styles.pricing_price!}"><#nested></li>
    <#break>
    <#case "description">
      <li class="${styles.pricing_description!}"><#nested></li>
    <#break>
    <#case "title">
      <li class="${styles.pricing_title!}"><#nested></li>
    <#break>
    <#case "button">
      <li class="${styles.pricing_cta!}"><#nested></li>
    <#break>        
    <#default>
      <li class="${styles.pricing_bullet!}"><#nested></li>
    <#break>
  </#switch>
</#macro>

<#-- 
*************
* Chart
************
Foundation Pizza: http://zurb.com/playground/pizza-amore-charts-and-graphs (customization through _base.scss)
Chart.js: http://www.chartjs.org/docs/ (customization through _charsjs.scss)

  * Usage Example *  
    <@chart type="bar" >
        <@chartdata value="36" title="Peperoni"/> 
    </@chart>              
                    
  * Parameters *
    type           = (pie|bar|line) (default:pie)
    library        = (foundation|chart) (default:foundation)
    title          = Data Title  (default:empty)
    datasets       = Number of datasets (1|2) (default:1) Only works for chart and bar|line
-->
<#assign chart_defaultArgs = {
  "type":"pie", "library":"foundation", "title":"", "datasets":1, "passArgs":{}
}>
<#macro chart args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.chart_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>

  <#global chartLibrary = library!"foundation"/>
  <#local chartIdNum = getRequestVar("catoChartIdNum")!0>
  <#local chartIdNum = chartIdNum + 1 />
  <#local dummy = setRequestVar("catoChartIdNum", chartIdNum)>
  <#global chartId = "chart_${renderSeqNumber!}_${chartIdNum!}"/>
  <#global chartType = type/>
  <#-- Allow just one or two datasets for now -->
  <#if datasets &lt;= 0 || datasets &gt; 2>
  	<#global chartDatasets = 1/>
  <#else>
  	<#global chartDatasets = datasets/>
  </#if>
  
  <@chart_markup type=type chartId=chartId chartIdNum=chartIdNum chartLibrary=chartLibrary chartDatasets=chartDatasets title=title 
    renderSeqNumber=renderSeqNumber origArgs=origArgs passArgs=passArgs><#nested></@chart_markup>
</#macro>

<#-- @chart main markup - theme override -->
<#macro chart_markup type="" chartLibrary="" title="" chartId="" chartIdNum=0 chartDatasets=1 renderSeqNumber=0 origArgs={} passArgs={} catchArgs...>
  <#if chartLibrary=="foundation">
    <@row>
      <@cell columns=3>    
        <ul data-${type!}-id="chart_${renderSeqNumber!}_${chartIdNum!}" class="${styles.chart_legend!}">
          <#nested/>
          <#--<#if !nestedContent?has_content><@chartdata value="0" title=""/></#if>-->
        </ul>
      </@cell>
      <@cell columns=9><div id="chart_${renderSeqNumber!}_${chartIdNum!}" style="height:300px;"></div></@cell>
    </@row>
  <#else>
    <canvas id="${chartId!}" class="${styles.grid_large!}12 chart-data" height="300" style="height:300px;"></canvas>
    <@script>
        $(function(){
            var chartDataEl = $('.chart-data:first-of-type');
            var chartData = chartDataEl.sassToJs({pseudoEl:":before", cssProperty: "content"});
            var options ={
                animation: false,
                responsive: true,
                maintainAspectRatio: true,
                scaleLineColor: chartData.scaleLineColor,
                scaleFontFamily: chartData.scaleFontFamily,
                scaleFontSize: chartData.scaleFontSize,
                scaleFontColor: chartData.scaleFontColor,
                scaleShowLabels: chartData.scaleShowLabels,
                scaleShowLabels: chartData.scaleShowLabels,
                scaleShowLine : chartData.scaleShowLine,
                angleShowLineOut : chartData.angleShowLineOut,
                scaleBeginAtZero : chartData.scaleBeginAtZero,
                showTooltips: chartData.showTooltips,
                tooltipFillColor: chartData.tooltipFillColor,
                tooltipFontFamily: chartData.tolltipFontFamily,
                tooltipFontSize: chartData.tooltipFontSize,
                tooltipFontStyle: chartData.tooltipFontStyle,
                tooltipFontColor: chartData.tooltipFontColor,
                tooltipTitleFontFamily: chartData.tooltipTitleFontFamily,
                tooltipTitleFontSize: chartData.tooltipTitleFontSize,
                tooltipTitleFontStyle: chartData.tooltipTitleFontStyle,
                tooltipTitleFontColor: chartData.tooltipTitleFontColor,
                tooltipYPadding: chartData.tooltipYPadding,
                tooltipXPadding: chartData.tooltipXPadding,
                tooltipCaretSize: chartData.tooltipCaretSize,
                tooltipCornerRadius: chartData.tooltipCornerRadius,
                datasetFill : chartData.datasetFill,
                tooltipTemplate: "<%if (label){%><%=label%>: <%}%><%= value %>",
                multiTooltipTemplate: "<%= value %>",
                pointDot : chartData.pointDot,
                pointHitDetectionRadius : chartData.pointHitDetectionRadius,
                pointDotRadius : chartData.pointDotRadius,
                pointDotStrokeWidth : chartData.pointDotStrokeWidth,
                <#if type=="line">
                bezierCurve : chartData.bezierCurve,
                bezierCurveTension : chartData.bezierCurveTension,
                legendTemplate : "<ul class=\"legend <%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li style=\"color:<%=datasets[i].strokeColor%> !important \"><span style=\"color:#efefef !important \"><%=datasets[i].value%>  <%if(datasets[i].label){%><%=datasets[i].label%><%}%></span></li><%}%></ul>",
                dataLabels: chartData.dataLabels
                <#elseif type=="pie">
                legendTemplate : "<ul class=\"legend <%=name.toLowerCase()%>-legend\"><% for (var i=0; i<segments.length; i++){%><li style=\"color:<%=segments[i].fillColor%> !important \"><span style=\"color:#efefef !important \"><%=segments[i].value%>  <%if(segments[i].label){%><%=segments[i].label%><%}%></span></li><%}%></ul>"
                <#else>
                legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].strokeColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
                </#if>
                };
            var ctx_${renderSeqNumber!}_${chartIdNum!} = $('#${chartId!}').get(0).getContext("2d");
            <#if type=="pie">
            var data = [];
            <#else>
            var data = {
                labels :[],
                datasets: [
                    {
                      fillColor: chartData.primaryFillColor,
                      strokeColor: chartData.primaryStrokeColor,
                      pointColor: chartData.pointColor,
                      pointStrokeColor: chartData.primaryPointStrokeColor,
                      pointHighlightFill: chartData.pointHighlightFill,
                      pointHighlightStroke: chartData.pointHighlightStroke,
                      label: "",
                      data: []
                    }
                    <#if chartDatasets == 2>,
                    {
                      fillColor: chartData.secondaryFillColor,
                      strokeColor: chartData.secondaryStrokeColor,
                      pointColor: chartData.pointColor,
                      pointStrokeColor: chartData.secondaryPointStrokeColor,
                      pointHighlightFill: chartData.pointHighlightFill,
                      pointHighlightStroke: chartData.pointHighlightStroke,
                      label: "",
                      data: []
                    }           
                    </#if>        
                    ]
                };
            </#if>
            var ${chartId!} = new Chart(ctx_${renderSeqNumber!}_${chartIdNum!})<#if type=="bar">.Bar(data,options);</#if><#if type=="line">.Line(data,options);</#if><#if type=="pie">.Pie(data,options);</#if>
            <#nested/>
        });
    </@script>
  </#if>
</#macro>

<#assign chartdata_defaultArgs = {
  "title":"", "value":"", "value2":"", "passArgs":{}
}>
<#macro chartdata args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.chartdata_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  
  <#if !chartLibrary?has_content>
    <#local chartLibrary = "foundation"/>
  </#if>

  <@chartdata_markup title=title value=value value2=value2 chartId=chartId chartType=chartType 
    chartLibrary=chartLibrary origArgs=origArgs passArgs=passArgs><#nested></@chartdata_markup>
</#macro>

<#-- @chartdata main markup - theme override -->
<#macro chartdata_markup title="" value="" value2="" chartId="" chartType="" chartLibrary="" origArgs={} passArgs={} catchArgs...>
  <#if chartLibrary=="foundation">
    <li<#if value2?has_content> data-y="${value!}" data-x="${value2!}"<#else> data-value="${value!}"</#if>>${title!}</li>
  <#else>
    <#if chartType="line" || chartType="bar">
      ${chartId!}.addData([<#if value?has_content>${value!}</#if><#if value2?has_content> ,${value2}</#if>]<#if title?has_content>,"${title!}"</#if>);      
    <#else>
      ${chartId!}.addData({value:${value!},color:chartData.color,highlight: chartData.highlight<#if title?has_content>,label:"${title!}"</#if>});
    </#if>
  </#if>
</#macro>

