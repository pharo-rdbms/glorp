private/mapping
relatedRowsFor: each
	| rows extraRows |
	rows := each relatedRowsIn: rowMap.
	extraRows := self session system additionalRelatedRowsFor: each in: rowMap.
	extraRows isNil ifFalse: [rows addAll: extraRows].
	^rows select: [:eachRelatedRow | eachRelatedRow status notNil]