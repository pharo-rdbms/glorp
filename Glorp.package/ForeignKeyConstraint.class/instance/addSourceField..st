accessing
addSourceField: aField
	(self sourceFields allSatisfy: [:each | aField table = each table]) ifFalse: [self error: 'Fields in foreign key constraints must all have the same source table'].
	self sourceFields add: aField.