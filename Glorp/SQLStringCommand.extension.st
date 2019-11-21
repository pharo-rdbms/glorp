Extension { #name : #SQLStringCommand }

{ #category : #'*Glorp' }
SQLStringCommand classSide >> for: aString [
	^self new setSQLString: aString.
]
