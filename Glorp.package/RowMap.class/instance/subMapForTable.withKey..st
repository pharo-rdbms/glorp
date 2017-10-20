private/mapping
subMapForTable: aTable withKey: anObject 
	anObject isGlorpProxy ifTrue: [self halt].
	^rowDictionary at: aTable
		ifAbsentPut: [(self dictionaryClassRequiredForKey: anObject) new]