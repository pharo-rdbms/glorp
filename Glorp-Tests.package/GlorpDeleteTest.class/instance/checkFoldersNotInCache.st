tests
checkFoldersNotInCache
	self assert: (session cacheLookupForClass: GlorpFolder key: #(1 'One')) isNil.
	self assert: (session cacheLookupForClass: GlorpFolder key: #(1 'One-A')) isNil.