internal/writing
commandForRow: aDatabaseRow 
	
	(aDatabaseRow forDeletion) ifTrue: [^DeleteCommand forRow: aDatabaseRow useBinding: self useBinding session: self].
	^(self shouldInsert: aDatabaseRow)
		ifTrue: [^InsertCommand forRow: aDatabaseRow useBinding: self useBinding session: self]
		ifFalse: [^UpdateCommand forRow: aDatabaseRow useBinding: self useBinding session: self]