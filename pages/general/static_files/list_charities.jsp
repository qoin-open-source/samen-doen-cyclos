<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-bean" prefix="bean" %>
<bean:message key="listCharities.message" />

<table class="defaultTable">
    <tr>
        <td class="label" width="25%"><br />
        <br />
        </td>
        <td><br />
<!--  NB cyclos:images tag doesn't work in an 'included file' - ie at this level - so moved up to the application page  -->


    <c:forEach var="charities" items="${charities}">
        <a class="payCharityLink" elementId="${charities.id}"><cyclos:images images="${charities.images}" imageOnly="true" />${charities.name}</a><br />
    </c:forEach>

        </td>
    </tr>
</table>