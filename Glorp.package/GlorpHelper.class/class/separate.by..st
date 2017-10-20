helpers
separate: aCollection by: aOneArgumentBlock

	^aCollection inject: Dictionary new into: [:dict :each |
		| val |
		val := aOneArgumentBlock value: each.
		(dict at: val ifAbsentPut: [OrderedCollection new]) add: each]