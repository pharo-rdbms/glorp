api
getFieldThatsAnActualFieldObject: aField
	"If the field isn't from our table, do a getTable first. If we don't know, assume we can get it directly."

	self controlsTables ifFalse: [^self base getFieldThatsAnActualFieldObject: (self translateField: aField)].
	^((self hasDescriptor not) or: [self tables includes: aField table])
		ifTrue:
			[self mappingExpressions
				at: aField
				ifAbsentPut: [self newFieldExpressionFor: aField]]
		ifFalse: [(self getTable: aField table) getField: aField].