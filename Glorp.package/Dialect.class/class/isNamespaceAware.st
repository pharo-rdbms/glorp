general portability
isNamespaceAware
	isNamespaceAware isNil
		ifTrue: [ isNamespaceAware := false ].
	^ isNamespaceAware