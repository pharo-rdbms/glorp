api
getFieldKnownNotToBeAName: aField
	"The public getField method may, for convenience, be passed a string or a constant expression with a string that is a field name. This is a mess, and can be confused with a constant value. This method does not allow that."

	| realField |
	realField := aField.
	realField isGlorpExpression
		ifTrue:
			[realField class == ConstantExpression ifTrue: [^realField].
			realField class == ParameterExpression
				ifTrue: [realField := realField field]].
	^self getFieldThatsAnActualFieldObject: realField.