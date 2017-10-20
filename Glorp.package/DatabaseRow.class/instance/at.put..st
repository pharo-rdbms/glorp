accessing
at: aField put: aValue 
	
	"For generated fields, we expect the real value to be provided later by the database, so don't write a nil value"
	
	| wrapper |
"	aValue isGlorpExpression ifTrue: [self error: 'cannot store expressions in rows']."
	aField table == self table ifFalse: [self error: 'Invalid table'].
	wrapper := self contentsAt: aField ifAbsentPut: [FieldValueWrapper new].
	(aValue isNil and: [aField isGenerated]) ifFalse: [wrapper contents: aValue].
	wrapper isNowContainedBy: self and: aField.
	^wrapper.