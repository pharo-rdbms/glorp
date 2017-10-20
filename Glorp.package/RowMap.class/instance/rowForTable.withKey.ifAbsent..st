lookup
rowForTable: aTable withKey: aKey ifAbsent: aBlock
	| row |
	row := (self subMapForTable: aTable) at: aKey ifAbsent: aBlock.
	^(self isDeleted: row) ifTrue: [aBlock value] ifFalse: [row]