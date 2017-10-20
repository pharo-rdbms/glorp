executing
dropConstraint: aConstraint ifError: aBlock
	| dropString |
	self platform supportsConstraints ifFalse: [^self].
	dropString := self platform createConstraintDropStatement: aConstraint.
	dropString isEmpty ifTrue: [^self].
	self
		executeInDDLOperation: [ self executeSQLStringNoResult: dropString ]
		ifError:aBlock