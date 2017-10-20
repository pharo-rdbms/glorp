bound values
bindings
	^(self shouldUseGroupWriting)
		ifTrue: [self platform bindingsForGroupWritingFor: self]
		ifFalse: [self singleRowBindings].