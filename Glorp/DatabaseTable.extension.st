Extension { #name : #DatabaseTable }

{ #category : #'*Glorp' }
DatabaseTable class >> named: aString [

	^self new name: aString.
]

{ #category : #'*Glorp' }
DatabaseTable class >> new [

	^super new initialize.
]
