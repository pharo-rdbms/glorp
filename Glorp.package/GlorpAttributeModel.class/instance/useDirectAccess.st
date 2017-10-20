testing
useDirectAccess
	useDirectAccess isNil ifFalse: [^useDirectAccess].
	self system isNil ifTrue: [^true].  "A global default, although only applicable if we're not in a valid setup"
	^self system useDirectAccessForMapping.