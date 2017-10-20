api
descriptorForTable: aTable
	"Return a descriptor that uses aTable. If there is more than one, the choice is random."
	^descriptors detect: [:each | each tables includes: aTable] ifNone: [nil]