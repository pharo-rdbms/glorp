indexes
addIndexForField: aField and: anotherField and: thirdField
	^self addIndexForFields: (Array with: aField with: anotherField with: thirdField).