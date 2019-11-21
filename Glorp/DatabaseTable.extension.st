Extension { #name : #DatabaseTable }

{ #category : #'*Glorp' }
DatabaseTable classSide >> named: aString [

	^self new name: aString.
]

{ #category : #'*Glorp' }
DatabaseTable classSide >> new [

	^super new initialize.
]
