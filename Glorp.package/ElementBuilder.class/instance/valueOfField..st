translating fields
valueOfField: aField
	"aField is either a database field, or a constant expression containing a non-varying value that isn't derived from the row"
	(aField class == ConstantExpression) ifTrue: [^aField value].
	^self row at: (self translateFieldPosition: aField)