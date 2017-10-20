testing
mapsSimpleObject
	"Try to do a fast test for this, to look for the pseudo-descriptors that direct to-many mappings use."
	^self descriptor mappings size = 1 and: [(self descriptor mappingForAttributeNamed: #myValue) notNil].