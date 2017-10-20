converting
converterForStType: aClass

	^self type converterForStType: (aClass isBehavior ifTrue: [aClass] ifFalse: [aClass class]).