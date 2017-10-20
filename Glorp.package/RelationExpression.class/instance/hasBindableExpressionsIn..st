preparing
hasBindableExpressionsIn: aCommand
	"Return true if our right-child can be used for binding. We need to do this at this level because the expressions themselves don't know what type they'll be matched against"

	| translated |
	rightChild canBind ifFalse: [^false].
	translated := self convertValueOf: rightChild in: aCommand parameters.
	^self useBindingFor: translated to: leftChild field type in: aCommand.