As yet unclassified
useBindingFor: aValue to: aType in: aCommand
	"Return true if we can use binding for our right child's value, in the context of this command"
	aCommand useBinding ifFalse: [^false].
	self expectsCollectionArgument ifTrue: [^false].
	^aCommand canBind: aValue to: aType.