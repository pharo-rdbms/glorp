private
newCollection
	collectionType == GlorpVirtualCollection ifTrue: [^OrderedCollection new].
	^collectionType isBehavior ifTrue: [collectionType new] ifFalse: [collectionType copyEmpty].