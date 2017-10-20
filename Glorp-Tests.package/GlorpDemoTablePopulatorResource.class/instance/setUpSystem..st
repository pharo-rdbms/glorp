setup
setUpSystem: system 
	| errorBlock |
	login accessor dropTables: ((TableSorter for: system allTables) sort reverse).
	errorBlock := [:ex | Transcript show: ex description; cr. ex pass].
	system platform areSequencesExplicitlyCreated ifTrue: [
		login accessor dropSequences: system allSequences.
		system allSequences do: [:each |
			login accessor createSequence: each ifError: errorBlock]].
	system allTables do: [:each | 
			login accessor createTable: each
				ifError: errorBlock].
	system allTables do: [:each |
			login accessor createTableIndexes: each ifError: errorBlock]. 
	"SQLite3 doesn't support adding/dropping constraints."
	system platform supportsConstraints ifTrue: [
		system allTables do: [:each | 
				login accessor createTableFKConstraints: each ifError: errorBlock]].

	self class needsSetup: false