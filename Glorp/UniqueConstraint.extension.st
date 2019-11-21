Extension { #name : #UniqueConstraint }

{ #category : #'*Glorp' }
UniqueConstraint classSide >> forTable: aTable fields: aCollectionOfFields [

	| instance |
	instance := self new.
	instance forTable: aTable fields: aCollectionOfFields.
	^instance
]
