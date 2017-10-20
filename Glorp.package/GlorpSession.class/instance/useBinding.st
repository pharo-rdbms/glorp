testing
useBinding
	self accessor isNil ifTrue: [^false].
	^self accessor useBinding.