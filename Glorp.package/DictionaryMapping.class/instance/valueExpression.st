mapping
valueExpression
	 | base intermediate |
	valueMapping isNil ifTrue: [ ^[:each | each value] ].
	base := BaseExpression new.
	intermediate := (self descriptor tables includes: valueMapping mappedFields first table)
		ifTrue: [base] 
		ifFalse: [base getTable: valueMapping mappedFields first table].
	^intermediate getMapping: valueMapping named: #value.