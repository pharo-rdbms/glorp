private
instVarIndex
	| soughtName |
	attributeIndex == nil ifFalse: [^attributeIndex].
	soughtName := Dialect instVarNameFor: name.
	^attributeIndex := self classModel describedClass allInstVarNames 
				indexOf: soughtName