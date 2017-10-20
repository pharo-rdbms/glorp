mapping
setFieldValue: each in: row from: anObject
	"Try to set the value of the field, which is normally a primary key field, in the row, based on data in the object. Useful for the case where we have only a relationship mapping to the object that holds our primary key, and it is uninstantiated"
	| value |
	(row wrapperAt: each ifAbsent: [FieldValueWrapper new]) hasValue
		ifFalse:
			[value := self valueOfField: each fromObject: anObject ifNone: [^self].
			"We're using this to get primary key fields. Nil is not a useful answer."
			value isNil ifTrue: [^self].
			row at: each put: value]