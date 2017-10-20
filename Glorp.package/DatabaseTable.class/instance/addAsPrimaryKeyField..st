private/fields
addAsPrimaryKeyField: aField

	(fields includes: aField) ifFalse: [self error: 'Primary key field not part of the table'].
	aField isPrimaryKey ifFalse: ["Somebody is calling this as API, since there's an example out on the net that does it that way - just do the right thing instead"
		^aField bePrimaryKey].
	(primaryKeyFields notNil and: [primaryKeyFields includes: aField]) ifTrue: [^self].
	primaryKeyFields := primaryKeyFields isNil ifTrue: [Array with: aField] ifFalse: [primaryKeyFields, (Array with: aField)].