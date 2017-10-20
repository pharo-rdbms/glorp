private/restoring
restoreStateOf: original toThatOf: copy 

	(self isShapeOf: original differentThanThatOf: copy) 
		ifTrue: [self restoreShapeOf: original toThatOf: copy].
	self restoreNamedInstanceVariablesOf: original toThoseOf: copy.
	self restoreIndexedInstanceVariablesOf: original toThoseOf: copy