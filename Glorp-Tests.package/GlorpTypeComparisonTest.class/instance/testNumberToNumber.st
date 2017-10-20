testing
testNumberToNumber
	self assert: (GlorpNumericType new platform: platform; precision: 2) = (GlorpNumericType new platform: platform; precision: 2).
	self assert: (GlorpNumericType new platform: platform; precision: 2) hash = (GlorpNumericType new platform: platform; precision: 2) hash.
	self assert: (GlorpNumericType new platform: platform; precision: 2) = (GlorpNumericType new platform: platform; precision: 2).
	self assert: (GlorpNumericType new platform: platform; precision: 2) hash = (GlorpNumericType new platform: platform; precision: 2) hash.