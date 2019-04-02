<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-html" prefix="html" %>
<%@ taglib uri="http://sslext.sf.net/tags/sslext" prefix="ssl" %>
<%@ taglib uri="http://devel.cyclos.org/tlibs/cyclos-core" prefix="cyclos" %>
<%@ taglib uri="http://www.servletsuite.com/servlets/toggletag" prefix="t" %> 

<c:set var="xzRepGrp" value="14" scope="request" />
<c:set var="contentUsername" value="${owner.username}" scope="request" />

<cyclos:script src="/pages/accounts/details/accountHistory.js" />
<script>
    var ownerId = "${owner.id}";
    var titleNotConciliated = "<cyclos:escapeJS><bean:message key="icon.title.notConciliated"/></cyclos:escapeJS>";
    var titleConciliated = "<cyclos:escapeJS><bean:message key="icon.title.conciliated"/></cyclos:escapeJS>";
    var backTo = "<cyclos:escapeJS>${backTo}</cyclos:escapeJS>";

<%-- adding additional event listener for tr tag as link (could alternatively be added in accountHistory.js) --%>
Behaviour.register({
       'tr.view': function(tr) {
        setPointer(tr);
        tr.onclick = viewDetails.bind(tr);
    }
})
</script>

<c:choose><c:when test="${myAccount}">
    <%-- Admin viewing system account or member viewing his account --%>
    <c:set var="titleKey" value="accountHistory.title.my"/>
</c:when><c:otherwise>
    <%-- Admin viewing member account or broker viewing his brokered's account --%>
    <c:set var="titleKey" value="accountHistory.title.of"/>
</c:otherwise></c:choose>

<ssl:form method="POST" action="${formAction}">
<html:hidden property="advanced"/>
<html:hidden property="memberId"/>
<html:hidden property="typeId"/>
<html:hidden property="query(owner)"/>
<html:hidden property="query(type)"/>

<c:set var="showAllFields" value="true"/>    <%-- ${accountHistoryForm.advanced || isAdmin}"/> --%>

