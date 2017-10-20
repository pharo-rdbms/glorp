building objects
newCollectionOfSize: aSize for: aCollectionType
	"Make sure that we can reasonably return aCollectionType. If not, default to something we can"
	| theType |
	theType := self collectionTypeFor: aCollectionType.
	^theType isBehavior ifTrue: [theType new: aSize] ifFalse: [theType copyEmpty: aSize]