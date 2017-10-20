api
getField: aField
	| realField |
	realField := aField isString
		ifTrue: [self findFieldNamed: aField]
		ifFalse: [aField].
	"This might be an expression, most notably a constant expression, in which case it either contains a string or a field. This is awfully ugly"
	realField isGlorpExpression
		ifTrue:
			[realField class == ConstantExpression
				ifTrue:
					[realField := realField value isString
						ifTrue: [realField := self findFieldNamed: realField value]
						ifFalse: [realField]]].
	^self getFieldKnownNotToBeAName: realField.