preparing
prepare
	prepared ifTrue: [^self].
	self setupTracing.
	whereClause prepareIn: self.
	self assignTableAliases.
	self fixJoins.
	self computeFields.
	prepared := true.