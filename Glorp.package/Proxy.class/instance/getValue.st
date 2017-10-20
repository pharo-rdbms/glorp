api
getValue
	self isInstantiated ifTrue: [^value].
	parameters isNil ifTrue: [parameters := Dictionary new: 0].
	[value := query isNil
		ifTrue: [nil]
		ifFalse: [query executeWithParameters: parameters in: session]]
		ensure: [isInstantiated := true].
	self glorpTriggerProxyAction: value.
	^value.