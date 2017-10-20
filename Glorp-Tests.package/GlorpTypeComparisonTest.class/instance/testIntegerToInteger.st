testing
testIntegerToInteger
	self assert: (GlorpIntegerType new platform: platform) = (GlorpIntegerType new platform: platform).
	self assert: (GlorpIntegerType new platform: platform) hash = (GlorpIntegerType new platform: platform) hash.