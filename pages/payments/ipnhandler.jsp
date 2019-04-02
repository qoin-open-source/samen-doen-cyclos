<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="nl.strohalm.cyclos.webservices.*" %>
<%@ page import="nl.strohalm.cyclos.webservices.payments.*" %>

<%
// read post from PayPal system and add 'cmd'
Enumeration en = request.getParameterNames();
String str = "cmd=_notify-validate";
while(en.hasMoreElements()){
String paramName = (String)en.nextElement();
String paramValue = request.getParameter(paramName);
str = str + "&" + paramName + "=" + URLEncoder.encode(paramValue);
}

// post back to PayPal system to validate
// URL u = new URL("https://www.sandbox.paypal.com/cgi-bin/webscr");   //test environment
URL u = new URL("https://www.paypal.com/cgi-bin/webscr");
URLConnection uc = u.openConnection();
uc.setDoOutput(true);
uc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
PrintWriter pw = new PrintWriter(uc.getOutputStream());
pw.println(str);
pw.close();

BufferedReader in = new BufferedReader(
new InputStreamReader(uc.getInputStream()));
String res = in.readLine();
in.close();

//check notification validation
if(res.equals("VERIFIED")) {
// assign posted variables to local variables
String itemName = request.getParameter("item_name");
String itemNumber = request.getParameter("item_number");
String paymentStatus = request.getParameter("payment_status");
String paymentCurrency = request.getParameter("mc_currency");
String txnId = request.getParameter("txn_id");
String receiverEmail = request.getParameter("receiver_email");
String payerEmail = request.getParameter("payer_email");
String toMember = request.getParameter("custom");
BigDecimal paymentGross = new BigDecimal(request.getParameter("mc_gross"));
BigDecimal paymentFee = new BigDecimal(request.getParameter("mc_fee"));
BigDecimal paymentAmount = paymentGross.subtract(paymentFee);

// process payment
CyclosWebServicesClientFactory factory = new CyclosWebServicesClientFactory();
//factory.setServerRootUrl("http://127.0.0.1:10080/monea");
factory.setServerRootUrl("https://brixtonpound.monea.cc/monea");
PaymentWebService paymentWebService = factory.getPaymentWebService();
BufferedReader wsin = new BufferedReader(new InputStreamReader(System.in));
PaymentParameters params = new PaymentParameters();

// Set the parameters
params.setAmount(paymentAmount);
params.setFromSystem(true);
params.setToMember(toMember);
params.setDescription("PayPal account top-up");

// Perform the payment
PaymentResult result = paymentWebService.doPayment(params);
String log = "";
switch (result.getStatus()) {
    case PROCESSED:
        String transactionNumber = result.getTransfer().getTransactionNumber();
        log = ("The payment was successful. The transaction number is " + transactionNumber);
        break;
    case PENDING_AUTHORIZATION:
        System.out.println("The payment is awaiting authorization");
        break;
    case INVALID_CHANNEL:
        System.out.println("The given user cannot access this channel");
        break;
    case INVALID_CREDENTIALS:
        System.out.println("You have entered an invalid PIN");
        break;
    case BLOCKED_CREDENTIALS:
        System.out.println("Your PIN is blocked by exceeding trials");
        break;
    case INVALID_PARAMETERS:
        System.out.println("Please, check the given parameters");
        break;
    case NOT_ENOUGH_CREDITS:
        System.out.println("You don't have enough funds for this payment");
        break;
    case MAX_DAILY_AMOUNT_EXCEEDED:
        System.out.println("You have already exceeded the maximum amount today");
        break;
    default:
        System.out.println("There was an error on the payment: " + result.getStatus());
        log = ("There was an error on the payment: " + result.getStatus());
}
}
else if(res.equals("INVALID")) {
// do nothing
}
else {
// error
}

%>

