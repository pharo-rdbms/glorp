preparing
translateField: aDatabaseField
	| translatedField |
	translatedField := (self mapping translateFields: (Array with: aDatabaseField)) first.
	^super translateField: (translatedField isNil ifTrue: [aDatabaseField] ifFalse: [translatedField]).