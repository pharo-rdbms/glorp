tests
testMissingDescriptor
	self assert: (system descriptorFor: nil) isNil.
	self assert: (system descriptorFor: UndefinedObject) isNil.
	self assert: (system descriptorFor: 3) isNil