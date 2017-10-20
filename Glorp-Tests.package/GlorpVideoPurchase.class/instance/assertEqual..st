testing
assertEqual: aPurchase

	self assert: customer name = aPurchase customer name.
	self assert: customer dateOfBirth = aPurchase customer dateOfBirth.
	self assert: store id = aPurchase videoStore id.
	self assert: id = aPurchase id.
	self assert: title = aPurchase title.
	self assert: (price * 1000) rounded = (aPurchase price * 1000) rounded.
	self assert: inStore = aPurchase inStore.