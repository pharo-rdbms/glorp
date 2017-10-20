api
getValue
	"This method further modifies the retrieved value using the action block."

	self isInstantiated ifTrue: [^value].
	parameters isNil ifTrue: [parameters := Dictionary new: 0].
	
	[value := query isNil
				ifTrue: [nil]
				ifFalse: [query executeWithParameters: parameters in: session]]
			ensure: [isInstantiated := true].
	value := self glorpTriggerProxyAction: value.
	^value