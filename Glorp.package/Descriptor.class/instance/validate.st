validation
validate
	"Do any tests we can to make sure that this definition makes sense in this context"
	| readableMappings attributeNames |
	self system validateDescriptor: self.
	self mappings do: [:eachMapping |
		eachMapping validate].
	"Validate that we have at most one readable mapping for an instance variable"
	readableMappings := self mappings select: [:each | each canRead and: [each isTypeMapping not and: [each attributeName isEmpty not]]].
	attributeNames := readableMappings collect: [:each | each attributeName].
	(attributeNames asSet size = readableMappings size) 
		ifFalse: [MultipleMappingsForInstanceVariable new
					model: self describedClass;
					readableMappings: readableMappings;
					signal].

	self typeResolver validate.