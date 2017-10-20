tests
testMappedFieldsOldProtocol

	self assert: mapping mappedFields asSortedCollection = descriptor primaryTable fields asSortedCollection.

	mapping := descriptor newMapping: ConditionalMapping.
	self assert: mapping mappedFields isEmpty.

	mapping conditionalField: (descriptor primaryTable fieldNamed: 'ID').
	self assert: mapping mappedFields size = 1.	

	mapping if: #testIDLessThan5: then: (mapping1 := DirectMapping from: #blah to: (descriptor primaryTable fieldNamed: 'NAME')).
	self assert: mapping mappedFields asSortedCollection = descriptor primaryTable fields asSortedCollection.