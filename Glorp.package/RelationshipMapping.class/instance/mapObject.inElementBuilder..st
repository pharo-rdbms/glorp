mapping
mapObject: anObject inElementBuilder: anElementBuilder
	| value session parameters |
	session := descriptor session.
	parameters := self parametersIn: anElementBuilder.
	value := self shouldProxy
		ifTrue:
			[| proxy |
			proxy := (self newProxyIn: anElementBuilder)
				session: session;
				parameters: parameters;
				glorpOwner: anObject.
			"If we know in advance the proxy would return nil, or an empty collection, just put that in rather than the proxy"
			(proxy query shortCircuitEmptyReturn: parameters)
				ifTrue: [proxy getValue]
				ifFalse: [proxy]]
		ifFalse:
			[(self queryFor: anElementBuilder)
				executeWithParameters: parameters
				in: session].
	self setValueIn: anObject to: value.