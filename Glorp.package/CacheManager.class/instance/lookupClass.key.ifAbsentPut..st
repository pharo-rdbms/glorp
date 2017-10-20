querying
lookupClass: aClass key: aKey ifAbsentPut: failBlock

	^(self cacheForClass: aClass) at: aKey ifAbsentPut: failBlock.