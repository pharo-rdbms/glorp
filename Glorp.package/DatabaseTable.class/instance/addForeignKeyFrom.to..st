fields
addForeignKeyFrom: sourceField to: targetField
	^self
		addForeignKeyFrom: sourceField
		to: targetField
		suffixExpression: nil.