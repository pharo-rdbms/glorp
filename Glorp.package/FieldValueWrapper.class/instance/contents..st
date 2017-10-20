public
contents: anObject

	(hasValue and: [contents ~= anObject]) ifTrue: [self error: 'Inconsistent values in field'].
	self privateSetContents: anObject