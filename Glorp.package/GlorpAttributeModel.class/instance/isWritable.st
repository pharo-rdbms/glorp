validation
isWritable
	self canWrite ifFalse: [^false].
	^self useDirectAccess 
		ifTrue: [self instVarIndex > 0]
		ifFalse: [self classModel describedClass canUnderstand: self setSelector]