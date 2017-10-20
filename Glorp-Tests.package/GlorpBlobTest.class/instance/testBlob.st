tests
testBlob
	self helpTestValue: nil.
	self helpTestValue: (ByteArray withAll: #(1 2 3 4 255)).
	stType := String.
	self helpTestValue: 'abcdef'.