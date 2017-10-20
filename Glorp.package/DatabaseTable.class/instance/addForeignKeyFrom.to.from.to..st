fields
addForeignKeyFrom: sourceField to: targetField from: sourceField2 to: targetField2
	^self
		addForeignKeyFromAll: (Array with: sourceField with: sourceField2)
		toAll: (Array with: targetField with: targetField2)
		suffixExpression: nil.