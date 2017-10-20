accessing
isKindOf: aClass
	self isInstantiated ifTrue: [^value isKindOf: aClass].
	^false