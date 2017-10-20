tests
testAddingDescriptors

	self assert: session system == system.
	self assert: system session == session.
	(session descriptorFor: GlorpAddress) session == session.