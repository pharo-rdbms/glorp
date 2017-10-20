printing SQL
printUnqualifiedSQLOn: aStream withParameters: aDictionary
	self leftChild hasImpliedClauses
		ifTrue:
			[| impliedClauses |
			impliedClauses := self leftChild allRelationsFor: self.
			impliedClauses outerJoin: self outerJoin.
			impliedClauses
				printUnqualifiedSQLOn: aStream
				withParameters: aDictionary]
		ifFalse:
			[self
				printBasicUnqualifiedSQLOn: aStream
				withParameters: aDictionary].