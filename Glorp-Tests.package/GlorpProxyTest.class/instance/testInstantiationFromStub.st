tests
testInstantiationFromStub

	self assert: (proxy getValue notNil).
	self assert: proxy = 42.
	self assert: proxy isInstantiated.