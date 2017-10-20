accessing
targetField: aField

	self targetFields isEmpty ifFalse: [self error: 'Adding a field to a non-empty constraint'].
	self targetFields add: aField.