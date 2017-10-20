expression creation
asGlorpExpressionOn: aBaseExpression basedOn: aMessageArchiver withUltimateBase: ultimateBaseExpression
	"We know we are built from aMessageArchiver, but parts of us may refer to an outer scope. Those parts should be built on ultimateBaseExpression rather than aBaseExpression. e.g. consider 
 [:each | each amount amount = ((Query readManyOf: GlorpBankTransaction
			where: [:eachTrans | eachTrans owner = each owner]) 
				retrieve: [:eachTrans | eachTrans amount amount max])]."

	| arguments |
	self == aMessageArchiver ifTrue: [^aBaseExpression].
	myReceiver == nil ifTrue: [^query isNil ifTrue: [ultimateBaseExpression] ifFalse: [query baseExpression]].
	arguments := myArguments
		collect:
			[:each | 
			each
				asGlorpExpressionOn: aBaseExpression
				basedOn: aMessageArchiver
				withUltimateBase: ultimateBaseExpression].
	^self 
		sendMessageTo: (myReceiver
			asGlorpExpressionOn: aBaseExpression
			basedOn: aMessageArchiver
			withUltimateBase: ultimateBaseExpression)
		withArguments: arguments