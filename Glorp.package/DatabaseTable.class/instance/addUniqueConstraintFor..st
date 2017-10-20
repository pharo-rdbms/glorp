fields
addUniqueConstraintFor: sourceFields

	| newConstraint |
	newConstraint := UniqueConstraint
		forTable: self
		fields: sourceFields.
	^uniqueConstraints add: newConstraint