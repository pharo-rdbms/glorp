preparing
addToTargetFields: aCollection
	"If we can provide target fields, add them to the collection"
	lookupKey class == DatabaseField ifTrue: [
		aCollection add: lookupKey].