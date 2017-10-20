instance creation
forTable: aDatabaseTable basedOn: aBaseExpression

	^(self new) 
		table: aDatabaseTable base: aBaseExpression; 
		yourself