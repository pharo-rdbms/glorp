Extension { #name : #UndefinedObject }

{ #category : #'*Glorp-Unit-Tests' }
UndefinedObject >> assertEqual: anObject [
	GlorpTestModelClass new assert: anObject = nil.
]
