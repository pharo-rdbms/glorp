accessing
allMappingsForField: aField 
	"Return all of the mappings that use this field"
	^mappings select: [:each | each mappedFields includes: aField]