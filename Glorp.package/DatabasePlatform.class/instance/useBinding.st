testing
useBinding
	"Return true if we should use binding"

	self supportsBinding ifFalse: [^false].
	useBinding isNil ifTrue: [useBinding := self class useBindingIfSupported].
	^useBinding