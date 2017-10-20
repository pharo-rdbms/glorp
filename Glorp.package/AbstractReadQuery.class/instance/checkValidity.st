validation
checkValidity
	resultClass glorpCanHaveDescriptorDirectly ifFalse: [self error: 'resultClass must be a class'].
	self descriptor isNil ifTrue: [self error: 'No descriptor for ', self resultClass name].
	(ordering notNil and: [self descriptor supportsOrdering not]) ifTrue: [self error: 'The descriptor for ', self resultClass name, ' does not support ordering in queries'].