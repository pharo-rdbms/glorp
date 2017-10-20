accessing
relationshipMappingForField: aField 
	"Return a single, direct mapping for this field. There may conceivably be more than one, but they all have to agree, so it shouldn't matter as far as the value. There may also be none."

	^(self mappingsForFields at: aField ifAbsent: [^nil]) 
		detect: [:each | each isRelationship]
		ifNone: [nil]