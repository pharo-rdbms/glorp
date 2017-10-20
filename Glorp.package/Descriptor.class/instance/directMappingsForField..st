accessing
directMappingsForField: aField 
	"Return all the relationship mappings that use this field"

	^(self mappingsForFields at: aField ifAbsent: [^#()]) 
		reject: [:each | each isRelationship]