<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="nl.strohalm.cyclos.webservices.*" %>
<%@ page import="nl.strohalm.cyclos.webservices.payments.*" %>
<%@ page import="com.stripe.Stripe" %>
<%@ page import="com.stripe.exception.*" %>
<%@ page import="com.stripe.model.*" %>

<%
	//TODO:request body is json, so get parameter id in root of the json
	// THIS gets the 'id' GET or POST parameter from any request
    String webhookId = request.getParameter("id");
    
    Stripe.apiKey = "sk_test_5yiUlrIJyenImuKV5blQ7Wrd";
    
    try {
    	// can't use 'response' as a variable name, as it is already defined by the jsp mechanism    
        Event eventResponse = Event.retrieve(webhookId);
        
        Boolean vLivemode = eventResponse.getLivemode();
        EventData vRecipient = eventResponse.getData();
        String recipient = ((Charge)vRecipient.getObject()).getDescription();
        double amount = (((Charge)vRecipient.getObject()).getAmount().doubleValue() / 100.0);
        
        EventData vData = eventResponse.getData();
        String vCurrency = ((Charge)vData.getObject()).getCurrency();
        
        Boolean vPaid = ((Charge)vData.getObject()).getPaid();

        //TODO: test version, account linked to provided apiKey is in usd, adjust to your test account currency
        //if (!vLivemode && vCurrency.equals("usd") && vPaid) {

        //TODO: live version
        if (vLivemode && vCurrency.equals("gbp") && vPaid) {
            // process payment
			CyclosWebServicesClientFactory factory = new CyclosWebServicesClientFactory();
            // CYCLOS IS NOT necessarily available on port 8080
			factory.setServerRootUrl("http://localhost:8080/");
			PaymentWebService paymentWebService = factory.getPaymentWebService();
			PaymentParameters params = new PaymentParameters();

			// Set the parameters
			params.setAmount(new BigDecimal(amount));
			params.setFromSystem(true);
			params.setToMember(recipient);
			params.setDescription("Stripe account top-up");

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
			
			//TODO: return 200
			// response from the JSP page will be 200 unless set to be otherwise (it's just a server scripted template)
			//return ok();
        }
        
    } catch (Exception ex) {
    	// TODO: return anything but 200
	    response.sendError(500, "Something bad happened" );
		// return badRequest();
    }
    
    //TODO: return anything but 200
    response.sendError(500, "Something bad happened (2)" );
    //return badRequest();	
%>