<table style="width: 100%; height: 70px;" border="0">
        <tr>
            <td width="60%"><span style="font-size: 18px; font-weight: bold"><bean:message
                key="accountinformation" /><c:if test="${isAdmin}"> of ${owner.name}</c:if>
                </span></td>
            <td style="width: 40%;" align="right">
            <table>
                <tr>
                    <c:if test="${memberGroup == xzRepGrp}">
                    <td style="width: 50px"><img class="xreport"
                        src="<c:url value="/pages/images/xreport.png"/>" border="0"></td>
                    <td style="width: 50px"><img class="zreport"
                        src="<c:url value="/pages/images/zreport.png"/>" border="0"></td>
                    </c:if> 
                    <!--td style="width: 50px"><img class="paypal"
                        src="<c:url value="/pages/images/topup.png"/>" border="0"></td-->
                    <td style="width: 50px"><img class="exportCSV"
                        src="<c:url value="/pages/images/save.gif"/>" border="0"></td>
                    <td style="width: 50px"><img class="print"
                        src="<c:url value="/pages/images/print.gif"/>" border="0"></td>
                </tr>
                <tr>
                    <c:if test="${memberGroup == xzRepGrp}">
                    <td class="orangetext"><span class="xreport"><bean:message key="global.xreport" /></span></td>
                    <td class="orangetext"><span class="zreport"><bean:message key="global.zreport" /></span></td>
                    </c:if>
                    <!--td class="orangetext"><span class="paypal"><bean:message key="global.topup" /></span></td-->
                    <td class="orangetext"><span class="exportCSV"><bean:message key="global.export" /></span></td>
                    <td class="orangetext"><span class="print"><bean:message key="global.print" /></span></td>
                </tr>
            </table>
            </td>
        </tr>
    </table>

    <table border="0" width="100%" valign="top">
        <tr>
            <%-- left column --%>
            <td class="leftColumn">
            
            <%-- begin account balance --%>
            <table class="leftTopBox">
                <tr>
                    <c:if test="${not authorized}">
                        <td colspan="1" align="left" class=""
                            style="border-top: none">
                            <cyclos:layout columns="1"
                            className="defaultTable">
                            <%-- 
                            <c:if
                                test="${status.creditLimit > 0 or status.reservedAmount > 0}">
                                <cyclos:cell className="boldtext">
                                    <bean:message key="account.availableBalance" />:
                                </cyclos:cell>
                                <cyclos:cell className="balancetext">
                                    <cyclos:format number="${status.availableBalance}" unitsPattern="${unitsPattern}" />                                    
                                </cyclos:cell>
                            </c:if>
                            --%>
                            <c:set var="colorstyle" value="${entry.debit ? 'ClassColorDebit' : 'ClassColorCredit'}"/>
                            <cyclos:cell className="boldtext">
                                <bean:message key="account.balance" />:
                            </cyclos:cell>
                            <cyclos:cell className="balancetext ${colorstyle}" >
                                <cyclos:format number="${status.balance}"
                                    unitsPattern="${unitsPattern}" />
                            </cyclos:cell>
                            <%--
                            <c:if
                                test="${status.creditLimit > 0 and status.creditLimit != null}">
                                <cyclos:cell className="boldtext">
                                    <bean:message key="account.creditLimit" />:
                                </cyclos:cell>
                                <cyclos:cell className="balancetext">
                                    <cyclos:format number="${status.creditLimit}"
                                        unitsPattern="${unitsPattern}" />
                                </cyclos:cell>
                            </c:if>
                            <c:if
                                test="${status.reservedAmount > 0 and status.creditLimit != null}">
                                <cyclos:cell className="boldtext"> 
                                    <bean:message key="account.reservedAmount" />:
                                </cyclos:cell>
                                <cyclos:cell className="balancetext">
                                    <cyclos:format number="${status.reservedAmount}"
                                        unitsPattern="${unitsPattern}" />
                                </cyclos:cell>
                            </c:if>
                            <c:if
                                test="${status.upperCreditLimit > 0 and status.upperCreditLimit != null}">
                                <cyclos:cell className="boldtext">
                                    <bean:message key="account.upperCreditLimit" />:
                                </cyclos:cell>
                                <cyclos:cell className="balancetext">
                                    <cyclos:format number="${status.upperCreditLimit}"
                                        unitsPattern="${unitsPattern}" />
                                </cyclos:cell>
                            </c:if>
                            <c:if test="${isAdmin and (not empty dRate or not empty aRate)}">
                                <cyclos:rowBreak />
                                <c:if test="${not empty aRate}">
                                    <cyclos:cell className="boldtext">
                                        <bean:message key="account.aRate" />:
                                    </cyclos:cell>
                                    <cyclos:cell className="balancetext">
                                        <cyclos:format number="${aRate}" precision="3" />&nbsp;
                                <bean:message key="global.timePeriod.DAYS" />
                                    </cyclos:cell>
                                </c:if>
                                <c:if test="${not empty dRate}">
                                    <cyclos:cell className="boldtext">
                                        <bean:message key="account.dRate" />:
                                    </cyclos:cell>
                                    <cyclos:cell className="balancetext">
                                        <cyclos:format number="${dRate}" precision="3" />&nbsp;
                                <bean:message key="global.timePeriod.DAYS" />
                                    </cyclos:cell>
                                </c:if>
                            </c:if>--%>
                        </cyclos:layout>
                        <br/>
                        </td>
                    </c:if>
                </tr>
            </table>
            <%-- end account balance --%> <br />

            <%-- account search options --%>
            <table class="leftSearchBox" cellpadding="0">

                <tr>
                    <td class="tdHeaderTable">Search filter: <%-- 
                    <bean:message key="${titleKey}"
                        arg0="${owner.name}" arg1="${type.name}" /></td>
                    <cyclos:help page="payments#transaction_history" />
                    --%></td>
                </tr>



                <tr>
                    <td colspan="1" align="left" class="tdContentTableForms"><cyclos:layout
                        columns="1">
                        <c:choose>
                            <c:when test="${showAllFields}">

                                <c:choose>
                                    <c:when test="${not empty paymentStatus}">
                                        <cyclos:cell className="label">
                                            <bean:message key="payment.status" />
                                        </cyclos:cell>
                                        <cyclos:cell>
                                            <html:select property="query(status)">
                                                <c:forEach var="st" items="${paymentStatus}">
                                                    <html:option value="${st}">
                                                        <bean:message key="payment.status.${st}" />
                                                    </html:option>
                                                </c:forEach>
                                            </html:select>
                                        </cyclos:cell>
                                    </c:when>
                                    <c:otherwise>
                                        <cyclos:cell colspan="1">&nbsp;</cyclos:cell>
                                    </c:otherwise>
                                </c:choose>
                                <%-- payment type filter disabled for BRX --%>
                                <%--
                                <cyclos:cell className="label">
                                    <bean:message key="accountHistory.filter" />
                                </cyclos:cell>
                                <cyclos:cell>
                                    <html:select property="query(paymentFilter)">
                                        <html:option value="">
                                            <bean:message key="global.search.all" />
                                        </html:option>
                                        <c:forEach var="paymentFilter" items="${paymentFilters}">
                                            <html:option value="${paymentFilter.id}">${paymentFilter.name}</html:option>
                                        </c:forEach>
                                    </html:select>
                                </cyclos:cell>
                                --%>

                                <c:if test="${not empty groupFilters || not empty memberGroups}">
                                    <cyclos:rowBreak />
                                    <c:if test="${not empty groupFilters}">
                                        <cyclos:cell className="label">
                                            <bean:message key="member.groupFilter" />
                                        </cyclos:cell>
                                        <cyclos:cell>
                                            <input type="hidden" name="query(groupFilters)">
                                            <cyclos:multiDropDown name="query(groupFilters)"
                                                emptyLabelKey="member.search.allGroupFilters">
                                                <c:forEach var="groupFilter" items="${groupFilters}">
                                                    <cyclos:option value="${groupFilter.id}"
                                                        text="${groupFilter.name}" />
                                                </c:forEach>
                                            </cyclos:multiDropDown>
                                        </cyclos:cell>
                                    </c:if>
                                    <c:if test="${not empty memberGroups}">
                                        <cyclos:cell className="label">
                                            <bean:message key="member.group" />
                                        </cyclos:cell>
                                        <cyclos:cell>
                                            <input type="hidden" name="query(groups)">
                                            <cyclos:multiDropDown name="query(groups)"
                                                emptyLabelKey="member.search.allGroups">
                                                <c:forEach var="memberGroup" items="${memberGroups}">
                                                    <cyclos:option value="${memberGroup.id}"
                                                        text="${memberGroup.name}" />
                                                </c:forEach>
                                            </cyclos:multiDropDown>
                                        </cyclos:cell>
                                    </c:if>
                                    <cyclos:rowBreak />
                                </c:if>

                                <cyclos:cell className="label" >
                                    <bean:message key="member.username" />
                                </cyclos:cell>
                                <cyclos:cell>
                                    <html:hidden styleId="queryMemberId" property="query(member)" />
                                    <input id="memberUsername" class="small"
                                        value="${query.member.username}">
                                    <div id="membersByUsername" class="autoComplete"></div>
                                </cyclos:cell>
                                <cyclos:cell className="label" >
                                    <bean:message key="member.memberName" />
                                </cyclos:cell>
                                <cyclos:cell>
                                    <input id="memberName" class="small" 
                                        value="${query.member.name}">
                                    <div id="membersByName" class="autoComplete"></div>
                                </cyclos:cell>

                                <cyclos:cell className="label">
                                    <bean:message key="accountHistory.period.begin" />
                                </cyclos:cell>
                                <cyclos:cell >
                                    <html:text property="query(period).begin"
                                        styleClass="date small" />
                                </cyclos:cell>
                                <cyclos:cell className="label">
                                    <bean:message key="accountHistory.period.end" />
                                </cyclos:cell>
                                <cyclos:cell >
                                    <html:text property="query(period).end" styleClass="date small" />
                                </cyclos:cell>

                                <cyclos:cell className="label">
                                    <bean:message key="transfer.description" />
                                </cyclos:cell>
                                <cyclos:cell>
                                    <html:text property="query(description)" styleClass="medium" />
                                </cyclos:cell>

                                <c:if test="${not empty localSettings.transactionNumber}">
                                    <cyclos:cell className="label">
                                        <bean:message key="transfer.transactionNumber" />
                                    </cyclos:cell>
                                    <cyclos:cell>
                                        <html:text property="query(transactionNumber)"
                                            styleClass="full" />
                                    </cyclos:cell>
                                </c:if>

                                <c:if test="${showConciliated}">
                                    <cyclos:cell className="label">
                                        <bean:message
                                            key="accountHistory.conciliation.conciliationStatus" />
                                    </cyclos:cell>
                                    <cyclos:cell>
                                        <html:select property="query(conciliated)"
                                            styleClass="InputBoxEnabled">
                                            <html:option value="">
                                                <bean:message key="accountHistory.conciliation.all" />
                                            </html:option>
                                            <html:option value="true">
                                                <bean:message key="accountHistory.conciliation.conciliated" />
                                            </html:option>
                                            <html:option value="false">
                                                <bean:message
                                                    key="accountHistory.conciliation.notConciliated" />
                                            </html:option>
                                        </html:select>
                                    </cyclos:cell>
                                </c:if>

                                <c:forEach var="entry" items="${customFieldsForSearch}">
                                    <c:set var="field" value="${entry.field}" />
                                    <c:set var="value" value="${entry.value}" />
                                    <cyclos:cell className="label">${field.name}</cyclos:cell>
                                    <cyclos:cell>
                                        <cyclos:customField field="${field}" value="${value}"
                                            editable="true" valueName="query(customValues).value"
                                            fieldName="query(customValues).field" search="true" />
                                    </cyclos:cell>
                                </c:forEach>

                                <c:if test="${not empty operators}">
                                    <cyclos:rowBreak />
                                    <cyclos:cell className="label">
                                        <bean:message key="member.operator" />
                                    </cyclos:cell>
                                    <cyclos:cell colspan="3">
                                        <html:select property="query(by)">
                                            <html:option value="">
                                                <bean:message key="global.search.all" />
                                            </html:option>
                                            <c:forEach var="operator" items="${operators}">
                                                <html:option value="${operator.id}">${operator.name} (${operator.username})</html:option>
                                            </c:forEach>
                                        </html:select>
                                    </cyclos:cell>
                                </c:if>

                                <tr>
                                    <%--
                                    <td align="left" colspan="1"><c:if test="${!isAdmin}">
                                        <input id="modeButton" type="button" class="button"
                                            value="<bean:message key="global.search.NORMAL"/>">
                                    </c:if></td>
                                    --%>
                                    <td colspan="1"><input type="submit"
                                        class="button" value="<bean:message key="global.search"/>"></td>
                                </tr>
                            </c:when>
                            <c:otherwise>

                                <c:choose>
                                    <c:when test="${empty paymentStatus}">
                                        <%-- When there is no payment status, show on the same row the mode button and the filter --%>
                                        <tr>
                                            <td align="left"><input id="modeButton" type="button"
                                                class="button"
                                                value="<bean:message key="global.search.ADVANCED"/>"></td>
                                            <td align="right"><span class="label"><bean:message
                                                key="accountHistory.filter" /></span> <html:select
                                                styleId="filterSelect" property="query(paymentFilter)">
                                                <html:option value="">
                                                    <bean:message key="global.search.all" />
                                                </html:option>
                                                <c:forEach var="filter" items="${paymentFilters}">
                                                    <html:option value="${filter.id}">${filter.name}</html:option>
                                                </c:forEach>
                                            </html:select></td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Show On a row the status and filter, and in the other, the mode button --%>
                                        <tr>
                                            <td class="label"><bean:message key="payment.status" /></td>
                                            <td><html:select styleId="statusSelect"
                                                property="query(status)">
                                                <c:forEach var="st" items="${paymentStatus}">
                                                    <html:option value="${st}">
                                                        <bean:message key="payment.status.${st}" />
                                                    </html:option>
                                                </c:forEach>
                                            </html:select></td>
                                            <td class="label"><bean:message
                                                key="accountHistory.filter" /></td>
                                            <td><html:select styleId="filterSelect"
                                                property="query(paymentFilter)">
                                                <html:option value="">
                                                    <bean:message key="global.search.all" />
                                                </html:option>
                                                <c:forEach var="filter" items="${paymentFilters}">
                                                    <html:option value="${filter.id}">${filter.name}</html:option>
                                                </c:forEach>
                                            </html:select></td>
                                        </tr>
                                        <tr>
                                            <td align="left"><input id="modeButton" type="button"
                                                class="button"
                                                value="<bean:message key="global.search.ADVANCED"/>"></td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>

                            </c:otherwise>
                        </c:choose>
                    </cyclos:layout></td>
                </tr>

            </table>
            </td>
            <%-- end table search options --%>
            <%-- right hand column --%>
            <td class="rightColumn">
            <table class="defaultTableContent" cellspacing="0" cellpadding="0">
                <%-- 
    <tr>
        <td class="tdHeaderTable"><bean:message
            key="global.searchResults" /></td>
        <td class="tdHelpIcon" align="right" width="15%" valign="middle"
            nowrap="nowrap"><img class="exportCSV"
            src="<c:url value="/pages/images/save.gif"/>" border="0"> <img
            class="print" src="<c:url value="/pages/images/print.gif"/>"
            border="0"> <cyclos:help
            page="payments#transaction_history_result" td="false" /></td>
    </tr>
    --%>



                <tr>
                    <td colspan="1" align="left">
                    <table class="defaultTable">
                        <tr>
                            <c:if test="${showConciliated}">
                                <th class="ohdr gr1" width="5%">&nbsp;</th>
                            </c:if>
                            <th class="ohdr gr1" width="15%" style="padding-left:15px;"><bean:message
                                key="transfer.date" /></th>
                            <th class="ohdr gr2" width="25%"><bean:message
                                key="transfer.fromOrTo" /></th>
                            <th class="ohdr gr3"><bean:message
                                key="transfer.description" /></th>
                            <th class="tdHeaderContentsinter" width="1%"></th>  
                            <th class="tdHeaderContentsreverse" align="right" width="15%"><bean:message
                                key="transfer.amount" /></th>
                            <c:forEach var="field" items="${customFieldsForList}">
                                <th class="tdHeaderContents">${field.name}</th>
                            </c:forEach>    
                            </tr>
                        <c:set var="memberProperty"
                            value="${localSettings.memberResultDisplay.property}" />
                        <c:forEach var="entry" items="${accountHistory}">
                            <c:set var="transfer" value="${entry.transfer}" />
                            <c:set var="related" value="${entry.related}" />
                            <c:set var="className" value="${entry.debit ? 'ClassColorDebit' : 'ClassColorCredit'}"/>
                            <tr class="view" transferId="${transfer.id}"
                                 onmouseover="style.opacity='0.8';"
                                onmouseout="style.opacity='1.0'">
                                <c:if test="${showConciliated}">
                                    <td align="left" style="height:30px"><c:if
                                        test="${transfer.type.conciliable}">
                                        <c:choose>
                                            <c:when test="${empty transfer.externalTransfer}">
                                                <img class="not_conciliated"
                                                    src="<c:url value="/pages/images/pending.gif"/>">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="conciliated"
                                                    src="<c:url value="/pages/images/conciliated.gif"/>">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if></td>
                                </c:if>
                                <td class="<t:toggle>grg1a|grg1b</t:toggle>" align="left" style="height:30px; padding-left:15px;"
                                onmouseover="style.color='#F08A00'"
                                onmouseout="style.color='#646464'"
                                ><cyclos:format
                                    date="${transfer.processDate == null ? transfer.date : transfer.processDate}" /></td>
                                <td class="<t:toggle>grg2b|grg2a</t:toggle>" align="left" style="height:30px; color: #000000"
                                onmouseover="style.color='#F08A00'"
                                onmouseout="style.color='#000000'"                              
                                >
