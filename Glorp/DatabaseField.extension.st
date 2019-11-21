Extension { #name : #DatabaseField }

{ #category : #'*Glorp' }
DatabaseField classSide >> named: aString [

	^self error: 'type needed'
]

{ #category : #'*Glorp' }
DatabaseField classSide >> named: aString type: dbType [

	^super new initialize
		name: aString;
		type: dbType
]

{ #category : #'*Glorp' }
DatabaseField classSide >> new [

	^self error: 'dbType needed'
]
