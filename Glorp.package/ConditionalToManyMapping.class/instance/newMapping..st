accessing
newMapping: aMappingClass
	"Implement this so that we can create our sub-mappings without having them added to the parent descriptor as independent mappings"
	| mapping |
	mapping := aMappingClass new.
	mapping descriptor: self descriptor.
	descriptor resetMappedFields.
	^mapping