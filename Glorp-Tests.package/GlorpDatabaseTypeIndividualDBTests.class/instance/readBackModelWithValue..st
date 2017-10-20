helpers
readBackModelWithValue: anObject
	^session
		readOneOf: GlorpTypeTestsModelClass
		where: [:each | each test = anObject].