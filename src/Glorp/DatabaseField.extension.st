Extension { #name : #DatabaseField }

{ #category : #'*Glorp' }
DatabaseField class >> named: aString [

	^self error: 'type needed'
]

{ #category : #'*Glorp' }
DatabaseField class >> named: aString type: dbType [

	^ super new initialize
		name: aString;
		type: dbType
]

{ #category : #'*Glorp' }
DatabaseField class >> new [

	^self error: 'dbType needed'
]
