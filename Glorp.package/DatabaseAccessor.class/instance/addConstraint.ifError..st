executing
addConstraint: aConstraint ifError: aBlock
	| addString |
	addString := self platform createConstraintAddStatement: aConstraint.
	addString isEmpty ifTrue: [^self].
	^self
		executeInDDLOperation: [ self executeSQLStringNoResult: addString ]
		ifError: aBlock