fields
addForeignKeyFrom: sourceField to: targetField from: sourceField2 to: targetField2 from: sourceField3 to: targetField3
	^self
		addForeignKeyFromAll: (Array with: sourceField with: sourceField2 with: sourceField3)
		toAll: (Array with: targetField with: targetField2 with: targetField3)
		suffixExpression: nil.