<c:set var="relatedNature" value="${cyclos:name(related.nature)}"/>
 ? ? ? ? ? ? ? ? ? ? ? ? ? ?<c:choose><c:when test="${relatedNature == 'SYSTEM'}">
 ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?${related.ownerName}
 ? ? ? ? ? ? ? ? ? ? ? ? ? ?</c:when><c:otherwise>
 ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?<cyclos:profile elementId="${entry.relatedMemberId}"/>
 ? ? ? ? ? ? ? ? ? ? ? ? ? ?</c:otherwise></c:choose></td>
                                <c:choose>
                                    <c:when test="${transfer.chargedBackBy != null}">
                                        <td class="<t:toggle>grg3a|grg3b</t:toggle>" align="left" 
                                            style="font-style: italic; font-size:11px; text-decoration: line-through;"
                                            onmouseover="style.color='#F08A00'"
                                            onmouseout="style.color='#646464'"
                                            ><cyclos:truncate
                                            value="${transfer.description}" /></td>
                                    </c:when>
                                    <c:otherwise>
                                        <td class="<t:toggle>grg3a|grg3b</t:toggle>" align="left" style="font-size:11px"
                                        onmouseover="style.color='#F08A00'"
                                        onmouseout="style.color='#646464'"
                                        ><div transferId="${transfer.id}" class="view"><cyclos:truncate
                                            value="${transfer.description}" /></div></td>
                                    </c:otherwise>
                                </c:choose>
                                <td class="<t:toggle>grg4b|grg4a</t:toggle>"></td>
                                <td class="<t:toggle>grg5a|grg5b</t:toggle> ${className}" align="center" 
                                <%-- %>style="color:#000000;"
                                onmouseover="style.color='#F08A00'"
                                onmouseout="style.color='#000000'"--%>                                  
                                ><cyclos:format
                                    number="${transfer.actualAmount * entry.signal}"
                                    forceSignal="true" /> </td>
                                <c:forEach var="field" items="${customFieldsForList}">
                                    <td><cyclos:customField field="${field}"
                                        collection="${transfer.customValues}" textOnly="true" /></td>
                                </c:forEach>
                            </tr>
                            </c:forEach>
                    </table>
                    </td>
                </tr>
            </table>
            </td>
        </tr>
    </table>

    <table class="defaultTableContentHidden" cellpadding="0"
        cellspacing="0">
        <tr>
            <td align="right"><cyclos:pagination items="${transfers}" /></td>
        </tr>
    </table>
    </ssl:form>