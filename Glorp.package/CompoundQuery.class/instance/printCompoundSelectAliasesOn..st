printing
printCompoundSelectAliasesOn: aStream
	"We only want one table. This is a somewhat convoluted way of getting 't1' uniformly appended"
	aStream nextPutAll: ' '.
	self session platform supportsAliasInCompoundQuery ifTrue: [
		primaryQuery tablesToPrint first printSQLOn: aStream withParameters: nil]