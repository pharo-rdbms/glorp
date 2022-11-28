Extension { #name : #FixedSizeQueue }

{ #category : #'*Glorp' }
FixedSizeQueue class >> maximumSize: anInteger [
	^self basicNew maximumSize: anInteger.
]

{ #category : #'*Glorp' }
FixedSizeQueue class >> new [
	self error: 'must supply a size'.
]

{ #category : #'*Glorp' }
FixedSizeQueue class >> new: anInteger [
	^self maximumSize: anInteger.
]
