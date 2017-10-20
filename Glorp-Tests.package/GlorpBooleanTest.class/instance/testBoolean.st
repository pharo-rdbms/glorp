tests
testBoolean
	stType := Boolean.
	self helpTestValue: nil compareWith: [:read :original |
		self platform usesNullForFalse ifTrue: [read = false] ifFalse: [read = nil]].
	self helpTestValue: true.
	self helpTestValue: false.