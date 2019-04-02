// from basePayment.js

var transferTypeChangeFunction = null;
var transferTypesByCurrency = null
var selfPayment = false;

function updateTransferTypes(tts) {
	if (isEmpty(getValue("to")) && !booleanValue(getValue("toSystem")) && !selfPayment) {
		return;
	}
	tts = tts || transferTypes;
	transferTypes = tts;
	var cell = $('typeCell');
	var showRow = false;
	cell.innerHTML = "";
	var disablePayment = false;

	//Get the transfer types by currency
	transferTypesByCurrency = new Map();
	tts.each(function(tt) {
		var currentTTs = transferTypesByCurrency.get(tt.currencyId)
		if (currentTTs == null) {
			currentTTs = [];
			transferTypesByCurrency.put(tt.currencyId, currentTTs);
		}
		currentTTs.push(tt);
	});

	//Disable those currencies with no transfer types
	var currencyId = getValue("currency");
	var currencySelect = $('currencySelect');
	if (currencySelect) {
		var selectedIndex = currencySelect.selectedIndex;
		for (var i = 0; i < currencySelect.options.length; i++) {
			var option = currencySelect.options[i];
			var currentCurrency = option.value;
			var currentTTs = transferTypesByCurrency.get(currentCurrency);
			option.disabled = isEmpty(currentTTs);
		}
		//When the selected currency was disabled, try to select another one
		if (currencySelect.options[selectedIndex].disabled) {
			var couldSelectAnotherOne = false;
			for (var i = 0; i < currencySelect.options.length; i++) {
				var option = currencySelect.options[i];
				if (!option.disabled) {
					currencySelect.selectedIndex = i;
					currencyId = option.value;
					couldSelectAnotherOne = true;
					break;
				}
			}
			if (!couldSelectAnotherOne) {
				disablePayment = true;
			}
		}
	}
	
	//Get the transfer types for the selected currency
	if (!disablePayment) {
		tts = transferTypesByCurrency.get(currencyId);
		if (isEmpty(tts)) {
			disablePayment = true;
		}
	}
	
	if (!disablePayment && tts != null) {
		if (tts.length == 1) {
			var tt = tts[0];
	
			var hidden = document.createElement("input");
			hidden.setAttribute("id", "type");
			hidden.setAttribute("type", "hidden");
			hidden.setAttribute("name", "type");
			hidden.setAttribute("value", tt.id);
			cell.appendChild(hidden);
			
			var text = document.createElement("input");
			text.setAttribute("class", "InputBoxDisabled");
			text.setAttribute("readonly", "readonly");
			text.setAttribute("size", "40");
			text.setAttribute("value", tt.name);
			cell.appendChild(text);
		} else {
			var select = document.createElement("select");
			select.setAttribute("id", "type");
			select.setAttribute("name", "type");
			cell.appendChild(select);
			select.onchange = function() {
				if (typeof(transferTypeChangeFunction) == 'function') {
					transferTypeChangeFunction();
				}
				updateCustomFields(getValue(this));
			}
			
			tts.each(function(tt) {
				select.options[select.options.length] = new Option(tt.name, tt.id);
			});
			showRow = true;
		}
	}
	(showRow ? Element.show : Element.hide)("typeRow");
	if (disablePayment) {
		disableField("amount");
		disableField("description");
		disableField("submitButton");
		if (typeof noTransferTypeMessage != 'undefined') {
			alert(noTransferTypeMessage);
		}
		setFocus(lastMemberFieldWithFocus)
	} else {
		enableField("amount");
		enableField("description");
		enableField("submitButton");
	}
	if (typeof(afterUpdatingTransferTypes) == 'function') {
		afterUpdatingTransferTypes(tts);
	}
	if (tts && tts.length > 0) {
		updateCustomFields(tts[0].id);
	}
}

function updateCustomFields(ttId) {
	new Ajax.Request(context + "/do/paymentCustomFields", {
	    method: 'post',
		parameters: "typeId=" + ttId,
		onSuccess: updatePaymentFieldsCallback
	})
}
function updatePast() {
	var check = $('setDateCheck');
	if (!check) return;
	var checked = check.checked;
	if (checked) {
		$('pastDate').show();
		$('dateText').focus();
	} else {
		$('pastDate').hide();
		$('dateText').value = '';
	}
	
	if ($("schedulingTypeSelect")) {
		updateSchedulingFields();
	}
}

function prepareForm(form, callback) {
	callback();
}

// end from basePayment.js

