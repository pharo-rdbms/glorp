tests
testFloat4

	self helpTestFloat: nil.
	self helpTestValue: 3.14 compareWith: [:read :original |
		read - original <= 0.00001].