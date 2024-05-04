Extension { #name : 'UniqueConstraint' }

{ #category : '*Glorp' }
UniqueConstraint class >> forTable: aTable fields: aCollectionOfFields [

	| instance |
	instance := self new.
	instance forTable: aTable fields: aCollectionOfFields.
	^instance
]