function afterSelectingMember(member) {
	setValue("memberId", member == null ? "" : member.id);
	fetchTransferTypes();
}

function fetchTransferTypes() {
	var memberId = getValue("memberId");
	var isToSystem = booleanValue(getValue("toSystem"));
	if (!isToSystem && isEmpty(memberId)) {
		return;
	}
	var params = $H();
	var from = getValue("from");
	params.set("channel", "web");
	params.set("context", "PAYMENT");
	params.set("showCurrency", "true");
	params.set("fromOwnerId", isEmpty(from) ? "0" : from);
	if (isToSystem) {
		params.set("toNature", "SYSTEM");
	} else {
		params.set("toOwnerId", memberId);
	}
	params.set("useBy", "true");
	params.set("scheduling", "true");
	findTransferTypes(params, updateTransferTypes);
}

function afterUpdatingTransferTypes(tts) {
	updateSchedulingFields(false);
}

function selectedTransferTypeAllowsScheduling() {
	if (!$("schedulingTypeSelect")) {
		return false;
	}
	var id = getValue("type");
	var form = document.forms[0];
	var tt = transferTypes.find(function(tt) {return tt.id == id});
	if (tt == null) {
		return false;
	}
	return booleanValue(tt.allowsScheduledPayments);
}

function updateSchedulingFields(focusElement) {
	if (!$("schedulingTypeSelect")) {
		return false;
	}
	$$(".scheduling").each(Element.hide);
	var keepSingle = false;
	var keepMulti = false;
	
	var pastDateChecked = false;
	var check = $('setDateCheck');
	if (check && check.checked) {
		pastDateChecked = true;
	}
	
	if (!pastDateChecked && selectedTransferTypeAllowsScheduling()) {
		$('trSchedulingType').show();
		var type = getValue("schedulingTypeSelect");
		var elementToFocus = null;
		switch(type) {
			case "SINGLE_FUTURE":
				$$('.singlePayment').each(Element.show);
				elementToFocus = 'scheduleForText';
				keepSingle = true;
				break;
			case "MULTIPLE_FUTURE":
				$$('.multiplePayments').each(Element.show);
				elementToFocus = 'paymentCountText';
				keepMulti = true;
				break;
		}
	}
	var todayPlus1Month = dateParser.format(dateAdd(today, 1, JST_FIELD_MONTH));
	if (!keepSingle) {
		$('scheduleForText').value = todayPlus1Month;
		$('singlePaymentContainer').innerHTML = '';
	}
	if (!keepMulti && $('paymentsContainer')) {
		$('paymentCountText').value = '';
		$('firstPaymentDateText').value = dateParser.format(today);
		$('recurrenceNumberText').value = '1';
		$('recurrenceFieldSelect').selectedIndex = 0;
		$('paymentsContainer').innerHTML = '';
	}
	if (focusElement) {
		setFocus(elementToFocus);
	}
}
transferTypeChangeFunction = updateSchedulingFields;

function calculateMultiplePayments(callback) {
	var params = $H();
	params.set('from', getValue('from'));
	params.set('amount', getValue('amount'));
	params.set('date', getValue('dateText'));
	params.set('firstPaymentDate', getValue('firstPaymentDateText'));
	params.set('paymentCount', getValue('paymentCountText'));
	params.set('recurrence.number', getValue('recurrenceNumberText'));
	params.set('recurrence.field', getValue('recurrenceFieldSelect'));
	requestValidation(params, pathPrefix + "/calculatePayments", function(params) {
		generatePayments(params);
		if (callback && params.returnValue) {
			callback();
		}
	});
}

function generatePayments(params) {
	var payments = [];
	if (params.returnValue) {
		try {
			payments = eval(params.xml.getElementsByTagName("payments").item(0).firstChild.data);
		} catch (exception) {
		}
	}

	if (payments.length == 0) {
		$('paymentsContainer').innerHTML = "";
		return;
	}

	var strPayments = '<table class="nested">';
	strPayments += '<tr><th class="tdHeaderContents" width="20%">' + paymentNumberLabel + '</th>';
	strPayments += '<th class="tdHeaderContents" width="40%">' + paymentDateLabel + '</th>';
	strPayments += '<th class="tdHeaderContents" width="40%">' + paymentAmountLabel + '</th></tr>';
	
	payments.each(function(payment, index) {
		strPayments += '<tr><th class="tdHeaderContents">' + (index + 1) + '</th>';
		strPayments += '<td align="center" nowrap>';
		strPayments += '<input type="text" class="newInput dateNoLabel small" name="payments.date" value="' + payment.date + '" size="11">';
		strPayments += '</td>';
		strPayments += '<td align="center" nowrap>';
		strPayments += '<input type="text" class="newInput float small" name="payments.amount" value="' + payment.amount + '" size="12">';
		strPayments += '</td></tr>';
	});
	strPayments += '</table>';
	$('paymentsContainer').innerHTML = strPayments;
	document.getElementsBySelector('input.newInput').each(headBehaviour['input']);
}

