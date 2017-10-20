accessing
conditionalMethod: aSymbol
	(conditionalMethod notNil and: [conditionalMethod ~~ aSymbol]) ifTrue: [self error: 'You can only test one attribute in a conditional mapping'].
	conditionalMethod := aSymbol