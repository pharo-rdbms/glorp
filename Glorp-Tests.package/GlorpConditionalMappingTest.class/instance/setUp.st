support
setUp
	super setUp.
	descriptor := system descriptorFor: GlorpPassenger.
	mapping := descriptor newMapping: ConditionalMapping.
	mapping conditionalField: (descriptor primaryTable fieldNamed: 'ID').
	mapping if: #testIDLessThan5: then: (mapping1 := DirectMapping from: #blah to: (descriptor primaryTable fieldNamed: 'ID')).
	mapping if: #testIDMoreThan5: then: (mapping2 := DirectMapping from: #bletch to: (descriptor primaryTable fieldNamed: 'NAME')).
	mapping otherwise: (mapping3 := DirectMapping from: #bazoomer to: (descriptor primaryTable fieldNamed: 'ID')).
	mapping conditionalMethod: #id.