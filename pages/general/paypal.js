Behaviour.register( {

	'#backButton' : function(button) {
		button.onclick = function() {
			var params = new QueryStringMap();
			if (booleanValue(params.get("fromQuickAccess"))) {
				self.location = pathPrefix + "/home";
			} else {
				history.back();
			}
		}
	}
});
