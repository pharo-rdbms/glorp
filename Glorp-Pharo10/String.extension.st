Extension { #name : #String }

{ #category : #'*Glorp-Pharo10' }
String >> convertToEncoding: encodingName [

	^ self encodeWith: encodingName
]
