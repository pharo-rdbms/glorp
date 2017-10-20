fields
translateField: aDatabaseField
	| newTable rebuilt |
	rebuilt := aDatabaseField isGlorpExpression
		ifTrue: [aDatabaseField asGlorpExpressionOn: self withUltimateBase: self ultimateBaseExpression]
		ifFalse: [aDatabaseField].
	newTable := self aliasedTableFor: rebuilt table.
	newTable == rebuilt table ifTrue: [^rebuilt].
	^self fieldAliases at: aDatabaseField ifAbsentPut: [rebuilt withTable: newTable].