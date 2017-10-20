api
descriptorsForTable: aTable
	"Return all descriptors that use aTable."
	^descriptors select: [:each | each tables includes: aTable]