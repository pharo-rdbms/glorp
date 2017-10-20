fields
addForeignKeyFrom: sourceField to: targetField suffixExpression: suffixExpression
	| newFK |
	newFK := ForeignKeyConstraint
					sourceField: sourceField
					targetField: targetField
					suffixExpression: suffixExpression.
	newFK name: (newFK name , (foreignKeyConstraints size + 1) printString).
	foreignKeyConstraints add: newFK.
	^newFK.