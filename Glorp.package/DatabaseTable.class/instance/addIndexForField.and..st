indexes
addIndexForField: aField and: anotherField
	^self addIndexForFields: (Array with: aField with: anotherField).