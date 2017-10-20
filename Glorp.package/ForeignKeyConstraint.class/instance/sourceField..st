accessing
sourceField: aField
	self sourceFields isEmpty ifFalse: [self error: 'Adding a field to a non-empty constraint'].
	self sourceFields add: aField.