accessing
addTargetField: aField
	(self targetFields allSatisfy: [:each | aField table = each table]) ifFalse: [self error: 'Fields in foreign key constraints must all have the same target table'].
	self targetFields add: aField.