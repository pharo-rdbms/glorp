printing SQL
printSQLOn: aStream withParameters: aDictionary
	self leftChild hasImpliedClauses
		ifTrue:
			[| impliedClauses |
			impliedClauses := self leftChild allRelationsFor: self.
			impliedClauses outerJoin: self outerJoin.
			impliedClauses
				printSQLOn: aStream
				withParameters: aDictionary]
		ifFalse:
			[self
				printBasicSQLOn: aStream
				withParameters: aDictionary].