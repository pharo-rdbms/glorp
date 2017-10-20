mapping
mapObject: anObject inElementBuilder: anElementBuilder
	| value |
	self shouldProxy ifTrue: [
		^self setValueIn: anObject to: ((self newProxyIn: anElementBuilder)
						session: descriptor session;
						parameters: (self parametersIn: anElementBuilder);
						glorpOwner: anObject)].
	value := self valueInBuilder: anElementBuilder.
	self setValueIn: anObject to: value