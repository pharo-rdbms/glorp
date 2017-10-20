accessing
directMappingForField: aField 
	"Return a single, direct mapping for this field.  There may conceivably be more than one, 
	but they all have to agree, so it shouldn't matter as far as the value. There may also be none.
	Exclude pseudoVariable mappings by ensuring that the detected mapping can be read into an object."

	^(self mappingsForFields at: aField ifAbsent: [^nil]) 
		detect: [:each | each isRelationship not & each canRead]
		ifNone: [nil]