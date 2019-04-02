<%@ page import="java.util.*,java.text.*,java.security.*,java.net.URLEncoder" %>
<%@ page import="nl.strohalm.cyclos.entities.access.User,org.apache.commons.codec.binary.*" %>
<% 

/* 
   Qoin Virtual Currency Project
   Isotoma 5/8/2011

   This page is used to enable a user logged in to Cyclos to access the reporting app without logging in again. 
   It takes a query string parameter, "report".

   On starting it attempts to get the current user ID, if it fails then it redirects the user to the login page.

   If it succeeds, then it generates a token in the following format:

   base64(userId:isAdmin(true|false):unixtimestamp:md5hash(userId:isAdmin:unixtimestamp:secretPassword))

   The user is then redirected to reportingURL/$report?token=theBase64Token

   This file can just be dropped inside the root of the cyclos webapp. No other changes are needed.

   It would be cleaner if this was a servlet, but JSP avoids a lot of boiler plate - and a servlet would
   require us to modify the cyclos provided web.xml etc.
*/
   
// Config
final String thePassword = "dFgH4%6&";
final String ourContextURL = request.getScheme() + "://" + request.getServerName() + request.getContextPath();
//final String reportingURL = "http://reporting.monea.isotoma.com/reports/";
final String reportingURL = "https://{{ env.sitename }}/reports/";
final String loginURL = ourContextURL + "/do/login";
// End Config


User loggedUser = (User) session.getAttribute("loggedUser");
if (loggedUser != null) {
  
  // Are we an admin? If we fail to get the attribute from the session, assume non admin.
  String isAdmin = "false";
  if (session.getAttribute("isAdmin") != null) {
     isAdmin = session.getAttribute("isAdmin").toString();
  }

  String loggedUserId = loggedUser.getId().toString();

  String timeStamp = new Long(System.currentTimeMillis()/1000).toString();

  String theToken = loggedUserId + ":" + isAdmin + ":" + timeStamp;
  
  byte [] hashInput = new String(theToken + ":" + thePassword).getBytes();
  String theHash = new String(Hex.encodeHex(MessageDigest.getInstance("MD5").digest(hashInput)));

  //If we had a newer version of apache commons we could use a URLsafe base64 - but we don't.
  String hashedToken = theToken + ":" + theHash;
  String base64String = URLEncoder.encode(new String(Base64.encodeBase64(hashedToken.getBytes())),"utf8");

  // Get the report name from the Query string or assume none
  String reportName = "";
  if (request.getParameter("report") != null) {
    reportName = request.getParameter("report");
  }
  
  response.sendRedirect(reportingURL + reportName + "?token=" + base64String);

} else {

  // Well if that didn't work then we probably just aren't logged in so lets redirect to the login page
  response.sendRedirect(loginURL);

} %>

