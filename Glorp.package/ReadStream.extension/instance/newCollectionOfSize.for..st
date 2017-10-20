*Glorp
newCollectionOfSize: aSize for: aCollectionType

	^aCollectionType isBehavior ifTrue: [aCollectionType new: aSize] ifFalse: [aCollectionType copyEmpty: aSize].