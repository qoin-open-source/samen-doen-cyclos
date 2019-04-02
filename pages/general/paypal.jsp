<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-bean"
    prefix="bean"%>
<%@ taglib uri="http://devel.cyclos.org/tlibs/cyclos-core"
    prefix="cyclos"%>

<cyclos:script src="/pages/general/paypal.js" />

<table class="defaultTableContent" cellspacing="0" cellpadding="0">
    <tr>
        <td class="tdHeaderTable"><bean:message key="paypal.title" /></td>
        <cyclos:help page="user_management#paypal" />
    </tr>
    <tr>
        <td class="tdContentTable" colspan="2" style="text-align: justify">
        <cyclos:includeCustomizedFile type="static" name="paypal-pay.jsp" />
        </td>
    </tr>
</table>
<table class="defaultTableContentHidden">
    <tr>
        <td align="left"><input type="button" class="button"
            id="backButton" value="<bean:message key="global.back"/>"></td>
    </tr>
</table>
