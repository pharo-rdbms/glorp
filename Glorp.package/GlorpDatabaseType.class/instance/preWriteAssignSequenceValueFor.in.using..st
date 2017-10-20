SQL
preWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor
	aDatabaseField defaultValue isNil ifTrue: [^self].
	(aDatabaseRow hasValueFor: aDatabaseField) ifTrue: [^self].
	"Default values will not write if this field is constrained to a primary key generator"
	(aDatabaseRow expectsToGetValueFor: aDatabaseField) ifTrue: [^self].
	aDatabaseRow at: aDatabaseField put: (aDatabaseField defaultValue).