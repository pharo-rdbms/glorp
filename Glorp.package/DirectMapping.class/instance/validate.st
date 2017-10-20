validation
validate
	super validate.
	(field isGlorpExpression and: [self readOnly not]) ifTrue: [self error: 'Mappings to functions cannot be written'].