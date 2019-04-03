knitting
knit: ourObject to: anotherObject
	"Set up the relationship from our object to another one, indicated by our mapping."

	self isCollectionAttribute
		ifTrue: [ | collection |
			collection := self getValueFrom: ourObject.
			(collection isGlorpProxy and: [ collection isInstantiated not ])
				ifTrue: [ collection := self newCollection.
					self setValueIn: ourObject to: collection ].
			anotherObject
				ifNotNil: [ (collection includes: anotherObject)
						ifFalse:
							[ self add: anotherObject to: collection in: ourObject ] ] ]
		ifFalse: [ self setValueIn: ourObject to: anotherObject ]