accessing
collectionType
	"Note that queries default the collection type to array, while mappings default to OrderedCollection. I think it makes sense"
	collectionType isNil ifTrue: [collectionType := Array].
	^collectionType.