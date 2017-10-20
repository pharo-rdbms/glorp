deprecated
addForeignKeyFrom: sourceField toField: targetField

	self deprecated: 'Use #addForeignKeyFrom:to: instead'.	
	^self addForeignKeyFrom: sourceField to: targetField