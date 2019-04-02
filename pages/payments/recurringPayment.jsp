<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-html" prefix="html" %>
<%@ taglib uri="http://sslext.sf.net/tags/sslext" prefix="ssl" %>
<%@ taglib uri="http://devel.cyclos.org/tlibs/cyclos-core" prefix="cyclos" %>

<cyclos:script src="/pages/payments/recurringPayment.js" />
<script>
    var noTransferTypeMessage = "<cyclos:escapeJS><bean:message key='payment.error.noTransferType'/></cyclos:escapeJS>";
    var paymentNumberLabel = "<cyclos:escapeJS><bean:message key='transfer.number'/></cyclos:escapeJS>";
    var paymentDateLabel = "<cyclos:escapeJS><bean:message key='transfer.date'/></cyclos:escapeJS>";
    var paymentAmountLabel = "<cyclos:escapeJS><bean:message key='transfer.amount'/></cyclos:escapeJS>";
    var today = new Date(${currentTime});
    var transferTypes = [];
    <c:forEach var="type" items="${transferTypes}">
        transferTypes.push({'id':${type.id}, 'name':'<cyclos:escapeJS>${type.name}</cyclos:escapeJS>', 'currencyId':'${type.from.currency.id}', 'allowsScheduledPayments':${type.allowsScheduledPayments}});
    </c:forEach>
    var profileMemberId = "${member.id}";
</script>

<ssl:form method="post" action="${formAction}">
<html:hidden property="from"/>
<html:hidden property="toSystem"/>
<html:hidden property="selectMember"/>

<table class="defaultTableContent" cellspacing="0" cellpadding="0">
    <tr>
        <td class="tdHeaderTable"><bean:message key="${titleKey}" arg0="${member.name}"/></td>
        <cyclos:help page="${(asMember) ? (toSystem ? 'payments#as_member_to_system' : 'payments#as_member_to_member') : (toSystem ? 'payments#to_system' : 'payments#to_member')}"/>
    </tr>
    <tr>
        <td colspan="2" align="left"><bean:message key="recurringPayment.message" /></td>
    </tr>
    <tr>
        <td colspan="2" align="left" class="tdContentTableForms">
            <table class="defaultTable">
                <c:choose>
                    <c:when test="${toSystem}">
                        <%-- Any special handling for member-to-system payments? --%>
                    </c:when>
                    <c:when test="${selectMember}">
                        <%-- The user must select a member --%>
                        <tr>
                            <td class="label" width="25%"><bean:message key='payment.recipientUsername'/></td>
                            <td>
                                <html:hidden styleId="memberId" property="to"/>
                                <input id="memberUsername" class="large">
                                <div id="membersByUsername" class="autoComplete"></div>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" width="25%"><bean:message key='payment.recipientName'/></td>
                            <td>
                                <input id="memberName" class="large">
                                <div id="membersByName" class="autoComplete"></div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <%-- The member has been already selected from the profile --%>                 
                        <tr>
                            <td class="label" width="25%"><bean:message key='transfer.recurringto'/></td>
                            <td>
                                <html:hidden property="to"/>
                                <input class="InputBoxDisabled large" readonly value="${member.name}">
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                <tr>
                    <td class="label" width="25%"><bean:message key='transfer.recurringamount'/></td>
                    <td><input class="InputBox large" type="text" name="recurringAmount" id="recurringAmount" />
                                <html:hidden property="amount" styleId="amount" />
