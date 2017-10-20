tests
testConstantInClass
	slot := nil.
	mappingToClass mapObject: self inElementBuilder: nil.
	self assert: slot = 34.