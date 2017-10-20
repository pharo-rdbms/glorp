accessing
mappingForAttributeNamed: aSymbol

	^mappings detect: [:each | each attributeName == aSymbol] ifNone: [
		self isForAssociation ifTrue: [self valueDescriptor mappingForAttributeNamed: aSymbol]]