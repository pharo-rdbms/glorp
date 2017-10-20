lookup
rowForTable: aTable withKey: aKey 
	^self rowForTable: aTable withKey: aKey ifAbsent: [self error: 'missing element']