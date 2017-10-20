api
classModelFor: aClass
	(self allClasses includes: aClass) ifFalse: [^nil].
	^classModels
		at: aClass
		ifAbsentPut: [self newClassModelFor: aClass]