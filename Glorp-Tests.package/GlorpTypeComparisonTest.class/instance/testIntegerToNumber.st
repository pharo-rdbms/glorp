testing
testIntegerToNumber
	self deny: (GlorpIntegerType new platform: platform) = (GlorpNumericType new platform: platform; precision: 2).
	self deny: (GlorpIntegerType new platform: platform) hash = (GlorpNumericType new platform: platform; precision: 2) hash.
	self deny: (GlorpNumericType new platform: platform; precision: 2) = (GlorpIntegerType new platform: platform).
	self deny: (GlorpNumericType new platform: platform; precision: 2) hash = (GlorpIntegerType new platform: platform) hash.