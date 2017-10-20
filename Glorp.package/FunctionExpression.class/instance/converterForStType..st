accessing
converterForStType: aClass
	^self type notNil 
		ifTrue: [self type converterForStType: aClass]
		ifFalse: [self field converterForStType: aClass].