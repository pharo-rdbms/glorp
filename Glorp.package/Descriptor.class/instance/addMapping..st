accessing
addMapping: aMapping 
	self basicAddMapping: aMapping.
	aMapping hasAttribute ifTrue: [
		(aMapping classModel attributeNamed: aMapping attribute name) == aMapping attribute ifFalse: [self error: 'If you have a classModel you must use newMapping: rather than addMapping:']]