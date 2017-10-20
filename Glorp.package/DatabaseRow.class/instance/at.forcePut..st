private
at: aField forcePut: aValue 
	"Write the value. If there's a previous value, overwrite it. Use with extreme caution."
	| wrapper |
	aValue isGlorpExpression ifTrue: [self error: 'cannot store expressions in rows'].
	aField table == self table ifFalse: [self error: 'Invalid table'].
	wrapper := self contentsAt: aField ifAbsentPut: [FieldValueWrapper new].
	wrapper privateSetContents: aValue.
	^wrapper.