accessing
fieldsForSelectStatement
	| myFields inheritedFields |
	myFields := self mappedFields.
	inheritedFields := self typeResolver fieldsForSelectStatement.
	^inheritedFields isEmpty ifTrue: [myFields] ifFalse: [myFields, inheritedFields]