function prepareForm(form, callback) {
	var type = getValue("schedulingTypeSelect");
	switch (type) {
		case "SINGLE_FUTURE":
			$('singlePaymentContainer').innerHTML = "<input name='payments.date' value='" + $('scheduleForText').value + "'><input name='payments.amount' value='" + $('amount').value + "'>";
			break;
		case "MULTIPLE_FUTURE":
			if (isEmpty($('paymentsContainer').innerHTML)) {
				$('paymentsContainer').hide();
				calculateMultiplePayments(callback);
				return;
			}
			break;
	}
	callback();
}

var lastMemberFieldWithFocus = null;
Behaviour.register({
// from basePayment.js
	'form': function(form) {
		form.onsubmit = function() {
			var callback = function() {
				if (requestValidation(form)) {
					form.submit();
				}
			};
			prepareForm(form, callback);
			return false;
		}
	},

//	'#description': function(textarea) {
//		new SizeLimit(textarea, 1000);
//	},
	
	'#setDateCheck': function(check) {
		check.onclick = updatePast;
	},
	
// 	
	'#backButton': function(button) {
		button.onclick = function() {
			var params = new QueryStringMap();
			if (booleanValue(params.get("fromQuickAccess"))) {
				self.location = pathPrefix + "/home";
			} else if (!isEmpty(profileMemberId)) {
				self.location = pathPrefix + "/profile?memberId=" + profileMemberId;
			} else {
			    history.back();
			}
		}
	},
	
	'#schedulingTypeSelect': function(select) {
		select.onchange = updateSchedulingFields.bind(self, true);
	},
	
	'#memberUsername': function(input) {
		var div = $('membersByUsername');
		prepareForMemberAutocomplete(input, div, {paramName:"username", enabled:true, exclude: getValue("from")}, 'memberId', 'memberUsername', 'memberName', 'amount', afterSelectingMember);
		input.onfocus = function() {
			lastMemberFieldWithFocus = this;
		}
	},
	
	'#memberName': function(input) {
		var div = $('membersByName');
		prepareForMemberAutocomplete(input, div, {paramName:"name", enabled:true, exclude: getValue("from")}, 'memberId', 'memberUsername', 'memberName', 'amount', afterSelectingMember);
		input.onfocus = function() {
			lastMemberFieldWithFocus = this;
		}
	},
	
	'#currencySelect': function(select) {
		select.onchange = function() {
			updateTransferTypes();
			setFocus("amount");
		}
	},
	
	'#calculatePaymentsButton': function(button) {
		button.onclick = function() {
			calculateMultiplePayments();
			$('paymentsContainer').show();
		}
	},
	
	'#recurringAmount': function(input) {
		input.onkeyup = function(event) {
			updateTotalAmount();
		}
	},
	'#paymentCountText': function(input) {
		input.onkeyup = function(event) {
			updateTotalAmount();
		}
	},	
});





function updateTotalAmount(){
	var amount = $('recurringAmount');
	var numPayments = $('paymentCountText');
	var intRegex = /^\d+$/;
	
	if (typeof amount !== undefined && intRegex.test(amount.getValue())) {
   	    var amountInt = parseInt(amount.getValue(), 10);
		
		if(typeof numPayments !== undefined && intRegex.test(numPayments.getValue()))		{
			var numPaymentsInt = parseInt(numPayments.getValue(), 10);
			var totalAmount = amountInt * numPaymentsInt;
//			$('totalAmount').setValue(totalAmount);
			$('amount').setValue(totalAmount);

		} else {
			// prevent cyclos saying that no payment amount has been entered
			$('amount').setValue(amountInt);			
		}
	}
//	alert (numPaymentsInput.getValue());
//	$('amount')
	
}

Event.observe(self, "load", function() {
	// from basePayment.js
	updatePast();
	
	var username = $('memberUsername');
	if (username) {
		username.focus();
	} else {
		getObject("recurringAmount").focus();
	}

	if (!booleanValue(getValue("selectMember"))) {	
		updateTransferTypes();
	}
	setValue("recurringAmount", '');
});


