expression creation
asGlorpExpressionOn: aBaseExpression 
	| arguments |
	myReceiver == nil ifTrue: [^query isNil ifTrue: [aBaseExpression] ifFalse: [query baseExpression]].
	arguments := myArguments collect: [:each | each asGlorpExpressionOn: aBaseExpression].
	^self sendMessageTo: (myReceiver asGlorpExpressionOn: aBaseExpression) withArguments: arguments