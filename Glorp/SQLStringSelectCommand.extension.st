Extension { #name : #SQLStringSelectCommand }

{ #category : #'*Glorp' }
SQLStringSelectCommand classSide >> sqlString: aString parameters: aDictionaryOrArray useBinding: aBoolean session: aSession [
	^(self new)
		setSQLString: aString;
		parameters: aDictionaryOrArray;
		useBinding: aBoolean;
		session: aSession.
]
