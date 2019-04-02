Behaviour.register({
	'a.payCharityLink': function(a) {
		setPointer(a);
		a.onclick = function() {
			
			var id = a.getAttribute("elementId");
			var path, paramName;
			
			path = "/recurringPayment";
			paramName = "to";
			
			self.location = pathPrefix + path + "?" + paramName + "=" + id;
		}
	}
});