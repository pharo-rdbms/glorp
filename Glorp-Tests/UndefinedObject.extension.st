Extension { #name : #UndefinedObject }

{ #category : #'*Glorp-Tests' }
UndefinedObject >> assertEqual: anObject [
	GlorpTestModelClass new assert: anObject = nil.
]
