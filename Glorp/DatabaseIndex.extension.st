Extension { #name : #DatabaseIndex }

{ #category : #'*Glorp' }
DatabaseIndex classSide >> forField: aField [
	^(self new initialize)
		addField: aField;
		yourself
]

{ #category : #'*Glorp' }
DatabaseIndex classSide >> forFields: aCollection [
	^(self new)
		addFields: aCollection;
		yourself
]

{ #category : #'*Glorp' }
DatabaseIndex classSide >> new [
	^super new initialize.
]
