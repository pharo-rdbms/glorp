accessing
conditionalField: aField

	(conditionalField notNil and: [conditionalField ~~ aField]) ifTrue: [self error: 'You can only test one field in a conditional mapping'].
	conditionalField := aField