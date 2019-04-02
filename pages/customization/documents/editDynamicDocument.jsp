<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-html" prefix="html" %>
<%@ taglib uri="http://sslext.sf.net/tags/sslext" prefix="ssl" %>
<%@ taglib uri="http://devel.cyclos.org/tlibs/cyclos-core" prefix="cyclos" %>
<%@ taglib uri="http://www.servletsuite.com/servlets/toggletag" prefix="t" %> 

<cyclos:script src="/pages/customization/documents/editDynamicDocument.js" />

<ssl:form method="post" action="${formAction}">
<html:hidden property="documentId" />
<html:hidden property="document(id)" />
<table class="defaultTableContent" cellspacing="0" cellpadding="0">
    <tr>
        <td class="tdHeaderTable">
        	<bean:message key="${empty document.id ? 'document.title.insert' : 'document.title.modify'}"/>
        </td>
        <cyclos:help page="documents#new_edit_dynamic_document"/>
    </tr>
    <tr>
        <td colspan="2" align="left" class="tdContentTableForms">
            <table class="defaultTable">
                <tr>
                    <td class="label" width="25%"><bean:message key="document.name"/></td>
                    <td><html:text property="document(name)" disabled="true" styleClass="full InputBoxDisabled"/></td>
                </tr>
                <tr>
                    <td class="label" valign="top"><bean:message key="document.description"/></td>
                    <td><html:textarea rows="4" styleId="descriptionText" disabled="true" property="document(description)" styleClass="full InputBoxDisabled"/></td>
                </tr>
                <tr>
                    <td class="label" valign="top"><bean:message key="document.formPage"/></td>
                    <td>
                    	<html:hidden property="document(formPage).id"/>
                    	<html:textarea styleClass="full InputBoxDisabled" disabled="true" styleId="formPageText" rows="8" property="document(formPage).contents"/>
                    </td>
                </tr>
                <tr>
                    <td class="label" valign="top"><bean:message key="document.documentPage"/></td>
                    <td>
                    	<html:hidden property="document(documentPage).id"/>
                    	<html:textarea styleClass="full InputBoxDisabled" disabled="true" styleId="documentPageText" rows="8" property="document(documentPage).contents"/>
                    </td>
                </tr>
                <c:if test="${cyclos:granted(AdminMemberPermission.DOCUMENTS_MANAGE_DYNAMIC)}">
	                <tr>
						<td align="right" colspan="2">
							<input type="button" id="modifyButton" class="button" value="<bean:message key="global.change"/>">
							&nbsp;
	                		<input type="submit" id="saveButton" class="ButtonDisabled" disabled value="<bean:message key="global.submit"/>" >
						</td>
	                </tr>
	            </c:if>
            </table>
		</td>            
    </tr>
</table>

<table class="defaultTableContentHidden">
	<tr>
		<td align="left">
			<input type="button" class="button" id="backButton" value="<bean:message key="global.back"/>">
		</td>
	</tr>
</table>
</ssl:form>
