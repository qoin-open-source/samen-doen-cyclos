<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-html"
    prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags/struts-bean"
    prefix="bean"%>
<bean:message key="paypal.message" />
<table class="defaultTable">
    <tr>
        <td class="label" width="25%"><br />
        <br />
        </td>
        <td><br />

<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="TTZDLYV3QBY9E">
<input type="hidden" name="custom" value="${loggedUser.username}">
<table>
<tr><td><input type="hidden" name="on0" value="Amount:">Amount:</td></tr><tr><td><select name="os0">
    <option value="10 top-up">£10.00 GBP</option>
    <option value="20 top-up">£20.00 GBP</option>
    <option value="30 top-up">£30.00 GBP</option>
    <option value="40 top-up">£40.00 GBP</option>
    <option value="50 top-up">£50.00 GBP</option>
    <option value="75 top-up">£75.00 GBP</option>
    <option value="100 top-up">£100.00 GBP</option>
    <option value="150 top-up">£150.00 GBP</option>
</select> </td></tr>
</table>
<input type="hidden" name="currency_code" value="GBP">
<input type="image" src="https://www.paypalobjects.com/en_GB/i/btn/btn_paynowCC_LG.gif" border="0" name="submit" alt="PayPal — The safer, easier way to pay online.">
<img alt="" border="0" src="https://www.paypalobjects.com/en_GB/i/scr/pixel.gif" width="1" height="1">
</form>
        </td>
    </tr>
</table>
