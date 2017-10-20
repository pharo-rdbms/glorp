mapping
isValidTarget: anObject

	^anObject isGlorpProxy
		ifTrue: [anObject isInstantiated]
		ifFalse: [true].