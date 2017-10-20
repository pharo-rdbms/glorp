testing
usesArrayBindingRatherThanGroupWriting
	"Return true if we use array binding for grouped writes rather than printing the sql multiple times. Only applies if we support grouped writes"
	^self subclassResponsibility.