<!--                               <br />  <input id="totalAmount" class="InputBoxDisabled large" readonly> -->
                        <c:choose><c:when test="${not empty singleCurrency}">
                            <html:hidden property="currency" value="${singleCurrency.id}" />
                            ${singleCurrency.symbol}
                        </c:when><c:otherwise>
                            <html:select property="currency" styleId="currencySelect">
                                <c:forEach var="currency" items="${currencies}">
                                    <html:option value="${currency.id}">${currency.symbol}</html:option>
                                </c:forEach>
                            </html:select>
                        </c:otherwise></c:choose>
                    </td>
                </tr>
                <tr id="typeRow" style="display:none">
                    <td class="label" width="25%"><bean:message key='transfer.type'/></td>
                    <td id="typeCell"></td>
                </tr>
                <tr id="customValuesRow" style="display:none">
                    <td colspan="2" id="customValuesCell" style="padding:0px;">
                    </td>
                </tr>
                <c:if test="${cyclos:granted(AdminMemberPermission.PAYMENTS_PAYMENT_WITH_DATE)}">
                    <tr>
                        <td class="label" width="25%"><bean:message key='payment.setDate'/></td>
                        <td><input type="checkbox" class="checkbox" id="setDateCheck"></td>
                    </tr>
                    <tr id="pastDate" style="display:none">
                        <td class="label"><bean:message key='payment.manualDate'/></td>
                        <td><html:text styleId="dateText" property="date" styleClass="small date"/></td>
                    </tr>
                </c:if>
                
                <c:if test="${allowsScheduling}">
                    <tr id="trSchedulingType" class="scheduling" style="display:none">
                        <td class="label"><bean:message key='transfer.scheduling'/></td>
                        <td>
                            <select id="schedulingTypeSelect">
                                <c:forEach var="type" items="${schedulingTypes}">
                                    <option value="${type}"><bean:message key='transfer.scheduling.${type}'/></option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    
                    <tr class="scheduling singlePayment" style="display:none">
                        <td class="label"><bean:message key='transfer.scheduledFor'/></td>
                        <td>
                            <input type="text" class="small date" id="scheduleForText">
                            <div id="singlePaymentContainer" style="display:none"></div>
                        </td>
                    </tr>
                    
                    <c:if test="${allowsMultipleScheduling}">
                        <tr class="scheduling multiplePayments" style="display:none">
                            <td class="label"><bean:message key='transfer.numberOfPayments'/></td>
                            <td nowrap="nowrap">
                                <input type="text" class="tiny number" maxlength="2" id="paymentCountText">
                                &nbsp;&nbsp;&nbsp;
                                <span class="label"><bean:message key='transfer.firstPaymentDate'/></span>
                                <input type="text" class="small date" id="firstPaymentDateText">
                            </td>
                        </tr>
                        <tr class="scheduling multiplePayments" style="display:none">
                            <td class="label" width="25%"><bean:message key='transfer.paymentEvery'/></td>
                            <td nowrap="nowrap">
                                <input type="text" class="InputBoxDisabled tiny number" readonly maxlength="2" id="recurrenceNumberText" value="1">
                                <select id="recurrenceFieldSelect">
                                    <c:forEach var="field" items="${schedulingFields}">
                                        <option value="${field}"><bean:message key='global.timePeriod.${field}'/></option>
                                    </c:forEach>
                                </select>
                                &nbsp;&nbsp;&nbsp;
<!--                                 <input type="button" id="calculatePaymentsButton" class="button" value="<bean:message key="transfer.calculatePayments"/>"> -->
                                
                            </td>
                        </tr>
                        <tr class="scheduling multiplePayments" style="display:none">
                            <td></td>
                            <td id="paymentsContainer"></td>
                        </tr>
                    </c:if>
                </c:if>
                       
                <tr>
                    <td colspan="2" align="right">
                    <input type="hidden" id="descriptionId" name="description" value="Charitable donation to ${member.name}" />
                    <input type="submit" id="submitButton" class="button" value="<bean:message key='global.submit'/>"></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<c:if test="${param.fromQuickAccess || not empty paymentForm.to || not empty paymentForm.from}">
    
    <table class="defaultTableContentHidden">
        <tr>
            <td>
                <input type="button" class="button" id="backButton" value="<bean:message key='global.back'/>">
            </td>
        </tr>
    </table>
</c:if>

</ssl:form>