public
mapFromObject: anObject intoRowsIn: aRowMap

	| target sourceRows targetRows valueDescriptor |
	self canWrite ifFalse: [^self].
	target := self getValueFrom: anObject.
	target := self session realObjectFor: target.
	target := aRowMap mementoFor: target.
	sourceRows := Dictionary new: 3.
	targetRows := Dictionary new: 3.
	descriptor tables do: [:each |
		sourceRows at: each put: (aRowMap findOrAddRowForTable: each withKey: anObject)].
	valueDescriptor := self system descriptorFor: target.
	valueDescriptor isNil ifFalse: [
		valueDescriptor tables do: [:each |
			targetRows at: each put: (aRowMap findOrAddRowForTable: each withKey: target)]].
	toDbMappingBlock value: sourceRows value: target value: targetRows.