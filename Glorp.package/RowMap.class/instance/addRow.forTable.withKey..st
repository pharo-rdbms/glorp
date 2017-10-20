lookup
addRow: aRow forTable: aTable withKey: aKey 
	| submap |
	aKey isGlorpProxy ifTrue: [self halt].
	submap := self subMapForTable: aTable withKey: aKey.
	submap at: aKey put: aRow.
	^aRow