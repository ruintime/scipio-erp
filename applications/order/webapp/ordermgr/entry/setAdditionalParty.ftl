<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<#-- ==================== Party Selection dialog box ========================= -->
<@section>
<@table type="fields" border="0" width="100%" cellspacing="0" cellpadding="0">
  <form method="post" action="<@ofbizUrl>finalizeOrder</@ofbizUrl>" name="checkoutsetupform">
    <input type="hidden" name="finalizeReqAdditionalParty" value="false"/>
    <input type="hidden" name="finalizeMode" value="addpty"/>
  </form>
  <form method="post" action="<@ofbizUrl>setAdditionalParty</@ofbizUrl>" name="quickAddPartyForm">

  <@tr>
    <@td>1) ${uiLabelMap.OrderSelectPartyToOrder} :</@td>
  </@tr>
  <@tr>
    <@td width="100%">
      <@table type="fields" border="0" cellspacing="0" cellpadding="0" class="+boxbottom"> <#-- orig: class="boxbottom" -->
        <@tr>
          <@td align="right">
            <input type="radio" id="additionalPartyType_Person" name="additionalPartyType" value="Person" onclick="<#if additionalPartyType??>javascript:document.quickAddPartyForm.additionalPartyId.value='';</#if>document.quickAddPartyForm.submit()"<#if (additionalPartyType?? && additionalPartyType == "Person")> checked="checked"</#if> />
        </@td>
          <@td>
            <label for="additionalPartyType_Person">${uiLabelMap.CommonPerson}</label>
          </@td>
        </@tr>
        <@tr>
          <@td align="right">
            <input type="radio" id="additionalPartyType_Group" name="additionalPartyType" value="Group" onclick="<#if additionalPartyType??>javascript:document.quickAddPartyForm.additionalPartyId.value='';</#if>document.quickAddPartyForm.submit()"<#if additionalPartyType?? && additionalPartyType == "Group"> checked="checked"</#if> />
          </@td>
          <@td>
            <label for="additionalPartyType_Group">${uiLabelMap.CommonGroup}</label>
          </@td>
        </@tr>
        <@tr>
          <@td align="right">
            <input type="radio" id="additionalPartyType_None" name="additionalPartyType" value="None" onclick="<#if additionalPartyType??>javascript:document.quickAddPartyForm.additionalPartyId.value='';</#if>document.quickAddPartyForm.submit()"<#if !additionalPartyType??> checked="checked"</#if> />
          </@td>
          <@td>
            <label for="additionalPartyType_None">${uiLabelMap.OrderPartyDontWish}</label>
          </@td>
        </@tr>
      </@table>
    </@td>
  </@tr>

  <@tr>
    <@td>&nbsp;</@td>
  </@tr>

  <#if additionalPartyType?? && additionalPartyType != "" && additionalPartyType != "None">
    <#if additionalPartyType == "Person">
      <#assign lookupPartyView="LookupPerson">
    <#else>
      <#assign lookupPartyView="LookupPartyGroup">
    </#if>
  <@tr>
    <@td>2) ${uiLabelMap.PartyFindParty} :</@td>
  </@tr>

  <@tr>
    <@td width="100%">
      <@table type="fields" border="0" cellspacing="0" cellpadding="0" class="+boxbottom"> <#-- orig: class="boxbottom" -->
        <@tr>
          <@td>${uiLabelMap.CommonIdentifier} :</@td>
          <@td>
            <@htmlTemplate.lookupField value="${additionalPartyId!}" formName="quickAddPartyForm" name="additionalPartyId" id="additionalPartyId" fieldFormName="${lookupPartyView}"/>
          </@td>
          <@td>
            &nbsp;<a href="javascript:document.quickAddPartyForm.submit()" class="${styles.button_default!}">${uiLabelMap.CommonApply}</a>
          </@td>
        </@tr>
      </@table>
    </@td>
  </@tr>

  <@tr>
    <@td>&nbsp;</@td>
  </@tr>

  </form>

  <#if roles?has_content>
  <@tr>
    <@td>3) ${uiLabelMap.OrderPartySelectRoleForParty} :</@td>
  </@tr>

  <@tr>
    <@td width="100%">
      <@table type="fields" border="0" cellspacing="0" cellpadding="0" class="+boxbottom"> <#-- orig: class="boxbottom" -->
        <form method="post" action="<@ofbizUrl>addAdditionalParty</@ofbizUrl>" name="addAdditionalPartyForm" id="addAdditionalPartyForm">
        <@tr>
          <@td>&nbsp;</@td>
          <@td>
            <@input type="select" name="additionalRoleTypeId" id="additionalRoleTypeId" size="5" multiple="multiple">
              <#list roles as role>
              <option value="${role.roleTypeId}">${role.get("description",locale)}</option>
              </#list>
            </@input>
          </@td>
          <@td>&nbsp;</@td>
          <@td>
            <input type="hidden" name="additionalPartyId" value="${additionalPartyId}" />
            <input type="submit" class="smallSubmit ${styles.button_default!}" value="${uiLabelMap.CommonAdd} "/>
          </@td>
        </@tr>
        </form>
      </@table>
    </@td>
  </@tr>
  </#if> <#-- roles?has_content -->
  <#else>
  </form>
  </#if> <#-- additionalPartyType?has_content -->
</@table>
</@section>
