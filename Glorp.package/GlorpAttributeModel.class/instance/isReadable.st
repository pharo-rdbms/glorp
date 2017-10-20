validation
isReadable
	self canRead ifFalse: [^false].
	^self useDirectAccess 
		ifTrue: [self instVarIndex > 0]
		ifFalse: [self classModel describedClass canUnderstand: self name]