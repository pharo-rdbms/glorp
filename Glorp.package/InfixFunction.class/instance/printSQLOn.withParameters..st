printing
printSQLOn: aStream withParameters: aDictionary
	| translated |
	base printSQLOn: aStream withParameters: aDictionary.
	self printsIntoJoins ifFalse: [^self].
	1 to: self functionParts size do: [:i |
		aStream 
			nextPut: $ ;
			nextPutAll: (self functionParts at: i);
			nextPut: $ .
		i > arguments size ifFalse: [ 
			translated := self convertValueOf: (arguments at: i) in: aDictionary.
			translated isGlorpExpression
				ifTrue: [translated printSQLOn: aStream withParameters: aDictionary]
				ifFalse: [self type print: translated on: aStream]]].