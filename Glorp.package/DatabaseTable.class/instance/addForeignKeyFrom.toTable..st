fields
addForeignKeyFrom: sourceField toTable: targetTable
	^self
		addForeignKeyFrom: sourceField
		to: (targetTable fieldNamed: 'ID' ifAbsent: [^nil])