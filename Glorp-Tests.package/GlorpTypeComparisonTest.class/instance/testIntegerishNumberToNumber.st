testing
testIntegerishNumberToNumber
	self deny: (GlorpNumericType new platform: platform) = (GlorpNumericType new platform: platform; precision: 2).
	self deny: (GlorpNumericType new platform: platform) hash = (GlorpNumericType new platform: platform; precision: 2) hash.
	self deny: (GlorpNumericType new platform: platform; precision: 2) = (GlorpNumericType new platform: platform).
	self deny: (GlorpNumericType new platform: platform; precision: 2) hash = (GlorpNumericType new platform: platform) hash.