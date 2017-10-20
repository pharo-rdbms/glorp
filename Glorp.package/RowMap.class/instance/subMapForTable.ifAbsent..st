private/mapping
subMapForTable: aTable ifAbsent: aBlock 
	^rowDictionary at: aTable ifAbsent: aBlock