fields
addForeignKeyFromAll: sourceFields toAll: targetFields suffixExpression: suffixExpression
	| newFK |
	newFK := ForeignKeyConstraint
					sourceFields: sourceFields
					targetFields: targetFields
					suffixExpression: suffixExpression.
	newFK name: (newFK name , (foreignKeyConstraints size + 1) printString).
	^foreignKeyConstraints add: newFK.