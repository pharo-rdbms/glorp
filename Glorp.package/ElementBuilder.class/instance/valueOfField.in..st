translating fields
valueOfField: aField in: aRow
	"Since the elementBuilder now holds the row, #valueOfField: is preferred protocol, but some things (e.g. ad hoc mapping blocks) might still be using this, so left for compatibility"
	(aField class == ConstantExpression) ifTrue: [^aField value].
	^aRow at: (self translateFieldPosition: aField)