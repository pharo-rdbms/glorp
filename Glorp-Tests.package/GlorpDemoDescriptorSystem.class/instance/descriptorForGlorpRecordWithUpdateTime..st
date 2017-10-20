descriptors/other
descriptorForGlorpRecordWithUpdateTime: aDescriptor
	| table |
	table := self tableNamed: 'RECORD_WITH_UPDATE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping)
		from: #name
		to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping)
		from: #updateTime
		to: (table fieldNamed: 'UPDATE_TIME').
	(aDescriptor newMapping: DirectMapping)
		from: #updateSomeOtherThing
		to: (table fieldNamed: 'UPDATE_OTHER_THING').