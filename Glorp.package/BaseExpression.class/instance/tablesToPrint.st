preparing
tablesToPrint
	"We derive the base's tables from the fields that are being selected, but make sure that at least the primary table is listed."
	self descriptor tables isEmpty ifTrue: [^#()].
	^Array with: (self aliasedTableFor: self descriptor primaryTable).