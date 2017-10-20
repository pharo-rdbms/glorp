accessing
relationshipMappingsForField: aField 
	"Return all the relationship mappings that use this field, excluding pseudoVariable mappings"

	^(self mappingsForFields at: aField ifAbsent: [^#()]) 
		select: [:each | each isRelationship & each canRead ].