mapping
applicableMappingForRow: anArray in: anElementBuilder
	"If a conditional field has been specified, then pass in the extracted value. Otherwise pass in the whole row"
	| rowValue |
	rowValue := conditionalField isNil
		ifFalse: [anElementBuilder valueOfField: conditionalField in: anArray]
		ifTrue: [anArray].
	^self applicableMappingForConditionalValue: rowValue