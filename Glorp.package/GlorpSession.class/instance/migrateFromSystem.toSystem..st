table creation
migrateFromSystem: from toSystem: to
	| fromTables toTables toDelete toAdd toModify newVersion |
	fromTables := from allTables copy.
	toTables := to allTables copy.
	toDelete := fromTables reject: [:each | 
		toTables anySatisfy: [:otherTable | otherTable sqlString sameAs: each sqlString]].
	toAdd := toTables reject: [:each | 
		fromTables anySatisfy: [:otherTable | otherTable sqlString sameAs: each sqlString]].
	toModify := fromTables reject: [:each | (toDelete includes: each) or: [toAdd includes: each]].
	self doDDLOperation: [
		self createTables: toAdd.
		self dropTables: toDelete.
		toModify do: [:each | 
			newVersion := to tableNamed: each sqlString.
			self updateTableFrom: each to: newVersion]]