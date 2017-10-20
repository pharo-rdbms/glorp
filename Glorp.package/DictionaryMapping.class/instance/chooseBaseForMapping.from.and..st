mapping
chooseBaseForMapping: aMapping from: base and: phantomExpression
	aMapping isNil ifTrue: [^base].
	^(aMapping mappedFields
		allSatisfy: [:each | base tables includes: each table])
		ifTrue: [base]
		ifFalse: [phantomExpression]