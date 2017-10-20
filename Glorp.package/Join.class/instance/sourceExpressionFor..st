converting
sourceExpressionFor: source
	
	^((self isConstant: source) or: [source isMappable not]) "This might be a subselect"
		ifTrue: [source]
		ifFalse: [base getParameter: source].