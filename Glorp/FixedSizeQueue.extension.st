Extension { #name : #FixedSizeQueue }

{ #category : #'*Glorp' }
FixedSizeQueue classSide >> maximumSize: anInteger [
	^self basicNew maximumSize: anInteger.
]

{ #category : #'*Glorp' }
FixedSizeQueue classSide >> new [
	self error: 'must supply a size'.
]

{ #category : #'*Glorp' }
FixedSizeQueue classSide >> new: anInteger [
	^self maximumSize: anInteger.
]
