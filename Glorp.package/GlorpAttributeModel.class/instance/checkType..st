get/set
checkType: anObject
	(self classModel matches: anObject)
		ifFalse: [self error: 'Wrong type of object']