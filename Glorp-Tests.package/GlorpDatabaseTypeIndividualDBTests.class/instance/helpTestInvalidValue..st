helpers
helpTestInvalidValue: anObject
	self helpTestValue: anObject
		compareModelWith: [:read :original | read isNil or: [ read test ~= original ]]
		compareWith: [:read :original | read ~= original]