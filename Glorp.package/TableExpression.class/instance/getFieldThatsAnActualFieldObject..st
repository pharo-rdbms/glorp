api
getFieldThatsAnActualFieldObject: aField

	^self mappingExpressions at: aField ifAbsentPut: [self newFieldExpressionFor: aField].