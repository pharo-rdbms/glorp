Extension { #name : #AdHocVersionGenerator }

{ #category : #'*Glorp' }
AdHocVersionGenerator classSide >> block: aBlock [
	^self new block: aBlock.
]
