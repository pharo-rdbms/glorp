Extension { #name : 'AdHocProxy' }

{ #category : '*Glorp' }
AdHocProxy class >> readBlock: aZeroArgumentBlock [

	^self new glorpReadBlock: aZeroArgumentBlock
]
