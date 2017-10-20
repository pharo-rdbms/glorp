testing
testIntegerToIntegerishNumber
	self assert: (GlorpIntegerType new platform: platform) = (GlorpNumericType new platform: platform).
	self assert: (GlorpIntegerType new platform: platform) hash = (GlorpNumericType new platform: platform) hash.
	self assert: (GlorpNumericType new platform: platform) = (GlorpIntegerType new platform: platform).
	self assert: (GlorpNumericType new platform: platform) hash = (GlorpIntegerType new platform: platform) hash.