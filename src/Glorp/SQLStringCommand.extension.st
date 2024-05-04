Extension { #name : 'SQLStringCommand' }

{ #category : '*Glorp' }
SQLStringCommand class >> for: aString [

	^ self new setSQLString: aString
]
