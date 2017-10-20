api
addClassModelFor: aClass
	^classModels
		at: aClass
		ifAbsentPut: [self newClassModelFor: aClass]