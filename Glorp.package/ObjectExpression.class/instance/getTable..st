api
getTable: aTable
	"This can take a string, a constantExpression containing a string, or a table object"

	| realTable |
	realTable := aTable isString
		ifTrue: [self system tableNamed: aTable]
		ifFalse: [aTable].	"This might be an expression, most notably a constant expression, in which case it either contains a string or a field"
	realTable isGlorpExpression
		ifTrue:
			[realTable value isString
				ifTrue: [realTable := self system tableNamed: realTable value]
				ifFalse: [realTable := realTable value]].
	^self mappingExpressions
		at: realTable
		ifAbsentPut: [TableExpression forTable: realTable basedOn: self].