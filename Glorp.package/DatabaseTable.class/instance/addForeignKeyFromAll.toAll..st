fields
addForeignKeyFromAll: sourceFields toAll: targetFields
	^self addForeignKeyFromAll: sourceFields toAll: targetFields suffixExpression: nil.