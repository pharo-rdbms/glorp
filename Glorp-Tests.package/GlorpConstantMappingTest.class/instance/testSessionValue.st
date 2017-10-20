tests
testSessionValue
	mappingToClass constantValueIsSession.
	self assert: (mappingToClass constantValueIn: 38)== 38.