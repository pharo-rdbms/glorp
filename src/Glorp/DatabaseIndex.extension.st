Extension { #name : #DatabaseIndex }

{ #category : #'*Glorp' }
DatabaseIndex class >> forField: aField [
	^(self new initialize)
		addField: aField;
		yourself
]

{ #category : #'*Glorp' }
DatabaseIndex class >> forFields: aCollection [
	^(self new)
		addFields: aCollection;
		yourself
]
