conditions
forField: aField attribute: attributeBlock if: testBlock useMapping: aMapping
	self conditionalField: aField.
	self conditionalMethod: attributeBlock.
	self if: testBlock then: aMapping