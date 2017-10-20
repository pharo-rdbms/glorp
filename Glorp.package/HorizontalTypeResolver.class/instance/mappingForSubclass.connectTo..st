query setup
mappingForSubclass: aDescriptor connectTo: existingSubclassMapping
	"Create a pseudo-mapping for the subclass."
	| attributeName mapping newJoin |
	attributeName := self pseudoAttributeNameForClass: aDescriptor describedClass.
	mapping := self rootDescriptor mappingForAttributeNamed: attributeName.
	mapping isNil ifTrue: [
		rootDescriptor classModel newAttributeNamed: attributeName type: aDescriptor describedClass.
		mapping := (rootDescriptor newMapping: OneToOneMapping)
			attributeName: attributeName.
		mapping beForPseudoVariable.
		existingSubclassMapping isNil ifFalse: [
			newJoin := Join new.
			mapping join: newJoin]].
	^mapping