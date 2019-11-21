Extension { #name : #ForeignKeyConstraint }

{ #category : #'*Glorp' }
ForeignKeyConstraint classSide >> sourceField: aDatabaseField targetField: anotherDatabaseField [
	^self
		sourceField: aDatabaseField
		targetField: anotherDatabaseField
		suffixExpression: nil.
]

{ #category : #'*Glorp' }
ForeignKeyConstraint classSide >> sourceField: aDatabaseField targetField: anotherDatabaseField suffixExpression: suffixExpression [
	^(self new)
		sourceField: aDatabaseField targetField: anotherDatabaseField suffixExpression: suffixExpression;
		yourself.
]

{ #category : #'*Glorp' }
ForeignKeyConstraint classSide >> sourceFields: sourceFields targetFields: targetFields [
	^self
		sourceFields: sourceFields
		targetFields: targetFields
		suffixExpression: nil.
]

{ #category : #'*Glorp' }
ForeignKeyConstraint classSide >> sourceFields: sourceFields targetFields: targetFields suffixExpression: suffixExpression [
	^(self new)
		sourceFields: sourceFields targetFields: targetFields suffixExpression: suffixExpression;
		yourself.
]
