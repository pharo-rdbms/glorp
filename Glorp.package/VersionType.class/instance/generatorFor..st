initializing
generatorFor: aDatabaseType
	aDatabaseType impliedSmalltalkType == Integer ifTrue: [^VersionNumberVersionGenerator new].
	aDatabaseType impliedSmalltalkType == Dialect timestampClass ifTrue: [^TimestampVersionGenerator new].
	self error: 'unknown version type'.