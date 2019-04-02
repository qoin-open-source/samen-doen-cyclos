<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-bean"
    prefix="bean"%>
<%@ taglib uri="http://devel.cyclos.org/tlibs/cyclos-core"
    prefix="cyclos"%>

<cyclos:script src="/pages/members/cc2/listCharities.js" />

<table class="defaultTableContent" cellspacing="0" cellpadding="0">
    <tr>
        <td class="tdHeaderTable"><bean:message key="charities.title" /></td>
        <cyclos:help page="user_management#charities" />
    </tr>
    <tr>
        <td class="tdContentTable" colspan="2" style="text-align: justify">

<c:forEach var="charities" items="${charities}">
<ul style="margin-left:0px;float:left;width:160px;">
  <li style="width:160px;height:100px;list-style: none outside none;margin:2px;padding:2px;">
<a class="payCharityLink" elementId="${charities.id}"><cyclos:images images="${charities.images}" imageOnly="true" /></a>
  </li>
  <li style="width:120px;list-style: none outside none;margin:2px;padding:2px;">
<a class="payCharityLink" elementId="${charities.id}">${charities.name}</a></div>
</li></ul></c:forEach>
        </td>
    </tr>
</table>
<table class="defaultTableContentHidden">
    <tr>
        <td align="left"><input type="button" class="button"
            id="backButton" value="<bean:message key="global.back"/>"></td>
    </tr>
</table>
