Extension { #name : #ScaledDecimal }

{ #category : #'*Glorp-Core' }
ScaledDecimal >> glorpPrintSQLOn: aStream [ 

	self printOn: aStream showingDecimalPlaces: scale
]
