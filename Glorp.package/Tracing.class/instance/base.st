accessing
base
	^query isNil ifTrue: [base] ifFalse: [query baseExpression]