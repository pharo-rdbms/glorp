building objects
collectionTypeFor: aCollectionType
	"Make sure that we can reasonably return aCollectionType. If not, default to something we can"

	aCollectionType class == GlorpDictionaryDescription ifFalse: [^aCollectionType].
	self buildersThatReturnResults size = 1 ifTrue: [^aCollectionType].
	^Array