Extension { #name : #AdHocProxy }

{ #category : #'*Glorp' }
AdHocProxy classSide >> readBlock: aZeroArgumentBlock [

	^self new glorpReadBlock: aZeroArgumentBlock
]
