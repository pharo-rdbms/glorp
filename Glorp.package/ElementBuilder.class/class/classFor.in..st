*Glorp
classFor: anExpression in: aQuery
	
	((aQuery returnsDictionary and: [anExpression == aQuery baseExpression])
		or: [anExpression returnsDictionary])
			ifTrue: [^DictionaryBuilder].
	^self basicClassFor: anExpression in: aQuery.